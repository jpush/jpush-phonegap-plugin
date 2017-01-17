
//
//  PushTalkPlugin.m
//  PushTalk
//
//  Created by zhangqinghe on 13-12-13.
//
//

#import "JPushPlugin.h"
#import "JPUSHService.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+JPush.h"
#import "JPushDefine.h"

@implementation NSDictionary (JPush)
-(NSString*)toJsonString{
    NSError  *error;
    NSData   *data       = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end

@implementation NSString (JPush)
-(NSDictionary*)toDictionary{
    NSError      *error;
    NSData       *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict     = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    return dict;
}
@end

@interface JPushPlugin()

@end

@implementation JPushPlugin

-(void)startJPushSDK:(CDVInvokedUrlCommand*)command{
    [(AppDelegate*)[UIApplication sharedApplication].delegate startJPushSDK];
}

#pragma mark- 外部接口
-(void)stopPush:(CDVInvokedUrlCommand*)command{
    [[UIApplication sharedApplication]unregisterForRemoteNotifications];
}

-(void)resumePush:(CDVInvokedUrlCommand*)command{
    [(AppDelegate*)[UIApplication sharedApplication].delegate registerForRemoteNotification];
}

-(void)isPushStopped:(CDVInvokedUrlCommand*)command{
    NSNumber *result = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications] ? @(0) : @(1);
    [self handleResultWithValue:result command:command];
}

-(void)initial:(CDVInvokedUrlCommand*)command{
    //do nithng,because Cordova plugin use lazy load mode.
}

#ifdef __CORDOVA_4_0_0

- (void)pluginInitialize {
    NSLog(@"### pluginInitialize ");
    [self initPlugin];
}

#else

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView{
    NSLog(@"### initWithWebView ");
    if (self=[super initWithWebView:theWebView]) {
    }
    [self initPlugin];
    return self;
}

#endif

-(void)initPlugin{
    if (!SharedJPushPlugin) {
        SharedJPushPlugin = self;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidReceiveMessage:)
                                                 name:kJPFNetworkDidReceiveMessageNotification
                                               object:nil];
}

+(void)fireDocumentEvent:(NSString*)eventName jsString:(NSString*)jsString{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SharedJPushPlugin.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.%@',%@)", eventName, jsString]];
    });
}

-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command{
    NSString *alias = [command argumentAtIndex:0];
    NSArray  *tags  = [command argumentAtIndex:1];
    [JPUSHService setTags:[NSSet setWithArray:tags]
                    alias:alias
         callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                   object:self];
}

-(void)setTags:(CDVInvokedUrlCommand *)command{
    NSArray *tags = command.arguments;
    [JPUSHService setTags:[NSSet setWithArray:tags]
         callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                   object:self];
}

-(void)setAlias:(CDVInvokedUrlCommand *)command{
    NSString *alias = [command argumentAtIndex:0];
    [JPUSHService setAlias:alias
          callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                    object:self];
}

-(void)getRegistrationID:(CDVInvokedUrlCommand*)command{
    NSString* registrationID = [JPUSHService registrationID];
    [self handleResultWithValue:registrationID command:command];
}

-(void)startLogPageView:(CDVInvokedUrlCommand*)command{
    NSString * pageName = [command argumentAtIndex:0];
    [JPUSHService startLogPageView:pageName];
}

-(void)stopLogPageView:(CDVInvokedUrlCommand*)command{
    NSString * pageName = [command argumentAtIndex:0];
    [JPUSHService stopLogPageView:pageName];
}

-(void)beginLogPageView:(CDVInvokedUrlCommand*)command{
    NSString *pageName = [command argumentAtIndex:0];
    NSNumber *duration = [command argumentAtIndex:1];
    [JPUSHService beginLogPageView:pageName duration:duration.intValue];
}

-(void)setBadge:(CDVInvokedUrlCommand*)command{
    NSNumber *badge = [command argumentAtIndex:0];
    [JPUSHService setBadge:badge.intValue];
}

-(void)resetBadge:(CDVInvokedUrlCommand*)command{
    [JPUSHService resetBadge];
}

-(void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand *)command{
    NSNumber *badge = [command argumentAtIndex:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge.intValue;
}

-(void)getApplicationIconBadgeNumber:(CDVInvokedUrlCommand *)command {
    NSInteger num = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSNumber *number = [NSNumber numberWithInteger:num];
    [self handleResultWithValue:number command:command];
}

-(void)setDebugModeFromIos:(CDVInvokedUrlCommand*)command{
    [JPUSHService setDebugMode];
}

-(void)setLogOFF:(CDVInvokedUrlCommand*)command{
    [JPUSHService setLogOFF];
}

-(void)crashLogON:(CDVInvokedUrlCommand*)command{
    [JPUSHService crashLogON];
}

-(void)setLocalNotification:(CDVInvokedUrlCommand*)command{
    NSLog(@"ios 10 after please use UNNotificationRequest to set local notification, see apple doc to learn more");

    NSDate       *date  = [NSDate dateWithTimeIntervalSinceNow:[[command argumentAtIndex:0] intValue]];
    NSString     *alert = [command argumentAtIndex:1];
    NSNumber     *badge = [command argumentAtIndex:2];
    NSString     *idKey = [command argumentAtIndex:3];
    NSDictionary *dict  = [command argumentAtIndex:4];
    [JPUSHService setLocalNotification:date alertBody:alert badge:badge.intValue alertAction:nil identifierKey:idKey userInfo:dict soundName:nil];
}

-(void)deleteLocalNotificationWithIdentifierKey:(CDVInvokedUrlCommand*)command{
    NSString *identifier = [command argumentAtIndex:0];
    JPushNotificationIdentifier *jpid = [JPushNotificationIdentifier new];
    jpid.identifiers = @[identifier];
    [JPUSHService removeNotification:jpid];
}

-(void)clearAllLocalNotifications:(CDVInvokedUrlCommand*)command{
    [JPUSHService removeNotification:nil];
}

-(void)setLocation:(CDVInvokedUrlCommand*)command{
    NSNumber *latitude  = [command argumentAtIndex:0];
    NSNumber *longitude = [command argumentAtIndex:1];
    [JPUSHService setLatitude:latitude.doubleValue longitude:longitude.doubleValue];
}

-(void)getUserNotificationSettings:(CDVInvokedUrlCommand*)command{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        WEAK_SELF(weakSelf);
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"authorizationStatus"]       = @(settings.authorizationStatus);
            dict[@"soundSetting"]              = @(settings.soundSetting);
            dict[@"badgeSetting"]              = @(settings.badgeSetting);
            dict[@"alertSetting"]              = @(settings.alertSetting);
            dict[@"notificationCenterSetting"] = @(settings.notificationCenterSetting);
            dict[@"lockScreenSetting"]         = @(settings.lockScreenSetting);
            dict[@"carPlaySetting"]            = @(settings.carPlaySetting);
            dict[@"alertStyle"]                = @(settings.alertStyle);
            [weakSelf handleResultWithValue:dict command:command];
        }];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        UIUserNotificationType type = settings.types;
        NSNumber *number = [NSNumber numberWithInteger:type];
        [self handleResultWithValue:number command:command];
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        NSNumber *number = [NSNumber numberWithInteger:type];
        [self handleResultWithValue:number command:command];
    }
}

#pragma mark - ios 10 APIs

-(void)addDismissActions:(CDVInvokedUrlCommand*)command{
    [self addActions:command dismiss:YES];
}

-(void)addNotificationActions:(CDVInvokedUrlCommand*)command{
    [self addActions:command dismiss:NO];
}

-(void)addActions:(CDVInvokedUrlCommand*)command dismiss:(BOOL)dimiss{
    NSArray *actionsData     = [command argumentAtIndex:0];
    NSString *categoryId     = [command argumentAtIndex:1];
    NSMutableArray *actions  = [NSMutableArray array];
    for (NSDictionary *dict in actionsData) {
        NSString *title      = dict[@"title"];
        NSString *identifier = dict[@"identifier"];
        NSString *option     = dict[@"option"];
        NSString *type       = dict[@"type"];
        if ([type isEqualToString:@"textInput"]) {
            NSString *textInputButtonTitle = dict[@"textInputButtonTitle"];
            NSString *textInputPlaceholder = dict[@"textInputPlaceholder"];
            UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:identifier title:title options:option.integerValue textInputButtonTitle:textInputButtonTitle textInputPlaceholder:textInputPlaceholder];
            [actions addObject:inputAction];
        }else{
            UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:title title:title options:option.integerValue];
            [actions addObject:action];
        }
    }
    UNNotificationCategory *category;
    if (dimiss) {
        category = [UNNotificationCategory categoryWithIdentifier:categoryId actions:actions intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    }else{
        category = [UNNotificationCategory categoryWithIdentifier:categoryId actions:actions intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    }
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:category]];
}

#pragma mark - 内部方法

+(void)setupJPushSDK:(NSDictionary*)userInfo{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:JPushConfig_FileName ofType:@"plist"];
    if (plistPath == nil) {
        NSLog(@"error: PushConfig.plist not found");
        assert(0);
    }

    NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *appkey       = [plistData valueForKey:JPushConfig_Appkey];
    NSString *channel      = [plistData valueForKey:JPushConfig_Channel];
    NSNumber *isProduction = [plistData valueForKey:JPushConfig_IsProduction];
    NSNumber *isIDFA       = [plistData valueForKey:JPushConfig_IsIDFA];

    NSString *advertisingId = nil;
    if(isIDFA.boolValue){
        advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    [JPUSHService setupWithOption:userInfo
                           appKey:appkey
                          channel:channel
                 apsForProduction:[isProduction boolValue]
            advertisingIdentifier:advertisingId];
}

#pragma mark 将参数返回给js
-(void)handleResultWithValue:(id)value command:(CDVInvokedUrlCommand*)command{
    CDVPluginResult *result = nil;
    CDVCommandStatus status = CDVCommandStatus_OK;

    if ([value isKindOfClass:[NSString class]]) {
        value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else if ([value isKindOfClass:[NSNull class]]) {
        value = nil;
    }

    if ([value isKindOfClass:[NSObject class]]) {
        result = [CDVPluginResult resultWithStatus:status messageAsString:value];//NSObject 类型都可以
    } else {
        NSLog(@"Cordova callback block returned unrecognized type: %@", NSStringFromClass([value class]));
        result = nil;
    }

    if (!result) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

#pragma mark 设置标签及别名回调
-(void)tagsWithAliasCallback:(int)resultCode tags:(NSSet *)tags alias:(NSString *)alias{
    NSDictionary *dict = @{@"resultCode":[NSNumber numberWithInt:resultCode],
                           @"tags"      :tags  == nil ? [NSNull null] : [tags allObjects],
                           @"alias"     :alias == nil ? [NSNull null] : alias
                           };
    [JPushPlugin fireDocumentEvent:JPushDocumentEvent_SetTagsWithAlias jsString:[dict toJsonString]];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    if (notification && notification.userInfo) {
        [JPushPlugin fireDocumentEvent:JPushDocumentEvent_ReceiveMessage jsString:[notification.userInfo  toJsonString]];
    }
}

@end
