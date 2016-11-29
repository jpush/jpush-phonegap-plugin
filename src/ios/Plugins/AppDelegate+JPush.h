//
//  AppDelegate+JPush.h
//  delegateExtention
//
//  Created by pikacode@qq.com on 15/8/3.
//  Copyright (c) 2015年 JPush. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService.h"

@interface AppDelegate (JPush) <JPUSHRegisterDelegate>
-(void)registerForRemoteNotification;
@end
