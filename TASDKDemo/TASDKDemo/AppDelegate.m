//
//  AppDelegate.m

//
//  Created by samliu on 2017/6/29.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "AppDelegate.h"
#import "OtherViewController.h"
#import <AdSupport/AdSupport.h>
#import <TraceAnalysisSDK/TraceAnalysis.h>
#import <UserNotifications/UserNotifications.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import <FirebaseCore/FirebaseCore.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"idfa:%@",idfa);
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    OtherViewController *vc = [[OtherViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nv;
    [self.window makeKeyAndVisible];
    
    // 设置收到推送代理
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    // 请求推送授权
    [self requestPushAuthorization];
    
    return YES;
}

#pragma mark - Authorization

- (void)requestPushAuthorization {
    
    // 系统推送授权弹窗展示 事件 打点
    NSString *eventKey = @"PUSH_POP";
    [TraceAnalysis logWithKey:eventKey value:nil];
    
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"✅ 用户允许通知");
            
            // 注册推送（成功后会获得APNsToken）
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
            
            // 系统推送授权选择结果(成功授权) 事件 打点
            NSString *eventKey = @"PUSH_SEL";
            NSMutableDictionary *eventValue = [[NSMutableDictionary alloc] init];
            [eventValue setValue:@"1" forKey:@"S"]; // 授权选择结果，允许为1|拒绝为0
            [TraceAnalysis logWithKey:eventKey value:eventValue];
            
        } else {
            NSLog(@"❌ 用户拒绝通知");
            
            // 系统推送授权选择结果(失败/不授权) 事件 打点
            NSString *eventKey = @"PUSH_SEL";
            NSMutableDictionary *eventValue = [[NSMutableDictionary alloc] init];
            [eventValue setValue:@"0" forKey:@"S"]; // 授权选择结果，允许为1|拒绝为0
            [TraceAnalysis logWithKey:eventKey value:eventValue];
        }
    }];
}

#pragma mark - registerForRemoteNotifications results（注册推送结果）

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *message = [NSString stringWithFormat:@"✅ 成功获取 APNs Token: %@",deviceToken];
    NSLog(@"%@", message);
    
    // 系统推送授权选择结果(成功授权) 事件 打点
    NSString *eventKey = @"PUSH_REG";
    NSMutableDictionary *eventValue = [[NSMutableDictionary alloc] init];
    [eventValue setValue:@"1" forKey:@"S"]; // 系统推送注册结果，成功为1|失败为0|异常-1
    [TraceAnalysis logWithKey:eventKey value:eventValue];
    
    // 注册FcmTokem
    [self requestFcmToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *message = [NSString stringWithFormat:@"❌ 注册 APNs 失败: %@", error.localizedDescription];
    NSLog(@"%@", message);
    
    // 系统推送授权选择结果(失败/不授权) 事件 打点
    NSString *eventKey = @"PUSH_REG";
    NSMutableDictionary *eventValue = [[NSMutableDictionary alloc] init];
    [eventValue setValue:@"0" forKey:@"S"]; // 系统推送注册结果，成功为1|失败为0|异常-1
    [TraceAnalysis logWithKey:eventKey value:eventValue];
}

#pragma mark - FcmToken

- (void)requestFcmToken:(NSData *)deviceToken {
    
    [FIRApp configure];
    if (deviceToken) {
        [FIRMessaging messaging].APNSToken = deviceToken;
    }
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (error != nil) {
            NSString *message = [NSString stringWithFormat:@"❌ Error fetching the remote FCM registration token: %@", error];
            NSLog(@"%@",message);
            
        } else {
            
            NSString *message = [NSString stringWithFormat:@"✅ Remote FCM registration token: %@", token];
            NSLog(@"%@",message);
            
            [self sendFcmTokenAndFirebaseId];
        }
    }];
}

- (void)sendFcmTokenAndFirebaseId {
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
        if (error != nil) {
            NSString *message = [NSString stringWithFormat:@"❌ Error fetching the remote FCM registration token: %@", error];
            NSLog(@"%@",message);
            
        } else {
            
            NSString *firebaseId = [FIRAnalytics appInstanceID];
            NSString *fcmId = token;
            NSString *tasdkToken = [TraceAnalysis staToken];
            [TraceAnalysis setFirebaseId:firebaseId fcmToken:fcmId];
            
            NSString *message = [NSString stringWithFormat:@"✅ send \n\nFcmToken:\n%@ \n\nFirebaseId:\n%@ \n\nTASDKToken:\n%@", token,firebaseId,tasdkToken];
            NSLog(@"%@",message);
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate（点击推送）

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNNotificationPresentationOptionBanner | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    UNNotification *notification = response.notification;
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    NSString *message = [NSString stringWithFormat:@"✅ 用户点击了推送消息，内容为: %@",userInfo];
    NSLog(@"%@", message);
    
    // 统计推送（通知）点击事件
    [TraceAnalysis didClickNotificationUserInfo:response.notification.request.content.userInfo productId:kProductId];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification {
    
}

@end
