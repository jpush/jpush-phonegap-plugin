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
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receiveLocalNotification:)
                                               name:JPushDocumentEvent_ReceiveLocalNotification
                                             object:nil];
  [self dispatchJPushCacheEvent];
}

- (void)dispatchJPushCacheEvent {
  for (NSString* key in _jpushEventCache) {
    NSArray *evenList = _jpushEventCache[key];
    for (NSString *event in evenList) {
        [JPushPlugin fireDocumentEvent:key jsString:event];
    }
  }
}

+(void)fireDocumentEvent:(NSString*)eventName jsString:(NSString*)jsString{
  if (SharedJPushPlugin) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [SharedJPushPlugin.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.%@',%@)", eventName, jsString]];
    });
    return;
  }
  
  if (!_jpushEventCache) {
    _jpushEventCache = @{}.mutableCopy;
  }
  
  if (!_jpushEventCache[eventName]) {
    _jpushEventCache[eventName] = @[].mutableCopy;
  }
  
  [_jpushEventCache[eventName] addObject: jsString];
}

-(void)setTags:(CDVInvokedUrlCommand*)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    NSArray* tags = params[@"tags"];
  
    [JPUSHService setTags:[NSSet setWithArray:tags]
               completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                   NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                   [dic setObject:sequence forKey:@"sequence"];
                   
                   CDVPluginResult* result;
                   
                   if (iResCode == 0) { 
                       [dic setObject:[iTags allObjects] forKey:@"tags"];
                       result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
                   } else {
                       [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
                       result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
                   }
                   
                   [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
               } seq:[sequence integerValue]];
}

-(void)addTags:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    NSArray* tags = params[@"tags"];
    
    [JPUSHService addTags:[NSSet setWithArray:tags]
               completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                   NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                   [dic setObject:sequence forKey:@"sequence"];
                   
                   CDVPluginResult* result;
                   
                   if (iResCode == 0) { 
                       [dic setObject:[iTags allObjects] forKey:@"tags"];
                       result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
                   } else {
                       [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
                       result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
                   }
                   
                   [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
               } seq:[sequence integerValue]];
}

-(void)deleteTags:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    NSArray* tags = params[@"tags"];
    
    [JPUSHService deleteTags:[NSSet setWithArray:tags]
               completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                   NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                   [dic setObject:sequence forKey:@"sequence"];
                   
                   CDVPluginResult* result;
                   
                   if (iResCode == 0) { 
                       [dic setObject:[iTags allObjects] forKey:@"tags"];
                       result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
                   } else {
                       [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
                       result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
                   }
                   
                   [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
               } seq:[sequence integerValue]];
}

-(void)cleanTags:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sequence forKey:@"sequence"];
        
        CDVPluginResult* result;
        
        if (iResCode == 0) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        } else {
            [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
        }
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } seq:[sequence integerValue]];
}

-(void)getAllTags:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    
    [JPUSHService getAllTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sequence forKey:@"sequence"];
        
        CDVPluginResult* result;
        
        if (iResCode == 0) { 
            [dic setObject:[iTags allObjects] forKey:@"tags"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        } else {
            [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
        }
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } seq:[sequence integerValue]];
}

-(void)checkTagBindState:(CDVInvokedUrlCommand *)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    NSString* tag = params[@"tag"];
    
    [JPUSHService validTag:tag completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq, BOOL isBind) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sequence forKey:@"sequence"];
        
        CDVPluginResult* result;
        
        if (iResCode == 0) { 
            dic[@"tag"] = tag;
            [dic setObject:[NSNumber numberWithBool:isBind] forKey:@"isBind"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        } else {
            [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
        }
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } seq:[sequence integerValue]];
}

-(void)setAlias:(CDVInvokedUrlCommand*)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    NSString* alias = params[@"alias"];
    
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sequence forKey:@"sequence"];
        
        CDVPluginResult* result;
        
        if (iResCode == 0) {
            [dic setObject:iAlias forKey:@"alias"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
            
        } else {
            [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
        }
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } seq:[sequence integerValue]];
}

-(void)deleteAlias:(CDVInvokedUrlCommand*)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sequence forKey:@"sequence"];
        
        CDVPluginResult* result;
        
        if (iResCode == 0) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        } else {
            [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
        }
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } seq:[sequence integerValue]];
}

-(void)getAlias:(CDVInvokedUrlCommand*)command {
    NSDictionary* params = [command.arguments objectAtIndex:0];
    NSNumber* sequence = params[@"sequence"];
    
    [JPUSHService getAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:sequence forKey:@"sequence"];
        
        CDVPluginResult* result;
        
        if (iResCode == 0) {
            [dic setObject:iAlias forKey:@"alias"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dic];
        } else {
            [dic setValue:[NSNumber numberWithUnsignedInteger:iResCode] forKey:@"code"];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dic];
        }
        
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } seq:[sequence integerValue]];
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

-(void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command{
    NSNumber *badge = [command argumentAtIndex:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge.intValue;
}

-(void)getApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command {
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
  NSNumber     *delay = [command argumentAtIndex:0];
  NSString     *alert = [command argumentAtIndex:1];
  NSNumber     *badge = [command argumentAtIndex:2];
  NSString     *idKey = [command argumentAtIndex:3];
  NSDictionary *userInfo  = [command argumentAtIndex:4];
  
  JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
  
  if (alert) {
    content.body = alert;
  }
  
  if (badge) {
    content.badge = badge;
  }
  
  if (userInfo) {
    content.userInfo = userInfo;
  }
  
  JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
  // 由于 不支持 0 作为传入参数，在传入参数基础上添加一个极小的时间于 android 端保持一致。
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
    if (delay) {
      trigger.timeInterval = [delay doubleValue] + 0.000001;
    }
  } else {
    if (delay) {
      trigger.fireDate = [NSDate dateWithTimeIntervalSinceNow:[[command argumentAtIndex:0] doubleValue] + 0.001];
    }
  }
  
  JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
  request.content = content;
  request.trigger = trigger;
  
  if (idKey) {
    request.requestIdentifier = idKey;
  }
  
  request.completionHandler = ^(id result) {
    NSLog(@"result");
  };
  
  [JPUSHService addNotification:request];
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
        } else {
            UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:title title:title options:option.integerValue];
            [actions addObject:action];
        }
    }
    UNNotificationCategory *category;
    if (dimiss) {
        category = [UNNotificationCategory categoryWithIdentifier:categoryId
                                                          actions:actions
                                                intentIdentifiers:@[]
                                                          options:UNNotificationCategoryOptionCustomDismissAction];
    } else {
        category = [UNNotificationCategory categoryWithIdentifier:categoryId
                                                          actions:actions
                                                intentIdentifiers:@[]
                                                          options:UNNotificationCategoryOptionNone];
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
    if(isIDFA.boolValue) {
        advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    [JPUSHService setupWithOption:userInfo
                           appKey:appkey
                          channel:channel
                 apsForProduction:[isProduction boolValue]
            advertisingIdentifier:advertisingId];
}

#pragma mark 将参数返回给js
-(void)handleResultWithValue:(id)value command:(CDVInvokedUrlCommand*)command {
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

-(void)networkDidReceiveMessage:(NSNotification *)notification {
    if (notification && notification.userInfo) {
        [JPushPlugin fireDocumentEvent:JPushDocumentEvent_ReceiveMessage
                              jsString:[notification.userInfo toJsonString]];
    }
}

-(void)receiveLocalNotification:(NSNotification *)notification {
  if (notification && notification.object) {
    [JPushPlugin fireDocumentEvent:JPushDocumentEvent_ReceiveLocalNotification
                          jsString:[notification.object toJsonString]];
  }
}
@end
