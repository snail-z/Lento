//
//  UITextField+DownJacketDeleteBackward.h
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by zhanghao on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DownJacketTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;

@end

@interface UITextField (DownJacketDeleteBackward)

@property (nonatomic, weak) id<DownJacketTextFieldDelegate> delegate;

@end

UIKIT_EXTERN NSString * const DownJacketTextFieldDidDeleteBackwardNotification;
