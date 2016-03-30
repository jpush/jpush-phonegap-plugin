//
//  AppDelegate+JPush.m
//  delegateExtention
//
//  Created by 张庆贺 on 15/8/3.
//  Copyright (c) 2015年 JPush. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPushPlugin.h"
#import "JPUSHService.h"

@implementation AppDelegate (JPush)

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [JPushPlugin setLaunchOptions:launchOptions];

    //cordova didFinishLaunchingWithOptions
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.viewController = [[CDVViewController alloc] init];
    self.window.rootViewController = self.viewController;
    self.window.autoresizesSubviews = YES;
    [self.window makeKeyAndVisible];
    return YES;
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

@end
