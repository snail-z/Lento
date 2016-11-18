//
//  DownJacketSearchBar.m
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by 张浩 on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "DownJacketSearchBar.h"
#import "UIView+DownJacketLayout.h"
#import "UITextField+DownJacketDeleteBackward.h"

@implementation DownJackets

@end

@interface DownJacketItem : UIButton

@property (nonatomic, strong) DownJackets *downJackets;

@end

@implementation DownJacketItem

- (void)setDownJackets:(DownJackets *)downJackets {
    _downJackets = downJackets;
    [self setImage:downJackets.image forState:UIControlStateNormal];
}

@end

@interface DownJacketSearchBar ()<DownJacketTextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollContainer;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) DownJacketItem *searchItem;
@property (nonatomic, strong) NSMutableArray<DownJacketItem *> *items;
@property (nonatomic, strong) NSMutableArray<DownJackets *> *dataDownJackets;
@end

@implementation DownJacketSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = 50;
    }
    self = [super initWithFrame:frame];
    if (!self) return nil;
    _dataDownJackets = @[].mutableCopy;
    _items = @[].mutableCopy;
    _scrollConstraintCount = 6;
    
    _scrollContainer = [UIScrollView new];
    _scrollContainer.bounces = NO;
    _scrollContainer.backgroundColor = [UIColor whiteColor];
    [self addSubview:_scrollContainer];
    
    _searchItem = [DownJacketItem new];
    _searchItem.backgroundColor =[ UIColor whiteColor];
    _searchItem.contentMode = UIViewContentModeCenter;
    _searchItem.size = CGSizeMake(self.height / 2, self.height / 2);
    _searchItem.centerY = self.height / 2;
    _scrollContainer.size = CGSizeMake(_searchItem.width, self.height);
    [_scrollContainer addSubview:_searchItem];
    
    _searchTextField = [UITextField new];
    _searchTextField.font = [UIFont systemFontOfSize:15];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [UIColor whiteColor];
    _searchTextField.size = CGSizeMake(self.width - _scrollContainer.width, self.height);
    _searchTextField.x = _scrollContainer.right;
    [self addSubview:_searchTextField];
    
    UIView *horizontalLine = [UIView new];
    horizontalLine.backgroundColor = [UIColor colorWithWhite:0.782 alpha:1.000];
    horizontalLine.size = CGSizeMake(self.width, 1 / UIScreen.mainScreen.scale);
    horizontalLine.y = self.height - horizontalLine.height;
    [self addSubview:horizontalLine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self addObserver:self forKeyPath:@"dataDownJackets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _searchTextField.placeholder = placeholder;
}

- (void)setLeftImage:(UIImage *)leftImage {
    [_searchItem setImage:leftImage forState:UIControlStateNormal];
}

- (void)setNeedsLayout:(CGFloat)scrollWidth {
    _scrollContainer.width = scrollWidth;
    _searchTextField.x = _scrollContainer.right;
    _searchTextField.width = self.width - _scrollContainer.width;
}

- (void)endEditing {
    if ([_searchTextField isFirstResponder]) [_searchTextField resignFirstResponder];
    if (!_dataDownJackets.count) {
        if (![_scrollContainer.subviews containsObject:_searchItem]) {
            [_scrollContainer addSubview:_searchItem];
        }
        [self setNeedsLayout:_searchItem.width];
    } else {
        [self changeStatusToDeselect];
    }
}

#pragma mark - DownJacketTextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!_dataDownJackets.count) {
        [self setNeedsLayout:0];
    }
    [_searchItem removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [_delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!_dataDownJackets.count && !textField.hasText) {
        [self endEditing];
    }
    if ([_delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [_delegate searchBarShouldEndEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidDeleteBackward:(UITextField *)textField {
    if (textField.hasText) return;
    if (!_dataDownJackets.count) {
        [self endEditing];
        return;
    }
    DownJackets *downJackets = [_dataDownJackets lastObject];
    if ([self currentStatus:downJackets]) {
        [self removeDownJackets:downJackets];
    } else {
        [self changeStatusToSelected:downJackets];
    }
}

#pragma mark - Notification center 监听textField文本变化

- (void)textFieldDidChange:(NSNotification *)notification {
    if (!notification) return;
    UITextField *textField = notification.object;
    if (textField == _searchTextField) {
        [self changeStatusToDeselect];
        if ([_delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
            [_delegate searchBar:self textDidChange:textField.text];
        }
    }
    if (!textField.hasText && !_dataDownJackets.count) {
        [self endEditing];
    }
}

#pragma mark - KVO 监听dataDownJackets变化

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"dataDownJackets"]) return;
    if (!_dataDownJackets.count) {
        [self endEditing];
    } else {
        // margin:子视图间距 width:每个子视图的宽高
        CGFloat margin = 7, width = self.height - 20;
        CGFloat scrollContentWidth = _dataDownJackets.count * (margin + width);
        if (_dataDownJackets.count <= self.scrollConstraintCount) {
            [_searchItem removeFromSuperview];
            [self setNeedsLayout:scrollContentWidth];
        }
        [_items enumerateObjectsUsingBlock:^(DownJacketItem * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
            [button setFrame:CGRectMake(idx * (width + margin), margin, width, width)];
            button.center = CGPointMake(button.center.x, self.frame.size.height / 2);
        }];
        [_scrollContainer setContentSize:CGSizeMake(scrollContentWidth, 0)];
        [_scrollContainer setContentOffset:CGPointMake(scrollContentWidth -_scrollContainer.width, 0) animated:YES];
    }
}

#pragma mark - item状态变化

- (BOOL)currentStatus:(DownJackets *)downJackets {
    if (!downJackets) return NO;
    NSInteger idx = [_dataDownJackets indexOfObject:downJackets];
    if (idx < _items.count) {
        DownJacketItem *item = [_items objectAtIndex:idx];
        return item.selected;
    }
    return NO;
}

- (void)changeStatusToSelected:(DownJackets *)downJackets {
    if (!downJackets) return;
    NSInteger idx = [_dataDownJackets indexOfObject:downJackets];
    if (idx < _items.count) {
        DownJacketItem *item = [_items objectAtIndex:idx];
        item.highlighted = YES;
        item.selected = YES;
    }
}

- (void)changeStatusToDeselect {
    __weak typeof(self) _self = self;
    [_dataDownJackets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < _self.items.count) {
            DownJacketItem *item = [_self.items objectAtIndex:idx];
            item.highlighted = NO;
            item.selected = NO;
        }
    }];
}

#pragma mark - 增删处理

- (void)addDownJackets:(DownJackets *)downJackets {
    if (!downJackets || [_dataDownJackets containsObject:downJackets]) {
        return;
    }
    DownJacketItem *item = [DownJacketItem new];
    item.downJackets = downJackets;
    [item addTarget:self action:@selector(downJacketItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_items addObject:item];
    [_scrollContainer addSubview:item];
    [[self mutableArrayValueForKey:@"dataDownJackets"] addObject:downJackets];
    [self changeStatusToDeselect];
}

- (void)downJacketItemClicked:(DownJacketItem *)downJacketItem {
    [self removeDownJackets:downJacketItem.downJackets];
}

- (void)removeDownJackets:(DownJackets *)downJackets {
    if (!downJackets || ![_dataDownJackets containsObject:downJackets] ) {
        return;
    }
    NSInteger idx = [_dataDownJackets indexOfObject:downJackets];
    if (idx < _items.count) {
        DownJacketItem *item = [_items objectAtIndex:idx];
        [item removeFromSuperview];
        [_items removeObjectAtIndex:idx];
        [self changeStatusToDeselect];
        [[self mutableArrayValueForKey:@"dataDownJackets"] removeObject:downJackets];
        if ([_delegate respondsToSelector:@selector(searchBar:removeDownJackets:)]) {
            [_delegate searchBar:self removeDownJackets:downJackets];
        }
    }
}

@end
