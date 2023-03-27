//
//  MADebugLogItem.h
//  MADebugMagic
//
//  Created by zhang on 2023/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MADebugLogItem : NSObject

/** 时间 */
@property (nonatomic, strong) NSDate *date;

@end

@interface MADebugActionLogItem : MADebugLogItem

/** 所属类 */
@property (nonatomic, copy) NSString *className;

/** 事件动作 */
@property (nonatomic, copy) NSString *action;

/** 事件处理对象 */
@property (nonatomic, copy) NSString *target;

/** 响应者对象 */
@property (nonatomic, copy) NSString *responser;

/** 所属类继承依赖关系 */
@property (nonatomic, copy) NSString *relations;

/** 触摸位置NSValue/NSIndexPath */
@property (nonatomic, strong) id position;

@end

@interface MADebugPageLogItem : MADebugLogItem

/** 当前页面 */
@property (nonatomic, copy) NSString *className;

/** 生命周期状态 */
@property (nonatomic, copy) NSString *state;

@end

@interface MADebugNetworkLogItem : MADebugLogItem

/** 请求头 */
@property (nonatomic, strong) NSDictionary *requestHeaders;

/** 请求参数 */
@property (nonatomic, strong) NSDictionary *requestParameters;

/** 响应参数 */
@property (nonatomic, strong) NSDictionary *responseParameters;

/** 响应时间 */
@property (nonatomic, strong) NSDate *responseDate;

/** 域名 */
@property (nonatomic, copy) NSString *domain;

/** 子分类URL */
@property (nonatomic, copy) NSString *subURL;

/** 设备标识 */
@property (nonatomic, copy) NSString *deviceToken;

@end

NS_ASSUME_NONNULL_END
