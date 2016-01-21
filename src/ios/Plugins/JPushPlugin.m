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



static NSString *const JM_APP_KEY = @"APP_KEY";
static NSString *const JM_APP_CHANNEL = @"CHANNEL";
static NSString *const JM_APP_ISPRODUCTION = @"IsProduction";

static NSString *const JMessageConfigFileName = @"PushConfig";


static NSDictionary *_luanchOptions=nil;

@implementation JPushPlugin


+(void)setLaunchOptions:(NSDictionary *)theLaunchOptions{
  _luanchOptions=theLaunchOptions;
  [JPUSHService setDebugMode];
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
  } else {
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
  }
  
  //read appkey and channel from JMessageConfig.plist
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:JMessageConfigFileName ofType:@"plist"];
  if (plistPath == nil) {
    NSLog(@"error: PushConfig.plist not found");
    assert(0);
  }
  
  NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
  NSString * appkey = [plistData valueForKey:JM_APP_KEY];
  NSString * channel = [plistData valueForKey:JM_APP_CHANNEL];
  NSNumber * isProduction = [plistData valueForKey:JM_APP_ISPRODUCTION];

  if (!appkey || appkey.length == 0) {
    NSLog(@"error: app key not found in JMessageConfig.plist ");
    assert(0);
  }
  
  [JPUSHService setupWithOption:_luanchOptions appKey:appkey
                        channel:channel apsForProduction:[isProduction boolValue] ];
  
}


-(void)stopPush:(CDVInvokedUrlCommand*)command{
  
  [[UIApplication sharedApplication]unregisterForRemoteNotifications];
}


-(void)resumePush:(CDVInvokedUrlCommand*)command{
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
  } else {
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
  }
#else
  //categories 必须为nil
  [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                    UIRemoteNotificationTypeSound |
                                                    UIRemoteNotificationTypeAlert)
                                        categories:nil];
#endif
  
}


-(void)isPushStopped:(CDVInvokedUrlCommand*)command{
  
  NSNumber *result;
  if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications ]) {
    result=@(0);
  }else{
    result=@(1);
  }
  CDVPluginResult * pushResult=[self pluginResultForValue:result];
  if (pushResult) {
    [self succeedWithPluginResult:pushResult withCallbackID:command.callbackId];
  } else {
    [self failWithCallbackID:command.callbackId];
  }
}


-(void)initial:(CDVInvokedUrlCommand*)command{
  //do nithng,because Cordova plugin use lazy load mode.
}



#ifdef __CORDOVA_4_0_0

- (void)pluginInitialize {
  NSLog(@"### pluginInitialize ");
  [self initNotifications];
}

#else

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView{
  NSLog(@"### initWithWebView ");
  if (self=[super initWithWebView:theWebView]) {
    [self initNotifications];
    
  }
  return self;
}


#endif



-(void)initNotifications {
  
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  [defaultCenter addObserver:self
                    selector:@selector(networkDidReceiveMessage:)
                        name:kJPFNetworkDidReceiveMessageNotification
                      object:nil];
  
  [defaultCenter addObserver:self
                    selector:@selector(networkDidReceiveNotification:)
                        name:kJPushPluginReceiveNotification
                      object:nil];
  
  if (_luanchOptions) {
    NSDictionary *userInfo = [_luanchOptions
                              valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([userInfo count] >0) {
      NSError  *error;
      NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
      NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
      if (!error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.openNotification',%@)",jsonString]];
        });
        
      }
    }
    
  }
}



-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command{
  NSArray *arguments=command.arguments;
  if (!arguments||[arguments count]<2) {
    
    NSLog(@"#### setTagsWithAlias param is less");
    return ;
  }
  NSString *alias=[arguments objectAtIndex:0];
  NSArray  *arrayTags=[arguments objectAtIndex:1];
  
  NSLog(@"#### setTagsWithAlias alias is %@, tags is %@",alias,arrayTags);
  
  NSSet* set=[NSSet setWithArray:arrayTags];
  [JPUSHService setTags:set
                  alias:alias
       callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                 object:self];
}



-(void)setTags:(CDVInvokedUrlCommand *)command{
  
  
  NSArray *arguments=[command arguments];
  NSString *tags=[arguments objectAtIndex:0];
  
  NSLog(@"#### setTags %@",tags);

  NSArray  *array=[tags componentsSeparatedByString:@","];
  [JPUSHService setTags:[NSSet setWithArray:array]
       callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                 object:self];
  
}



-(void)setAlias:(CDVInvokedUrlCommand *)command{
  
  NSArray *arguments=[command arguments];
  NSLog(@"#### setAlias %@",arguments);
  [JPUSHService setAlias:[arguments objectAtIndex:0]
        callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                  object:self];
  
}



-(void)getRegistrationID:(CDVInvokedUrlCommand*)command{
  NSString* registrationID = [JPUSHService registrationID];
  NSLog(@"### getRegistrationID %@",registrationID);

  CDVPluginResult *result=[self pluginResultForValue:registrationID];
  if (result) {
    [self succeedWithPluginResult:result withCallbackID:command.callbackId];
  } else {
    [self failWithCallbackID:command.callbackId];
  }
}




-(void)tagsWithAliasCallback:(int)resultCode tags:(NSSet *)tags alias:(NSString *)alias{
  
  NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithInt:resultCode],@"resultCode",
                      tags==nil?[NSNull null]:[tags allObjects],@"tags",
                      alias==nil?[NSNull null]:alias,@"alias",nil];
  NSMutableDictionary *data = [NSMutableDictionary dictionary];
  [data setObject:[NSNumber numberWithInt:resultCode] forKey:@"resultCode"];
  [data setObject:tags==nil?[NSNull null]:[tags allObjects] forKey:@"tags"];
  [data setObject:alias==nil?[NSNull null]:alias forKey:@"alias"];
  NSError  *error;
  
  NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
  NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.setTagsWithAlias',%@)",jsonString]];
    //      [self writeJavascript:[NSString stringWithFormat:@"window.plugins.jPushPlugin.pushCallback('%@')",jsonString]];
  });
  
}


-(void)startLogPageView:(CDVInvokedUrlCommand*)command{
  NSArray *arguments=command.arguments;
  if (!arguments||[arguments count]<1) {
    NSLog(@"startLogPageView argument  error");
    return ;
  }
  NSString * pageName=[arguments objectAtIndex:0];
  if (pageName) {
    [JPUSHService startLogPageView:pageName];
  }
}


-(void)stopLogPageView:(CDVInvokedUrlCommand*)command{
  NSArray *arguments=command.arguments;
  if (!arguments||[arguments count]<1) {
    NSLog(@"stopLogPageView argument  error");
    return ;
  }
  NSString * pageName=[arguments objectAtIndex:0];
  if (pageName) {
    [JPUSHService stopLogPageView:pageName];
  }
  
}



-(void)beginLogPageView:(CDVInvokedUrlCommand*)command{
  NSArray *arguments=command.arguments;
  if (!arguments||[arguments count]<2) {
    NSLog(@"beginLogPageView argument  error");
    return ;
  }
  NSString * pageName=[arguments objectAtIndex:0];
  int duration=[[arguments objectAtIndex:0]intValue];
  if (pageName) {
    [JPUSHService beginLogPageView:pageName duration:duration];
  }
  
}

 
-(void)setBadge:(CDVInvokedUrlCommand*)command{
  NSArray *argument=command.arguments;
  if ([argument count]<1) {
    NSLog(@"setBadge argument error!");
    return;
  }
  NSNumber *badge=[argument objectAtIndex:0];
  [JPUSHService setBadge:[badge intValue]];
}



-(void)resetBadge:(CDVInvokedUrlCommand*)command{
  [JPUSHService resetBadge];
}


-(void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand *)command{
  //
  NSArray *argument=command.arguments;
  if ([argument count]<1) {
    NSLog(@"setBadge argument error!");
    return;
  }
  NSNumber *badge=[argument objectAtIndex:0];
  [UIApplication sharedApplication].applicationIconBadgeNumber=[badge intValue];
}


-(void)getApplicationIconBadgeNumber:(CDVInvokedUrlCommand *)command {
  NSInteger num =  [UIApplication sharedApplication].applicationIconBadgeNumber;
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:num];
  [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}



-(void)setDebugModeFromIos:(CDVInvokedUrlCommand*)command{
  
  [JPUSHService setDebugMode];
}



-(void)setLogOFF:(CDVInvokedUrlCommand*)command{
  
  [JPUSHService setLogOFF];
}



- (void)failWithCallbackID:(NSString *)callbackID {
  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  [self.commandDelegate sendPluginResult:result callbackId:callbackID];
}



- (void)succeedWithPluginResult:(CDVPluginResult *)result withCallbackID:(NSString *)callbackID {
  [self.commandDelegate sendPluginResult:result callbackId:callbackID];
}




- (CDVPluginResult *)pluginResultForValue:(id)value {
  
  CDVPluginResult *result;
  if ([value isKindOfClass:[NSString class]]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                               messageAsString:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  } else if ([value isKindOfClass:[NSNumber class]]) {
    CFNumberType numberType = CFNumberGetType((CFNumberRef)value);
    //note: underlyingly, BOOL values are typedefed as char
    if (numberType == kCFNumberIntType || numberType == kCFNumberCharType) {
      result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[value intValue]];
    } else  {
      result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:[value doubleValue]];
    }
  } else if ([value isKindOfClass:[NSArray class]]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:value];
  } else if ([value isKindOfClass:[NSDictionary class]]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:value];
  } else if ([value isKindOfClass:[NSNull class]]) {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  } else {
    NSLog(@"Cordova callback block returned unrecognized type: %@", NSStringFromClass([value class]));
    return nil;
  }
  return result;
}



- (void)networkDidReceiveMessage:(NSNotification *)notification {
  
  NSDictionary *userInfo = [notification userInfo];
  //NSLog(@"%@",userInfo);
  
  NSError  *error;
  NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
  NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  //NSLog(@"%@",jsonString);
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.receiveMessage',%@)",jsonString]];
    
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"window.plugins.jPushPlugin.receiveMessageIniOSCallback('%@')",jsonString]];
    
    
  });
  
}



-(void)networkDidReceiveNotification:(id)notification{
  
  NSError  *error;
  NSDictionary *userInfo = [notification object];
  
  NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:userInfo options:0 error:&error];
  NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
  switch ([UIApplication sharedApplication].applicationState) {
    case UIApplicationStateActive:
    {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.receiveNotification',%@)",jsonString]];
      });
    }
      break;
    case UIApplicationStateInactive:
    case UIApplicationStateBackground:
    {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('jpush.openNotification',%@)",jsonString]];
      });
      
    }
      break;
    default:
      //do nothing
      break;
  }
  
}


@end
