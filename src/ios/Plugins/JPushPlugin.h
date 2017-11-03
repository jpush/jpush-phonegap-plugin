//
//  PushTalkPlugin.h
//  PushTalk
//
//  Created by zhangqinghe on 13-12-13.
//
//

#import <Cordova/CDV.h>

static NSMutableDictionary *_jpushEventCache;

@interface JPushPlugin : CDVPlugin{

}

//注册通知服务并启动 SDK
-(void)startJPushSDK:(CDVInvokedUrlCommand*)command;

//以下为js中可调用接口
//设置标签、别名
-(void)setTags:(CDVInvokedUrlCommand*)command;
-(void)addTags:(CDVInvokedUrlCommand*)command;
-(void)deleteTags:(CDVInvokedUrlCommand*)command;
-(void)cleanTags:(CDVInvokedUrlCommand*)command;
-(void)getAllTags:(CDVInvokedUrlCommand*)command;
-(void)checkTagBindState:(CDVInvokedUrlCommand*)command;

-(void)setAlias:(CDVInvokedUrlCommand*)command;
-(void)deleteAlias:(CDVInvokedUrlCommand*)command;
-(void)getAlias:(CDVInvokedUrlCommand*)command;

//获取 RegistrationID
-(void)getRegistrationID:(CDVInvokedUrlCommand*)command;

//页面统计
-(void)startLogPageView:(CDVInvokedUrlCommand*)command;
-(void)stopLogPageView:(CDVInvokedUrlCommand*)command;
-(void)beginLogPageView:(CDVInvokedUrlCommand*)command;

//设置角标到服务器,服务器下一次发消息时,会设置成这个值
//本接口不会改变应用本地的角标值.
-(void)setBadge:(CDVInvokedUrlCommand*)command;
//相当于 [setBadge:0]
-(void)resetBadge:(CDVInvokedUrlCommand*)command;

//应用本地的角标值设置/获取
-(void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command;
-(void)getApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command;

//停止与恢复推送
-(void)stopPush:(CDVInvokedUrlCommand*)command;
-(void)resumePush:(CDVInvokedUrlCommand*)command;
-(void)isPushStopped:(CDVInvokedUrlCommand*)command;

//开关日志
-(void)setDebugModeFromIos:(CDVInvokedUrlCommand*)command;
-(void)setLogOFF:(CDVInvokedUrlCommand*)command;
-(void)crashLogON:(CDVInvokedUrlCommand*)command;

//本地推送
-(void)setLocalNotification:(CDVInvokedUrlCommand*)command;
-(void)deleteLocalNotificationWithIdentifierKey:(CDVInvokedUrlCommand*)command;
-(void)clearAllLocalNotifications:(CDVInvokedUrlCommand*)command;

//地理位置上报 [latitude,longitude]
-(void)setLocation:(CDVInvokedUrlCommand*)command;

//检查用户的推送设置情况
-(void)getUserNotificationSettings:(CDVInvokedUrlCommand*)command;

//ios 10 APIs
-(void)addDismissActions:(CDVInvokedUrlCommand*)command;
-(void)addNotificationActions:(CDVInvokedUrlCommand*)command;

/*
 *  以下为js中可监听到的事件
 *  jpush.openNotification      点击推送消息启动或唤醒app
 *  jpush.receiveMessage        收到自定义消息
 *  jpush.receiveNotification   前台收到推送
 *  jpush.backgroundNotification 后台收到推送
 */

# pragma mark - private

+(void)fireDocumentEvent:(NSString*)eventName jsString:(NSString*)jsString;

+(void)setupJPushSDK:(NSDictionary*)userInfo;

@end

static JPushPlugin *SharedJPushPlugin;

@interface NSDictionary (JPush)
-(NSString*)toJsonString;
@end

@interface NSString (JPush)
-(NSDictionary*)toDictionary;
@end


