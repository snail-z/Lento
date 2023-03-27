//
//  MADebugLogManager.h
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import "MADebugLogItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MADebugLogManager : NSObject

+ (instancetype)shared;

/// 是否禁止输出日志，默认NO
@property (nonatomic, assign) BOOL disablePageLog;
@property (nonatomic, assign) BOOL disableActionLog;
@property (nonatomic, assign) BOOL disableNetworkLog;

- (void)save:(MADebugLogItem *)item;

@end

NS_ASSUME_NONNULL_END
