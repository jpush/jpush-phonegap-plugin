//
//  PushTalkPlugin.h
//  PushTalk
//
//  Created by zhangqinghe on 13-12-13.
//
//

#import <Cordova/CDV.h>

#define kJPushPluginReceiveNotification @"JPushPluginReceiveNofication"

@interface JPushPlugin : CDVPlugin{

}

+(void)setLaunchOptions:(NSDictionary *)theLaunchOptions;

//以下为js中可调用接口
//设置标签、别名
-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command;
-(void)setTags:(CDVInvokedUrlCommand*)command;
-(void)setAlias:(CDVInvokedUrlCommand*)command;

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

/*
 *  以下为js中可监听到的事件
 *  jpush.openNotification      点击推送消息唤醒或启动app
 *  jpush.setTagsWithAlias      设置标签、别名完成
 *  jpush.receiveMessage        收到自定义消息
 *  jpush.receiveNotification   前台收到推送消息
 */

@end
