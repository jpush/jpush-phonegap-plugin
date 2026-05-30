#import "JPushPlugin.h"
#import <JPush/JPUSHService.h>

@implementation JPushPlugin

- (void)pluginInitialize {
    [super pluginInitialize];
    NSLog(@"JPushPlugin initialized");
}

- (void)init:(CDVInvokedUrlCommand *)command {
    [JPUSHService setupWithOption:nil appKey:nil channel:nil apsForProduction:NO];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)initial:(CDVInvokedUrlCommand *)command {
    [self init:command];
}

- (void)setDebugMode:(CDVInvokedUrlCommand *)command {
    BOOL enable = [[command.arguments objectAtIndex:0] boolValue];
    [JPUSHService setDebugMode:enable];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setDebugModeFromIos:(CDVInvokedUrlCommand *)command {
    [JPUSHService setDebugMode:YES];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)setLogOFF:(CDVInvokedUrlCommand *)command {
    [JPUSHService setDebugMode:NO];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)getRegistrationID:(CDVInvokedUrlCommand *)command {
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:registrationID];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)stopPush:(CDVInvokedUrlCommand *)command {
    [JPUSHService stopPush];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)resumePush:(CDVInvokedUrlCommand *)command {
    [JPUSHService resumePush];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)isPushStopped:(CDVInvokedUrlCommand *)command {
    BOOL stopped = [JPUSHService isPushStopped];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:stopped ? 1 : 0];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

// iOS SDK 6.1.0 did not add new methods beyond bug fixes; setKeepLongConnInBackground is Android-only.
// No new iOS native methods needed.

@end