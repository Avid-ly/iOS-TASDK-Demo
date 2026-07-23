//
//  NotificationService.m
//  NotificationServiceExtension
//
//  Created by steve on 2026/6/3.
//  Copyright © 2026 samliu. All rights reserved.
//

#import "NotificationService.h"
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <TraceAnalysisSDK/TraceAnalysis.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Call FIRMessaging extension helper API.
    [[FIRMessaging extensionHelper] populateNotificationContent:self.bestAttemptContent
                                                withContentHandler:contentHandler];
    
    // 统计推送（通知到达事件）
    NSString *product = @"600001";
    [TraceAnalysis didReceiveNotificationUserInfo:request.content.userInfo productId:product];
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
