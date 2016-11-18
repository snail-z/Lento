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
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <DownJacketTextFieldDelegate> delegate  = (id<DownJacketTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    /**
     1. 交互方法:runtime
     method_exchangeImplementations(deleteBackward, downJacketdeleteBackward);
     也就是外部调用downJacketdeleteBackward就相当于调用了deleteBackward，调用deleteBackward就相当于调用了downJacketdeleteBackward
     2. 此时调用的方法 'downJacketdeleteBackward' 相当于调用系统的 'deleteBackward' 方法,原因是在load方法中进行了方法交换.
     3. 注: 此处并没有递归操作
     4. 在执行自定义方法'downJacketdeleteBackward'之后再去调用'deleteBackward'，可以防止多余删除操作！（可根据实际情况处理调用的先后顺序）
     */
    [self downJacketdeleteBackward];
    [[NSNotificationCenter defaultCenter] postNotificationName:DownJacketTextFieldDidDeleteBackwardNotification object:self];
}

@end
