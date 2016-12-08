//
//  UITextField+DownJacketDeleteBackward.m
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by zhanghao on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import <objc/runtime.h>
#import "UITextField+DownJacketDeleteBackward.h"

@implementation UITextField (DownJacketDeleteBackward)

NSString * const DownJacketTextFieldDidDeleteBackwardNotification = @"com.zhang.downJacketsField.did.notification";

+ (void)load {
    Method originalSelector = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method swizzledSelector = class_getInstanceMethod([self class], @selector(downJacket_deleteBackward));
    method_exchangeImplementations(originalSelector, swizzledSelector);
}

- (void)downJacket_deleteBackward {
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <DownJacketTextFieldDelegate> delegate  = (id<DownJacketTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DownJacketTextFieldDidDeleteBackwardNotification object:self];
    
    // Method Swizzling <http://nshipster.cn/method-swizzling/>
    [self downJacket_deleteBackward];
}

@end
