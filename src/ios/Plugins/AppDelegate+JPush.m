//
//  AppDelegate+JPush.m
//  delegateExtention
//
//  Created by 张庆贺 on 15/8/3.
//  Copyright (c) 2015年 JPush. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPushPlugin.h"
#import <objc/runtime.h>
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>



@implementation AppDelegate (JPush)

+(void)load{

    Method origin;
    Method swizzle;

    origin=class_getInstanceMethod([self class],@selector(init));
    swizzle=class_getInstanceMethod([self class], @selector(init_plus));
    method_exchangeImplementations(origin, swizzle);
}

-(instancetype)init_plus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLaunch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    return [self init_plus];
}

-(void)applicationDidLaunch:(NSNotification *)notification{
    if (notification) {
        [self registerForIos10RemoteNotification];
        [JPushPlugin setLaunchOptions:notification.userInfo];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginReceiveNotification object:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginReceiveNotification object:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //  [application setApplicationIconBadgeNumber:0];
    //  [application cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:notification.request.content.userInfo];

    [userInfo setValue:kJPushPluginiOS10ForegroundReceiveNotification forKey:@"JPushNotificationType"];

    [[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginiOS10ForegroundReceiveNotification object:userInfo];

    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:response.notification.request.content.userInfo];
    @try {
        [userInfo setValue:[response valueForKey:@"userText"] forKey:@"userText"];
    } @catch (NSException *exception) { }
    [userInfo setValue:response.actionIdentifier forKey:@"actionIdentifier"];
    [userInfo setValue:kJPushPluginiOS10ClickNotification forKey:@"JPushNotificationType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginiOS10ClickNotification object:userInfo];
    completionHandler();
}

-(void)registerForIos10RemoteNotification{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
}

@end
