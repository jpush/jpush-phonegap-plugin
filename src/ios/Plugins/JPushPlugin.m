//
//  PushTalkPlugin.m
//  PushTalk
//
//  Created by zhangqinghe on 13-12-13.
//
//

#import "JPushPlugin.h"
#import "APService.h"

@implementation JPushPlugin


-(void)setTagsWithAlias:(CDVInvokedUrlCommand*)command{
    
    NSArray *arguments=command.arguments;
    if (!arguments||[arguments count]<2) {
        [self writeJavascript:[NSString stringWithFormat:@"window.plugins.jPushPlugin.pushCallback('%@')",@""]];
        return ;
    }
    NSString *tags=[arguments objectAtIndex:0];
    NSString *alias=[arguments objectAtIndex:1];
    NSArray  *arrayTags=[tags componentsSeparatedByString:@","];
   // NSArray  *tags=[arguments subarrayWithRange:range];
   [APService setTags:[NSSet setWithArray:arrayTags]
                 alias:alias
      callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                object:self];
   //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
    
-(void)setTags:(CDVInvokedUrlCommand *)command{
    
    //CDVPluginResult *pluginResult=nil;

    NSArray *arguments=[command arguments];
    NSString *tags=[arguments objectAtIndex:0];
    
    NSArray  *array=[tags componentsSeparatedByString:@","];
   [APService setTags:[NSSet setWithArray:array]
      callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                object:self];
   //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}
    
-(void)setAlias:(CDVInvokedUrlCommand *)command{
    
    CDVPluginResult *pluginResult=nil;
    
    NSArray *arguments=[command arguments];
   [APService setAlias:[arguments objectAtIndex:0]
      callbackSelector:@selector(tagsWithAliasCallback:tags:alias:)
                object:self];
   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

-(void)getRegistrationID:(CDVInvokedUrlCommand*)command{
    NSString* registratonID = [APService registrionID];
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        NSString *script=[NSString stringWithFormat:@"cordova.fireDocumentEvent('registrationID','[%@]')",registratonID];
        [self.commandDelegate evalJs:script];
        [self writeJavascript:[NSString stringWithFormat:@"window.plugins.jPushPlugin.registrationCallback('%@')",registratonID]];
    });

}

    
-(void)tagsWithAliasCallback:(int)resultCode tags:(NSSet *)tags alias:(NSString *)alias{
    
    
    NSLog(@"recode is %d  tags is %@ alias %@",resultCode,tags,alias);
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:resultCode],@"resultCode",
                        tags==nil?[NSNull null]:[tags allObjects],@"resultTags",
                                   alias==nil?[NSNull null]:alias,@"resultAlias",nil];
    NSError  *error;
    NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('setTagsWithAlias','[%@]')",jsonString]];

       [self writeJavascript:[NSString stringWithFormat:@"window.plugins.jPushPlugin.pushCallback('%@')",jsonString]];
    });
}
- (void)networkDidSetup:(NSNotification *)notification {
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('networkDidSetup')"]];
}

- (void)networkDidClose:(NSNotification *)notification {
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('networkDidClose')"]];
}

- (void)networkDidRegister:(NSNotification *)notification {
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('networkDidRegister')"]];
}

- (void)networkDidLogin:(NSNotification *)notification {
    [self.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireDocumentEvent('networkDidLogin')"]];
}

-(void)initNotifacationCenter:(CDVInvokedUrlCommand*)command{
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kAPNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kAPNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kAPNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kAPNetworkDidLoginNotification
                        object:nil];
    
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


@end
