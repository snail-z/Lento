//
//  DownJacketSearchBar.h
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by 张浩 on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//
/**
 *  // TODO : 1. 给textfield加上contentInset
 *            2. 使用autolayout适配布局
 *            3. 取消选中时的scoll动画
 *            4. 增加标题并根据文字长度来显示
 */

#import <UIKit/UIKit.h>
@protocol DownJacketSearchBarDelegate;

@interface DownJackets : NSObject

@property (nonatomic, strong) UIImage *image;
@end

@interface DownJacketSearchBar : UIView

@property (nonatomic, weak) id<DownJacketSearchBarDelegate> delegate;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, assign) NSInteger scrollConstraintCount;  // 默认最多显示6个. 如果选中个数大于scrollConstraintCount，可滚动查看

- (void)addDownJackets:(DownJackets *)downJackets;
- (void)removeDownJackets:(DownJackets *)downJackets;

@end

@protocol DownJacketSearchBarDelegate <NSObject>
@optional
- (BOOL)searchBarShouldBeginEditing:(DownJacketSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(DownJacketSearchBar *)searchBar;
- (void)searchBar:(DownJacketSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBar:(DownJacketSearchBar *)searchBar removeDownJackets:(DownJackets *)downJackets;

@end
