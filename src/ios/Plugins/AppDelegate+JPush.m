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
#import "JPushDefine.h"

@implementation AppDelegate (JPush)

+(void)load{
    Method origin1;
    Method swizzle1;
    origin1  = class_getInstanceMethod([self class],@selector(init));
    swizzle1 = class_getInstanceMethod([self class], @selector(init_plus));
    method_exchangeImplementations(origin1, swizzle1);
}

-(instancetype)init_plus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidLaunch:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    return [self init_plus];
}

NSDictionary *_launchOptions;
-(void)applicationDidLaunch:(NSNotification *)notification{

    if (!_jpushEventCache) {
        _jpushEventCache = @{}.mutableCopy;
    }

    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
      NSDictionary *event = @{@"registrationId": registrationID?:@""};
      [JPushPlugin fireDocumentEvent:JPushDocumentEvent_receiveRegistrationId jsString:[event toJsonString]];
    }];
  
    if (notification) {
        if (notification.userInfo) {
          
          if ([notification.userInfo valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
            [JPushPlugin fireDocumentEvent:JPushDocumentEvent_OpenNotification
                                  jsString:[[self jpushFormatAPNSDic: notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey]] toJsonString]];
          }
          
          if ([notification.userInfo valueForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
            UILocalNotification *localNotification = [notification.userInfo valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
            
            NSDictionary* localNotificationEvent = @{@"content":localNotification.alertBody,
                                                     @"badge": @(localNotification.applicationIconBadgeNumber),
                                                     @"extras":localNotification.userInfo,
                                                     };
            [JPushPlugin fireDocumentEvent:JPushDocumentEvent_OpenNotification jsString:[localNotificationEvent toJsonString]];
          }
        }
      
        [JPUSHService setDebugMode];

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:JPushConfig_FileName ofType:@"plist"];
        NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSNumber *delay       = [plistData valueForKey:JPushConfig_Delay];

        _launchOptions = notification.userInfo;

        if (![delay boolValue]) {
            [self startJPushSDK];
        }
    }
}

-(void)startJPushSDK{
    [self registerForRemoteNotification];
    [JPushPlugin setupJPushSDK:_launchOptions];
}

- (void)jpushSDKDidLoginNotification {
  NSDictionary *event = @{@"registrationId": JPUSHService.registrationID};
  [JPushPlugin fireDocumentEvent:JPushDocumentEvent_receiveRegistrationId jsString:[event toJsonString]];
}

- (NSMutableDictionary *)jpushFormatAPNSDic:(NSDictionary *)dic {
  NSMutableDictionary *extras = @{}.mutableCopy;
  for (NSString *key in dic) {
    if([key isEqualToString:@"_j_business"]      ||
       [key isEqualToString:@"_j_msgid"]         ||
       [key isEqualToString:@"_j_uid"]           ||
       [key isEqualToString:@"actionIdentifier"] ||
       [key isEqualToString:@"aps"]) {
      continue;
    }
    extras[key] = dic[key];
  }
  NSMutableDictionary *formatDic = dic.mutableCopy;
  formatDic[@"extras"] = extras;
  return formatDic;
}

-(void)registerForRemoteNotification{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];

    [JPushPlugin fireDocumentEvent:JPushDocumentEvent_ReceiveNotification jsString:[userInfo toJsonString]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    NSString *eventName;
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateInactive:
            eventName = JPushDocumentEvent_OpenNotification;
            break;
        case UIApplicationStateActive:
            eventName = JPushDocumentEvent_ReceiveNotification;
            break;
        case UIApplicationStateBackground:
            eventName = JPushDocumentEvent_BackgroundNotification;
            break;
        default:
            break;
    }

    [JPushPlugin fireDocumentEvent:eventName jsString:[[self jpushFormatAPNSDic:userInfo] toJsonString]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      completionHandler(UIBackgroundFetchResultNewData);
    });
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
  NSMutableDictionary *userInfo = @[].mutableCopy;
  
  if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    userInfo = [self jpushFormatAPNSDic:notification.request.content.userInfo];
  } else {
    UNNotificationContent *content = notification.request.content;
    userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"content": content.body,
                                                               @"badge": content.badge,
                                                               @"extras": content.userInfo
                                                               }];
    userInfo[@"identifier"] = notification.request.identifier;
  }
  
  [JPushPlugin fireDocumentEvent:JPushDocumentEvent_ReceiveNotification jsString:[userInfo toJsonString]];
  completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
  UNNotification *notification = response.notification;
  NSMutableDictionary *userInfo = nil;
  
  if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    userInfo = [self jpushFormatAPNSDic:notification.request.content.userInfo];
  } else {
    UNNotificationContent *content = notification.request.content;
    userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"content": content.body,
                                                               @"badge": content.badge,
                                                               @"extras": content.userInfo
                                                               }];
    userInfo[@"identifier"] = notification.request.identifier;
  }
  
  [JPushPlugin fireDocumentEvent:JPushDocumentEvent_OpenNotification jsString:[userInfo toJsonString]];
  completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
  NSDictionary* localNotificationEvent = @{@"content":notification.alertBody,
                                           @"badge": @(notification.applicationIconBadgeNumber),
                                           @"extras":notification.userInfo,
                                           };
  
    [[NSNotificationCenter defaultCenter] postNotificationName:JPushDocumentEvent_ReceiveLocalNotification object:localNotificationEvent];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //  [application setApplicationIconBadgeNumber:0];
    //  [application cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
