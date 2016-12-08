//
//  DownJacketSearchBar.h
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by zhanghao on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DownJacketSearchBarDelegate;

@interface DownJackets : NSObject

@property (nonatomic, strong) UIImage *image;

@end

@interface DownJacketSearchBar : UIView

@property (nonatomic, strong) NSString  *placeholder;
@property (nonatomic, strong) UIImage   *presetImage;
@property (nonatomic, assign) NSInteger scrollConstraintCount;
@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat textInsetLeft;
@property (nonatomic, weak) id<DownJacketSearchBarDelegate> delegate;

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
