//
//  MADebugUtility.h
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MADebugUtility : NSObject

+ (NSString *)backtraceOfMainThread;

@end

@interface UIView (MADebugUtility)

- (void)ma_enumerateSuperviewUsingBlock:(void (^)(UIView *superview))usingblock;

- (__kindof UIResponder *)ma_responder;
- (nullable __kindof UIViewController *)ma_responderViewController;
- (NSString *)ma_relations;
- (NSString *)ma_relationsInset:(NSString *)desc;

@end

@interface UIGestureRecognizer (MADebugUtility)

- (nullable id)ma_target;
- (nullable NSString *)ma_action;

@end

NS_ASSUME_NONNULL_END
