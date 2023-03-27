//
//  Action+MADebug.m
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import "Action+MADebug.h"
#import "NSObject+MASwizzle.h"
#import "MADebugLogManager.h"
#import "MADebugUtility.h"

@implementation UIControl (MADebug)

+ (void)load {
    [self.class ma_swizzleMethod:@selector(sendAction:to:forEvent:) usingMethod:@selector(ma_sendAction:to:forEvent:)];
}

- (void)ma_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self ma_sendAction:action to:target forEvent:event];
    MADebugActionLogItem *item = [MADebugActionLogItem new];
    item.className = NSStringFromClass([self class]);
    item.action = NSStringFromSelector(action);
    item.target = NSStringFromClass([target class]);
    item.responser = NSStringFromClass(self.ma_responder.class);
    CGPoint p = [event.allTouches.anyObject locationInView:self.window];
    item.position = [NSValue valueWithCGPoint:p];
    item.relations = self.ma_relations;
    item.date = NSDate.date;
    [MADebugLogManager.shared save:item];
}

@end

@implementation UIView (MADebug)

+ (void)load {
    /// https://github.com/hubbledata/hubbledata-sdk-ios
    [self.class ma_swizzleMethod:@selector(addGestureRecognizer:) usingMethod:@selector(ma_addGestureRecognizer:)];
}

- (void)ma_addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [self ma_addGestureRecognizer:gestureRecognizer];
    if ([gestureRecognizer isKindOfClass:UITapGestureRecognizer.class]) {
        [gestureRecognizer addTarget:self action:@selector(ma_autoTapped:)];
    }
}

- (void)ma_autoTapped:(UITapGestureRecognizer *)g {
    MADebugActionLogItem *item = [MADebugActionLogItem new];
    item.className = NSStringFromClass([g.view class]);
    item.action = g.ma_action;
    item.target = NSStringFromClass([g.ma_target class]);
    item.responser = NSStringFromClass(g.view.ma_responder.class);
    CGPoint p = [g locationInView:g.view.superview];
    item.position = [NSValue valueWithCGPoint:p];
    item.relations = g.view.ma_relations;
    item.date = NSDate.date;
    [MADebugLogManager.shared save:item];
}

@end

@implementation UITableView (MADebug)

+ (void)load {
    [self.class ma_swizzleMethod:@selector(setDelegate:) usingMethod:@selector(ma_debug_setDelegate:)];
}

- (void)ma_debug_setDelegate:(id<UITableViewDelegate>)delegate {
    [self ma_debug_setDelegate:delegate];
    if ([delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        __block NSInvocation *invocation = nil;
        invocation = [delegate.class ma_swizzleMethod:@selector(tableView:didSelectRowAtIndexPath:) usingBlock:^(id obj, UITableView *tableView, NSIndexPath *indexPath) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            MADebugActionLogItem *item = [MADebugActionLogItem new];
            item.className = NSStringFromClass(self.class);
            item.target = NSStringFromClass(delegate.class);
            item.action = NSStringFromSelector(@selector(tableView:didSelectRowAtIndexPath:));
            item.responser = NSStringFromClass(self.ma_responder.class);
            item.position = indexPath;
            item.relations = [self ma_relationsInset:cell.description];
            item.date = NSDate.date;
            [MADebugLogManager.shared save:item];
            [invocation setArgument:&tableView atIndex:2];
            [invocation setArgument:&indexPath atIndex:3];
            [invocation invokeWithTarget:obj];
        }];
    }
}

@end

@implementation UICollectionView (MADebug) 

+ (void)load {
    [self.class ma_swizzleMethod:@selector(setDelegate:) usingMethod:@selector(ma_debug_setDelegate:)];
}

- (void)ma_debug_setDelegate:(id<UICollectionViewDelegate>)delegate {
    [self ma_debug_setDelegate:delegate];
    if ([delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        __block NSInvocation *invocation = nil;
        invocation = [delegate.class ma_swizzleMethod:@selector(collectionView:didSelectItemAtIndexPath:) usingBlock:^(id obj, UICollectionView *collectionView, NSIndexPath *indexPath) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            MADebugActionLogItem *item = [MADebugActionLogItem new];
            item.className = NSStringFromClass(self.class);
            item.target = NSStringFromClass(delegate.class);
            item.action = NSStringFromSelector(@selector(tableView:didSelectRowAtIndexPath:));
            item.responser = NSStringFromClass(self.ma_responder.class);
            item.position = indexPath;
            item.relations = [self ma_relationsInset:cell.description];
            item.date = NSDate.date;
            [MADebugLogManager.shared save:item];
            [invocation setArgument:&collectionView atIndex:2];
            [invocation setArgument:&indexPath atIndex:3];
            [invocation invokeWithTarget:obj];
        }];
    }
}

@end
