//
//  PushTalkPlugin.m
//  PushTalk
//
//  Created by zhangqinghe on 13-12-13.
//
//

#import "JPushPlugin.h"
#import "APService.h"
#import <UIKit/UIKit.h>

static NSDictionary *_luanchOptions=nil;

@implementation JPushPlugin


+(void)setLaunchOptions:(NSDictionary *)theLaunchOptions{
    _luanchOptions=theLaunchOptions;
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:_luanchOptions];
}

-(void)initial:(CDVInvokedUrlCommand*)command{
    //do nithng,because Cordova plugin use lazy load mode.
    
}
- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView{
    if (self=[super initWithWebView:theWebView]) {
        
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
    return self;
}

-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command{
    
    NSArray *arguments=command.arguments;
    if (!arguments||[arguments count]<2) {
//        [self writeJavascript:[NSString stringWithFormat:@"window.plugins.jPushPlugin.pushCallback('%@')",@""]];
        return ;
    }
    NSString *alias=[arguments objectAtIndex:0];
    NSArray  *arrayTags=[arguments objectAtIndex:1];
    NSSet* set=[NSSet setWithArray:arrayTags];
   [APService setTags:set
                 alias:alias
      callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                object:self];
}

-(void)resumePush:(CDVInvokedUrlCommand*)command{

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
   if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
	} else {
	//categories 必须为nil
	[APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
												   UIRemoteNotificationTypeSound |
												   UIRemoteNotificationTypeAlert)
									   categories:nil];
	}
#else
    //categories 必须为nil
	[APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
												 UIRemoteNotificationTypeSound |
												 UIRemoteNotificationTypeAlert)
									 categories:nil];
#endif

}
-(void)isPushStopped:(CDVInvokedUrlCommand*)command{

    NSNumber *result;
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications ]) {
        result=@(1);
    }else{
        result=@(0);
    }
    CDVPluginResult * pushResult=[self pluginResultForValue:result];
    if (pushResult) {
        [self succeedWithPluginResult:pushResult withCallbackID:command.callbackId];
    } else {
        [self failWithCallbackID:command.callbackId];
}}
-(void)setTags:(CDVInvokedUrlCommand *)command{
    

    NSArray *arguments=[command arguments];
    NSString *tags=[arguments objectAtIndex:0];
    
    NSArray  *array=[tags componentsSeparatedByString:@","];
   [APService setTags:[NSSet setWithArray:array]
      callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                object:self];
    
}
    
-(void)setAlias:(CDVInvokedUrlCommand *)command{
    
    NSArray *arguments=[command arguments];
   [APService setAlias:[arguments objectAtIndex:0]
      callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                object:self];
    
}

-(void)getRegistrationID:(CDVInvokedUrlCommand*)command{
    
    NSString* registrationID = [APService registrationID];
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
        [APService startLogPageView:pageName];
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
        [APService stopLogPageView:pageName];
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
        [APService beginLogPageView:pageName duration:duration];
    }

}
-(void)setBadge:(CDVInvokedUrlCommand*)command{
    NSArray *argument=command.arguments;
    if ([argument count]<1) {
        NSLog(@"setBadge argument error!");
        return;
    }
    NSNumber *badge=[argument objectAtIndex:0];
    [APService setBadge:[badge intValue]];
}
-(void)resetBadge:(CDVInvokedUrlCommand*)command{
    [APService resetBadge];
}
-(void)setDebugModeFromIos:(CDVInvokedUrlCommand*)command{
    
    [APService setDebugMode];
}
-(void)setLogOFF:(CDVInvokedUrlCommand*)command{
    
    [APService setLogOFF];
}
-(void)stopPush:(CDVInvokedUrlCommand*)command{
    
    [[UIApplication sharedApplication]unregisterForRemoteNotifications];

}
- (void)failWithCallbackID:(NSString *)callbackID {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    [self.commandDelegate sendPluginResult:result callbackId:callbackID];
}
- (void)succeedWithPluginResult:(CDVPluginResult *)result withCallbackID:(NSString *)callbackID {
    [self.commandDelegate sendPluginResult:result callbackId:callbackID];
}
-(void)setApplicationIconBadgeNumber:(CDVInvokedUrlCommand*)command{
    //
    NSArray *argument=command.arguments;
    if ([argument count]<1) {
        NSLog(@"setBadge argument error!");
        return;
    }
    NSNumber *badge=[argument objectAtIndex:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber=[badge intValue];
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
