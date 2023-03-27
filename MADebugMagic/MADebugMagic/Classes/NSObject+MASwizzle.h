//
//  NSObject+MASwizzle.h
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MASwizzle)

+ (void)ma_swizzleMethod:(SEL)originalMethod usingMethod:(SEL)swizzledMethod;
+ (NSInvocation *)ma_swizzleMethod:(SEL)originalMethod usingBlock:(id)block;

@end

NS_ASSUME_NONNULL_END
