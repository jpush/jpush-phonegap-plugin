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

@end
