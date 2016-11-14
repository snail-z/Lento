//
//  UITextField+DownJacketDeleteBackward.m
//  <https://github.com/snail-z/DownJacketSearchBar>
//
//  Created by 张浩 on 16/11/1.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "UITextField+DownJacketDeleteBackward.h"
#import <objc/runtime.h>

@implementation UITextField (DownJacketDeleteBackward)

NSString * const DownJacketTextFieldDidDeleteBackwardNotification = @"com.zhang.textfield.did.notification";

+ (void)load {
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(downJacketdeleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)downJacketdeleteBackward {
    [self downJacketdeleteBackward];
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <DownJacketTextFieldDelegate> delegate  = (id<DownJacketTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DownJacketTextFieldDidDeleteBackwardNotification object:self];
}

@end
