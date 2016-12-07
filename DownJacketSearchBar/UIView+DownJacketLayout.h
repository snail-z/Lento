//
//  UIView+DownJacketLayout.h
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by zhanghao on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DownJacketLayout)

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat right;    // Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;   // Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat centerX;  // Shortcut for center.x
@property (nonatomic) CGFloat centerY;  // Shortcut for center.y
@property (nonatomic) CGPoint origin;   // Shortcut for frame.origin
@property (nonatomic) CGSize  size;     // Shortcut for frame.size
@end
