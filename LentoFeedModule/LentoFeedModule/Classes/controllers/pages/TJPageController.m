//
//  TJPageController.m
//  AirTraffic
//
//  Created by zhanghao on 2020/4/12.
//  Copyright © 2020 天九网络科技. All rights reserved.
//

#import "TJPageController.h"

@interface TJPageCollectionView : UICollectionView

/// 触摸点在边缘时(panGestureTriggerBoundary以内)启用多手势
@property (nonatomic, assign) CGFloat panGestureTriggerBoundary;

@end

@implementation TJPageCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    CGFloat boundary = MAX(50, self.panGestureTriggerBoundary);
    if ([gestureRecognizer locationInView:self].x < boundary) {
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    }
    return NO;
}

@end

static NSString* const TJPageCollectionCellIdentifier = @"TJPageCollectionReuseCell";

@interface TJPageCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UIViewController* childVC;

@end

@implementation TJPageCollectionViewCell

- (void)configureViewController:(UIViewController *)childVC {
    _childVC = childVC;
}

- (void)removeChildView {
    if (_childVC.view.superview) {
        [_childVC.view removeFromSuperview];
    }
}

- (void)addChildView {
    if (![self hasOwnerOfViewController:_childVC]) {
        [self.contentView addSubview:_childVC.view];
        _childVC.view.frame = self.contentView.bounds;
        _childVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (BOOL)hasOwnerOfViewController:(UIViewController *)viewController {
    return viewController.view.superview && (viewController.view.superview == self.contentView);
}

@end


@interface TJPageController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) TJPageCollectionView *collectionView;
@property (nonatomic, assign, readonly) NSInteger numberOfPageControllers;

@end

@implementation TJPageController {
    BOOL _dragTriggered;
    BOOL _initialLoaded;
    NSInteger _currentIndex;
    NSInteger _previousIndex;
    NSInteger _willShowIndex;
    NSMutableIndexSet *_draggingIndexSet;
    NSMutableDictionary<NSNumber*, UIViewController*>* _controllerCache;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initialization];
    }
    return self;
}

- (void)_initialization {
    _previousIndex = -1;
    _currentIndex = -1;
    _allowBounces = NO;
    _scrollEnabled = YES;
    _debugLogEnabled = NO;
    _dragTriggered = YES;
    _initialLoaded = YES;
    _infiniteLoopEnabled = NO;
    _announcesEndTransitionIndexChanged = YES;
    _cachePolicy = TJPageControllerCacheAll;
    _controllerCache = [NSMutableDictionary dictionary];
    _draggingIndexSet = [NSMutableIndexSet indexSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    if (self.numberOfPageControllers > 0) {
        _currentIndex = 0;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = self.view.bounds.size;
    self.collectionView.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 如果外部重新布局self.view会导致collectionView布局重置，所以要修正起始选中的位置
    [self scrollToItemAtIndex:_currentIndex animated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.infiniteOfPageControllers;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TJPageCollectionViewCell *pageCell = [collectionView dequeueReusableCellWithReuseIdentifier:TJPageCollectionCellIdentifier forIndexPath:indexPath];
    
    UIViewController *page = [self viewControllerAtIndex:indexPath.item];
    [pageCell configureViewController:page];
    
    return pageCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TJPageCollectionViewCell *pageCell = (id)cell;
    [pageCell addChildView]; // 添加cell的childVC.view
    
    _willShowIndex = indexPath.item;
    
    if (_initialLoaded) { // 首次显示cell后，手动调用`pageControllerDidEndTransition`
        _initialLoaded = NO;
        if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
            [self.delegate pageControllerDidEndTransition:self];
        }
    } else { // 用于提前布局下一个页面
        /// todo... 滚动中触发，数据处理多会造成卡顿...
        if ([self.delegate respondsToSelector:@selector(pageControllerWillDisplayPage:)]) {
            [self.delegate pageControllerWillDisplayPage:self];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TJPageCollectionViewCell *pageCell = (id)cell;
    [pageCell removeChildView]; // 删除前一个cell的childVC.view
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _dragTriggered = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragTriggered = YES;
    
    if (self.announcesEndTransitionIndexChanged) {
        [_draggingIndexSet addIndex:[self currentPage]];
    }
    
    if ([self.delegate respondsToSelector:@selector(pageControllerWillStartTransition:)]) {
        [self.delegate pageControllerWillStartTransition:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self infiniteOfBoundaries];
    
    if (self.announcesEndTransitionIndexChanged) {
        if (_previousIndex != _currentIndex) {
            _previousIndex = _currentIndex;
            if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
                [self.delegate pageControllerDidEndTransition:self];
            }
        } else {
            if (_draggingIndexSet.count > 1) {
                if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
                    [self.delegate pageControllerDidEndTransition:self];
                }
            }
        }
        [_draggingIndexSet removeAllIndexes];
    } else {
        if ([self.delegate respondsToSelector:@selector(pageControllerDidEndTransition:)]) {
            [self.delegate pageControllerDidEndTransition:self];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_dragTriggered) {
        NSInteger oldIndex = _currentIndex;
        _currentIndex = [self currentPage];
        if (oldIndex != _currentIndex) {
            [self clearCacheForCurrentIndex:_currentIndex];// 按策略清理缓存
        }
        
        if ([self.delegate respondsToSelector:@selector(pageController:didUpdateTransition:)]) {
            CGFloat progress = _collectionView.contentOffset.x / _collectionView.frame.size.width;
            if (self.infiniteLoopEnabled) {
                NSInteger integerProgress = (NSInteger)progress;
                CGFloat partProgress = integerProgress % self.numberOfPageControllers;
                progress = partProgress + fabs(progress - integerProgress);
            }
            [self.delegate pageController:self didUpdateTransition:progress];
        }
    }
}

- (NSInteger)currentPage {
    NSInteger page = _collectionView.contentOffset.x / _collectionView.frame.size.width + 0.5;
    if (page >= self.infiniteOfPageControllers) page = (NSInteger)self.infiniteOfPageControllers - 1;
    if (page < 0) page = 0;
    return page;
}

- (void)infiniteOfBoundaries {
    if (self.infiniteLoopEnabled) {
        NSInteger page = _collectionView.contentOffset.x / _collectionView.frame.size.width;
        if (page <= 0) {
            CGFloat offset = self.infiniteOfPageControllers / 2 * self.collectionView.bounds.size.width;
            [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:NO];
        } else if (page >= self.infiniteOfPageControllers - 1) {
            CGFloat offset = (self.infiniteOfPageControllers / 2 - 1) * self.collectionView.bounds.size.width;
            [self.collectionView setContentOffset:CGPointMake(offset, 0) animated:NO];
        }
    }
}

#pragma mark - Cache

- (NSInteger)numberOfPageControllers {
    NSParameterAssert([self.dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]);
    return [self.dataSource numberOfPagesInPageController:self];
}

- (NSInteger)infiniteOfPageControllers {
    NSInteger infiniteOfPages = self.numberOfPageControllers;
    if (self.infiniteLoopEnabled && infiniteOfPages > 1) {
        NSInteger numberOfCache = infiniteOfPages;
        if (self.cachePolicy == TJPageControllerReuseCache) {
            numberOfCache = self.numberOfCached * infiniteOfPages;
        }
        // 使总页数是缓存数量的整倍数且为偶数(控制在5w条左右)
        infiniteOfPages = (NSInteger)(100 / numberOfCache) * 500;
        infiniteOfPages *= numberOfCache;
    }
    return infiniteOfPages;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    switch (self.cachePolicy) {
        case TJPageControllerReuseCache:
            return [self viewControllerForConstantCacheAtIndex:index];
        default:
            return [self viewControllerForCacheAtIndex:index];
    }
}

- (UIViewController *)viewControllerForCacheAtIndex:(NSInteger)index {
    index = self.infiniteLoopEnabled ? (index % self.numberOfPageControllers) : index;
    UIViewController *controller = _controllerCache[@(index)];
    if (!controller) {
        NSParameterAssert([self.dataSource respondsToSelector:@selector(pageController:pageAtIndex:)]);
        controller = [self.dataSource pageController:self pageAtIndex:index];
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
        _controllerCache[@(index)] = controller;
    }
    [self debugLog:@"cache is: %@", _controllerCache];
    return controller;
}

- (UIViewController *)viewControllerForConstantCacheAtIndex:(NSInteger)index {
    if (_controllerCache.count < 1) {
        NSParameterAssert([self.dataSource respondsToSelector:@selector(pageController:pageAtIndex:)]);
        for (NSInteger idx = 0; idx < [self numberOfCached]; idx++) {
            UIViewController *value = [self.dataSource pageController:self pageAtIndex:index];
            [self addChildViewController:value];
            [value didMoveToParentViewController:self];
            _controllerCache[@(idx)] = value;
        }
    }
    NSInteger idx = (NSInteger)(index % _controllerCache.count);
    UIViewController *controller = _controllerCache[@(idx)];
    [self debugLog:@"cache is: %@", _controllerCache];
    return controller;
}

- (void)clearCacheForCurrentIndex:(NSInteger)currentIndex {
    switch (self.cachePolicy) {
        case TJPageControllerIgnoringCache: {
            [self clearCacheForConditions:^BOOL(NSInteger index) {
                return index < currentIndex || index > currentIndex;
            }];
        } break;
        case TJPageControllerNearbyCache: {
            [self clearCacheForConditions:^BOOL(NSInteger index) {
                return index < currentIndex - 1 || index > currentIndex + 1;
            }];
        } break;
        default: break;
    }
}

- (void)clearCacheForConditions:(BOOL (NS_NOESCAPE ^)(NSInteger index))block{
    if (_controllerCache.count < 1) return;
    NSMutableSet *willRemoveKeys = [NSMutableSet set];
    NSArray *allKeys = [_controllerCache allKeys];
    for (NSNumber *key in allKeys) {
        NSInteger index = [key integerValue];
        BOOL isOutsideRange = block(index);
        if (isOutsideRange) {
            [willRemoveKeys addObject:key];
        }
    }
    
    for (NSNumber *aKey in willRemoveKeys) {
        UIViewController *controller = _controllerCache[aKey];
        if (controller) {
            [controller willMoveToParentViewController:nil];
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
            [_controllerCache removeObjectForKey:aKey];
        }
    }
}

- (void)clearAllCache {
    if (_controllerCache.count) {
        for (UIViewController *controller in _controllerCache.allValues) {
            [controller willMoveToParentViewController:nil];
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
        }
        [_controllerCache removeAllObjects];
    }
}

#pragma mark - Methods

- (void)reloadPages {
    [self clearAllCache];
    [self.collectionView reloadData];
    
    NSInteger pagesCount = self.numberOfPageControllers;
    if (pagesCount <= 0) {
        _currentIndex = -1;
    } else {
        _currentIndex = MIN(MAX(0, _currentIndex), pagesCount - 1);
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
    if (currentIndex != _currentIndex) {
        _currentIndex = currentIndex;
        
        [self scrollToItemAtIndex:_currentIndex animated:animated];
        
        _dragTriggered = NO; // 外部触发
    }
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated { // 滚动到指定位置
    if (self.infiniteLoopEnabled) {
        index = self.infiniteOfPageControllers / 2 + self.displayedIndex;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

- (void)setAllowBounces:(BOOL)allowBounces {
    _allowBounces = allowBounces;
    _collectionView.bounces = allowBounces;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    _collectionView.scrollEnabled = scrollEnabled;
}

- (NSInteger)numberOfCached {
    return 2; // 复用策略，需要缓存的数量
}

- (NSInteger)displayedIndex {
    return self.infiniteLoopEnabled ? (_currentIndex % self.numberOfPageControllers) : _currentIndex;
}

- (NSInteger)willDisplayIndex {
    return self.infiniteLoopEnabled ? (_willShowIndex % self.numberOfPageControllers) : _willShowIndex;
}

- (UIViewController *)displayedViewController {
    if (self.displayedIndex < 0 || self.displayedIndex > self.numberOfPageControllers - 1) {
        return nil;
    }
    return [self viewControllerAtIndex:self.displayedIndex];
}

- (UIViewController *)willDisplayViewController {
    if (_willShowIndex < 0 || _willShowIndex > self.infiniteOfPageControllers - 1) {
        return nil;
    }
    return [self viewControllerAtIndex:_willShowIndex];
}

- (TJPageCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = self.view.bounds.size;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[TJPageCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = self.scrollEnabled;
        _collectionView.bounces = self.allowBounces;
        _collectionView.directionalLockEnabled = YES;
        [_collectionView registerClass:[TJPageCollectionViewCell class] forCellWithReuseIdentifier:TJPageCollectionCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}

- (void)debugLog:(NSString *)description, ... {
    if (!self.debugLogEnabled || !description) return;
    va_list args;
    va_start(args, description);
    NSString *message = [[NSString alloc] initWithFormat:description locale:[NSLocale currentLocale] arguments:args];
    va_end(args);
    NSLog(@"** TJPageController ** %@", message);
}

- (void)dealloc {
    [self debugLog:@"%@~~~dealloc✈️", NSStringFromClass(self.class)];
}

@end

