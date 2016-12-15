//
//  AppDelegate+JPush.h
//  delegateExtention
//
//  Created by 张庆贺 on 15/8/3.
//  Copyright (c) 2015年 JPush. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"

@interface AppDelegate (JPush) <JPUSHRegisterDelegate>
-(void)registerForRemoteNotification;
-(void)startJPushSDK;
@end
