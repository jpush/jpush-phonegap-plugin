//
//  AppDelegate+JPush.m
//  delegateExtention
//
//  Created by 张庆贺 on 15/8/3.
//  Copyright (c) 2015年 JPush. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import <objc/runtime.h>
#import "JPushPlugin.h"
#import "JPUSHService.h"

//static char launchNotificationKey;

@implementation AppDelegate (JPush)

+(void)load{
    
    Method origin;
    Method swizzle;
    
    origin=class_getInstanceMethod([self class],@selector(init));
    swizzle=class_getInstanceMethod([self class], @selector(init_plus));
    method_exchangeImplementations(origin, swizzle);
}

-(instancetype)init_plus{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidLaunch:)
                                                 name:@"UIApplicationDidFinishLaunchingNotification"
                                               object:nil];
    return [self init_plus];
}

-(void)applicationDidLaunch:(NSNotification *)notification{

    if (notification) {
        [JPushPlugin setLaunchOptions:notification.userInfo];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [JPUSHService handleRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginReceiveNotification
                                                        object:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [JPUSHService handleRemoteNotification:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPushPluginReceiveNotification
                                                        object:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

}

- (void)application:(UIApplication *)application
  didReceiveLocalNotification:(UILocalNotification *)notification {
  [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//  [application setApplicationIconBadgeNumber:0];
//  [application cancelAllLocalNotifications];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}



//delegate里不能声明变量，所以采用关联对象这种技术绕过这个限制
//-(NSDictionary *)luanchOption{
//    return objc_getAssociatedObject(self, &launchNotificationKey);
//}
//-(void)setLuanchOption:(NSDictionary *)luanchOption{
//    objc_setAssociatedObject(self, &launchNotificationKey, luanchOption, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//-(void)dealloc{
//    self.luanchOption=nil;
//}

@end
