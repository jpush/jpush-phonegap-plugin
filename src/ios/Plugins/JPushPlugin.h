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
-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command;
-(void)setTags:(CDVInvokedUrlCommand*)command;
-(void)setAlias:(CDVInvokedUrlCommand*)command;
-(void)getRegistrationID:(CDVInvokedUrlCommand*)command;
-(void)startLogPageView:(CDVInvokedUrlCommand*)command;
-(void)stopLogPageView:(CDVInvokedUrlCommand*)command;

// 设置角标到服务器, 服务器下一次发消息时，会设置成这个值
//本接口不会改变应用本地的角标值.
-(void)setBadge:(CDVInvokedUrlCommand*)command;
//相当于 [setBadge:0]
-(void)resetBadge:(CDVInvokedUrlCommand*)command;


//改变应用本地的角标值.
-(void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command;
//获取应用本地的角标值.
-(void)getApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command;


@end
