//
//  MADebugLogItem.m
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import "MADebugLogItem.h"

@implementation MADebugLogItem

@end

@implementation MADebugActionLogItem

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendFormat:@"\n "];
    [content appendFormat:@"Time: %@\n ", self.date];
    [content appendFormat:@"Class: %@\n ", self.className];
    [content appendFormat:@"Action: %@\n ", self.action];
    [content appendFormat:@"Target: %@\n ", self.target];
    [content appendFormat:@"Responser: %@\n ", self.responser];
    [content appendFormat:@"Position: %@\n", self.debugPositionDesc];
    return content;
}

- (void)setPosition:(id)position {
    _position = position;
    NSParameterAssert([position isKindOfClass:NSIndexPath.class] || [position isKindOfClass:NSValue.class]);
}

- (NSString *)debugPositionDesc {
    if ([_position isKindOfClass:NSIndexPath.class]) {
        NSIndexPath *indexPath = (NSIndexPath *)_position;
        return indexPath.description;
    } else {
        CGPoint p = [(NSValue *)_position CGPointValue];
        return [NSString stringWithFormat:@"<CGPoint> %@", NSStringFromCGPoint(p)];
    }
}

@end

@implementation MADebugPageLogItem

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendFormat:@"\n "];
    [content appendFormat:@"Time: %@\n ", self.date];
    [content appendFormat:@"Class: %@\n ", self.className];
    [content appendFormat:@"State: %@\n", self.state];
    return content;
}

@end

@implementation MADebugNetworkLogItem

- (NSString *)description {
    return [self debugDescription];
}

- (NSString *)debugDescription {
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendFormat:@"\n "];
    [content appendFormat:@"RequestTime: %@\n ", self.date];
    [content appendFormat:@"ResponseTime: %@\n", self.responseDate];
    return content;
}

@end
