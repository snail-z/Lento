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

NSString * const DownJacketTextFieldDidDeleteBackwardNotification = @"com.zhang.textfield.did.notification";

+ (void)load {
    Method originalSelector = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method swizzledSelector = class_getInstanceMethod([self class], @selector(downJacketdeleteBackward));
    method_exchangeImplementations(originalSelector, swizzledSelector);
}

- (void)downJacketdeleteBackward {
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <DownJacketTextFieldDelegate> delegate  = (id<DownJacketTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DownJacketTextFieldDidDeleteBackwardNotification object:self];
    /*  Method Swizzling
     Reference <http://nshipster.cn/method-swizzling/>
     */
    [self downJacketdeleteBackward];
}

@end
