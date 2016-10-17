//
//  NotificationService.m
//  jpushNotificationService
//
//  Created by wuxingchen on 16/10/10.
//
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {

    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    @try {
        NSString *urlStr = [request.content.userInfo valueForKey:@"JPushPluginAttachment"];
        NSArray *urls = [urlStr componentsSeparatedByString:@"."];
        NSURL *urlNative = [[NSBundle mainBundle] URLForResource:urls[0] withExtension:urls[1]];
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:urlStr URL:urlNative options:nil error:nil];
        self.bestAttemptContent.attachments = @[attachment];
    } @catch (NSException *exception) {
    }

    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
