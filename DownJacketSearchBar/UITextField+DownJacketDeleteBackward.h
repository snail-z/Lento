//
//  UITextField+DownJacketDeleteBackward.h
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
@protocol DownJacketTextFieldDelegate <UITextFieldDelegate>
<<<<<<< cd4f779617c3ad0b92352922f4baaa56663e26bc
@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
=======

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;

>>>>>>> update
@end

@interface UITextField (DownJacketDeleteBackward)

@property (nonatomic, weak) id<DownJacketTextFieldDelegate> delegate;
<<<<<<< cd4f779617c3ad0b92352922f4baaa56663e26bc
@end

UIKIT_EXTERN NSString * const DownJacketTextFieldDidDeleteBackwardNotification;
=======

@end

UIKIT_EXTERN NSString * const DownJacketTextFieldDidDeleteBackwardNotification;
>>>>>>> update
