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
    NSDictionary *notificationMessage;
    BOOL    isInline;
    NSString *notificationCallbackId;
    NSString *callback;
    
    BOOL ready;
}

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, copy) NSString *notificationCallbackId;
@property (nonatomic, copy) NSString *callback;

@property (nonatomic, strong) NSDictionary *notificationMessage;
@property BOOL                          isInline;


+(void)setLaunchOptions:(NSDictionary *)theLaunchOptions;
-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command;
-(void)setTags:(CDVInvokedUrlCommand*)command;
-(void)setAlias:(CDVInvokedUrlCommand*)command;
-(void)getRegistrationID:(CDVInvokedUrlCommand*)command;
-(void)startLogPageView:(CDVInvokedUrlCommand*)command;
-(void)stopLogPageView:(CDVInvokedUrlCommand*)command;

-(void)setNotificationMessage:(NSDictionary *)notification;
-(void)notificationReceived;

@end
