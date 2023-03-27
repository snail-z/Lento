//
//  UIViewController+MADebug.m
//  MADebugMagic
//
//  Created by zhang on 2023/3/20.
//

#import "UIViewController+MADebug.h"
#import "NSObject+MASwizzle.h"
#import "MADebugLogManager.h"

@implementation UIViewController (MADebug)

+ (void)load {
    [self.class ma_swizzleMethod:@selector(viewWillAppear:) usingMethod:@selector(ma_viewWillAppear:)];
    [self.class ma_swizzleMethod:@selector(viewWillDisappear:) usingMethod:@selector(ma_viewWillDisappear:)];
}

- (void)ma_viewWillAppear:(BOOL)animated {
    [self ma_viewWillAppear:animated];
    MADebugPageLogItem *item = [MADebugPageLogItem new];
    item.className = NSStringFromClass(self.class);
    item.state = NSStringFromSelector(@selector(viewWillAppear:));
    item.date = NSDate.date;
    [MADebugLogManager.shared save:item];
}

- (void)ma_viewWillDisappear:(BOOL)animated {
    [self ma_viewWillDisappear:animated];
    MADebugPageLogItem *item = [MADebugPageLogItem new];
    item.className = NSStringFromClass(self.class);
    item.state = NSStringFromSelector(@selector(viewWillDisappear:));
    item.date = NSDate.date;
    [MADebugLogManager.shared save:item];
}

@end
