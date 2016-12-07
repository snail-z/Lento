//
//  UIView+DownJacketLayout.h
//  <https://github.com/snail-z/DownJacketSearchBar>
//
<<<<<<< cd4f779617c3ad0b92352922f4baaa56663e26bc
//  Created by 张浩 on 16/11/1.
=======
//  Created by zhanghao on 16/11/1.
>>>>>>> update
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
