//
//  MADebugLogManager.m
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import "MADebugLogManager.h"

@implementation MADebugLogManager

+ (instancetype)shared {
    static MADebugLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MADebugLogManager alloc] init];
        [instance defaultValues];
    });
    return instance;
}

- (void)defaultValues {
    _disablePageLog = NO;
    _disableActionLog = NO;
    _disableNetworkLog = NO;
}

- (void)save:(MADebugLogItem *)item {
    /// todo 加锁
    [self debugLog:item];
}

- (void)debugLog:(MADebugLogItem *)item {
    if ([item isKindOfClass:MADebugActionLogItem.class] && _disableActionLog) return;
    if ([item isKindOfClass:MADebugPageLogItem.class] && _disablePageLog) return;
    if ([item isKindOfClass:MADebugNetworkLogItem.class] && _disableNetworkLog) return;
    NSString *clsName = NSStringFromClass(item.class);
    NSMutableString *lenName = [NSMutableString string];
    for (int idx = 0; idx < clsName.length; idx++) { [lenName appendString:@"—"]; }
    NSString *prefix = [NSString stringWithFormat:@"\n╭————————————————%@————————————————╮ ", clsName];
    NSString *suffix = [NSString stringWithFormat:@"╰————————————————%@————————————————╯ \n", lenName];
    NSString *desc = [NSString stringWithFormat:@"\n%@%@%@", prefix, item.description, suffix];
    NSLog(@"%@", desc);
}

@end
