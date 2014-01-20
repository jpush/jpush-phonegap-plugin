//
//  APService.h
//  APService
//
//  Created by JPush on 12-8-15.
//  Copyright (c) 2012年 HXHG. All rights reserved.
//  Version: 1.6.2

#import <Foundation/Foundation.h>

extern NSString * const kAPNetworkDidSetupNotification;          // 建立连接
extern NSString * const kAPNetworkDidCloseNotification;          // 关闭连接
extern NSString * const kAPNetworkDidRegisterNotification;       // 注册成功
extern NSString * const kAPNetworkDidLoginNotification;          // 登录成功
extern NSString * const kAPNetworkDidReceiveMessageNotification; // 收到消息(非APNS)
extern NSString * const kAPServiceErrorNotification;             // 错误提示


@interface APService : NSObject

// 以下四个接口是必须调用的
+ (void)setupWithOption:(NSDictionary *)launchingOption;      // 初始化
+ (void)registerForRemoteNotificationTypes:(int)types;        // 注册APNS类型
+ (void)registerDeviceToken:(NSData *)deviceToken;            // 向服务器上报Device Token
+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;  // 处理收到的APNS消息，向服务器上报收到APNS消息

// 下面的接口是可选的
// 设置标签和(或)别名（若参数为nil，则忽略；若是空对象，则清空；详情请参考文档：http://docs.jpush.cn/pages/viewpage.action?pageId=3309913）
+ (void)setTags:(NSSet *)tags alias:(NSString *)alias DEPRECATED_ATTRIBUTE;
+ (void)setTags:(NSSet *)tags alias:(NSString *)alias callbackSelector:(SEL)cbSelector target:(id)theTarget;
+ (void)setTags:(NSSet *)tags alias:(NSString *)alias callbackSelector:(SEL)cbSelector object:(id)theTarget;
+ (void)setTags:(NSSet *)tags callbackSelector:(SEL)cbSelector object:(id)theTarget;
+ (void)setAlias:(NSString *)alias callbackSelector:(SEL)cbSelector object:(id)theTarget;
// 用于过滤出正确可用的tags，如果总数量超出最大限制则返回最大数量的靠前的可用tags
+ (NSSet*)filterValidTags:(NSSet*)tags;

+ (NSString *)openUDID; // UDID

@end
