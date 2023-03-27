//
//  TJPageController.h
//  AirTraffic
//
//  Created by zhanghao on 2020/4/12.
//  Copyright © 2020 天九网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TJPageControllerCachePolicy) {
    /** 缓存所有加载过的界面(不重用页面) */
    TJPageControllerCacheAll = 0,
    /** 仅缓存邻近的页面(不重用页面) */
    TJPageControllerNearbyCache = 1,
    /** 固定缓存，由外部控制数量(重用页面) */
    TJPageControllerReuseCache = 2,
    /** 不缓存不重用界面，子控制器个数始终为1 */
    TJPageControllerIgnoringCache = 3
};

@protocol TJPageControllerDataSource, TJPageControllerDelegate;

@interface TJPageController : UIViewController

@property (nonatomic, weak, nullable) id<TJPageControllerDataSource> dataSource;
@property (nonatomic, weak, nullable) id<TJPageControllerDelegate> delegate;

/** 当前显示的子控制器的索引 */
@property (nonatomic, assign, readonly) NSInteger displayedIndex;

/** 将要显示的子控制器的索引(页面静止时该值无效) */
@property (nonatomic, assign, readonly) NSInteger willDisplayIndex;

/** 当前显示的子控制器，与currentIndex对应 */
@property (nonatomic, readonly, nullable) __kindof UIViewController* displayedViewController;

/** 将要显示的子控制器，与willDisplayIndex对应 */
@property (nonatomic, readonly, nullable) __kindof UIViewController* willDisplayViewController;

/** 是否启用调试日志，默认NO */
@property (nonatomic, assign) BOOL debugLogEnabled;

/** 是否启用边缘弹性效果，默认NO */
@property (nonatomic, assign) BOOL allowBounces;

/** 是否允许滚动，默认YES */
@property (nonatomic, assign) BOOL scrollEnabled;

/** 是否启用无限循环滚动，默认NO (页面数大于1时有效) */
@property (nonatomic, assign) BOOL infiniteLoopEnabled;

/** 是否仅索引改变后发送页面完成过渡的回调，默认YES */
@property (nonatomic, assign) BOOL announcesEndTransitionIndexChanged;

/** 缓存策略，默认`TJPageControllerCacheAll` */
@property (nonatomic, assign) TJPageControllerCachePolicy cachePolicy;

/** 滚动到指定页面 (调用该方法时不会触发`TJPageControllerDelegate`回调) */
- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;

/** 重载页面所有子视图控制器 (不能在过渡过程中调用该方法) */
- (void)reloadPages;

@end

@protocol TJPageControllerDataSource <NSObject>
@required

/** 分页视图控制器的页面数量 */
- (NSInteger)numberOfPagesInPageController:(TJPageController *)pageController;

/** 返回指定位置的视图控制器 */
- (UIViewController *)pageController:(TJPageController *)pageController pageAtIndex:(NSInteger)index;

@end


@protocol TJPageControllerDelegate <NSObject>
@optional

/** 将要显示的页面(可用于提前布局/预加载) */
- (void)pageControllerWillDisplayPage:(TJPageController *)pageController;

/** 页面将要开始过渡 */
- (void)pageControllerWillStartTransition:(TJPageController *)pageController;

/** 页面正在过渡中(progress-滚动进度) */
- (void)pageController:(TJPageController *)pageController didUpdateTransition:(CGFloat)progress;

/** 页面已经完成过渡 */
- (void)pageControllerDidEndTransition:(TJPageController *)pageController;

@end

NS_ASSUME_NONNULL_END
