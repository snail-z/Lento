//
//  MADebugUtility.m
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import "MADebugUtility.h"
#import <objc/runtime.h>

@implementation MADebugUtility

+ (NSString *)backtraceOfMainThread {
    /// 符号化解析 https://www.jianshu.com/p/df5b08330afd
    return [NSThread.callStackSymbols lastObject];
}

@end

@implementation UIView (MADebugUtility)

- (void)ma_enumerateSuperviewUsingBlock:(void (^)(UIView * _Nonnull))usingblock {
    UIView *view = self.superview;
    while (view) {
        if ([view isMemberOfClass:NSClassFromString(@"UIViewControllerWrapperView")]) break;
        usingblock(view);
        view = view.superview;
    }
}

- (__kindof UIResponder *)ma_responder {
    UIResponder *responder = self.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) break;
        if ([responder isKindOfClass:[UIWindow class]]) break;
        responder = responder.nextResponder;
    }
    return responder;
}

- (__kindof UIViewController *)ma_responderViewController {
    UIResponder *responder = self.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) return (id)responder;
        responder = responder.nextResponder;
    }
    return nil;
}

- (NSString *)ma_relations {
    NSMutableString *relations = [NSMutableString string];
    [relations appendFormat:@"\n%@", self.description];
    [self ma_enumerateSuperviewUsingBlock:^(UIView * _Nonnull superview) {
        [relations appendFormat:@"\n%@", superview.description];
    }];
    UIViewController *value = self.ma_responderViewController;
    [relations appendFormat:@"\n%@", value.description];
    return relations;
}

- (NSString *)ma_relationsInset:(NSString *)desc {
    return [NSString stringWithFormat:@"\n%@%@", desc, self.ma_relations];
}

@end

@implementation UIGestureRecognizer (MADebugUtility)

- (NSDictionary<NSString *,id> *)ma_actionTargetKeyValues {
    /** <https://developer.limneos.net/?ios=11.1.2&framework=UIKit.framework&header=UIGestureRecognizerTarget.h>
     interface UIGestureRecognizerTarget : NSObject
     property (nonatomic,__weak,readonly) id target;
     property (nonatomic,readonly) SEL action;
     */
    Ivar targetsIvar = class_getInstanceVariable(UIGestureRecognizer.class, "_targets");
    id targetActionPairs = object_getIvar(self, targetsIvar);
    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
    Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
    
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    if ([targetActionPairs isKindOfClass:NSArray.class]) {
        id targetActionPair = ((NSArray *)targetActionPairs).firstObject;
        id target = object_getIvar(targetActionPair, targetIvar);
        SEL action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
        [keyValues setValue:target forKey:NSStringFromSelector(action)];
    }
    return keyValues;
}

- (id)ma_target {
    return self.ma_actionTargetKeyValues.allValues.firstObject;
}

- (NSString *)ma_action {
    return self.ma_actionTargetKeyValues.allKeys.firstObject;
}

@end
