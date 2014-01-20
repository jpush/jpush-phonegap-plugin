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
        
       [self writeJavascript:[NSString stringWithFormat:@"window.plugins.jPushPlugin.pushCallback('%@')",jsonString]];
    });
}
    

@end
