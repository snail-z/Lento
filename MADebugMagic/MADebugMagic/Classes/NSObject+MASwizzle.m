//
//  NSObject+MASwizzle.m
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import "NSObject+MASwizzle.h"

#if TARGET_OS_IPHONE
    #import <objc/runtime.h>
    #import <objc/message.h>
#else
    #import <objc/objc-class.h>
#endif

void ma_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)  {
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    // class_addMethod will fail if original method already exists
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // the method doesn’t exist and we just added one
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation NSObject (MASwizzle)

+ (void)ma_swizzleMethod:(SEL)originalMethod usingMethod:(SEL)swizzledMethod {
    ma_swizzleMethod(self, originalMethod, swizzledMethod);
}

+ (NSInvocation *)ma_swizzleMethod:(SEL)originalMethod usingBlock:(id)block {
    IMP blockIMP = imp_implementationWithBlock(block);
    
    NSString *blockSelString = [NSString stringWithFormat:@"_ma_debug_block_%@_%p", NSStringFromSelector(originalMethod), block];
    SEL blockMethod = sel_registerName([blockSelString cStringUsingEncoding:NSUTF8StringEncoding]);
    Method origSelMethod = class_getInstanceMethod(self, originalMethod);
    const char* origSelMethodArgs = method_getTypeEncoding(origSelMethod);
    class_addMethod(self, blockMethod, blockIMP, origSelMethodArgs);

    NSMethodSignature *origSig = [NSMethodSignature signatureWithObjCTypes:origSelMethodArgs];
    NSInvocation *origInvocation = [NSInvocation invocationWithMethodSignature:origSig];
    origInvocation.selector = blockMethod;
    
    ma_swizzleMethod(self, originalMethod, blockMethod);
    return origInvocation;
}

@end
