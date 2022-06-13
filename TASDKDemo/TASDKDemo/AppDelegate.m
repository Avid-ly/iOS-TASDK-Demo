//
//  AppDelegate.m

//
//  Created by samliu on 2017/6/29.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "AppDelegate.h"
#import "OtherViewController.h"
#import "CustomNavController.h"
#import <TraceAnalysisSDK/TraceAnalysis.h>
#import <UserNotifications/UserNotifications.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
//#import <TraceAnalysisSDK/TraceAnalysisDebug.h>

//#import "SensorsAnalyticsSDK.h"

@interface AppDelegate () <AppsFlyerLibDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"idfa:%@",idfa);
    
    NSString *version = [[AppsFlyerLib shared] getSDKVersion];
    NSLog(@"AppsFlyer version:%@",version);
    
//    [TraceAnalysisDebug setDebugLevel:TraceAnalysisDebugLevelLog];
    [TraceAnalysis initWithProductId:@"600108" ChannelId:@"32407" AppID:@"hello"];
    [TraceAnalysis initDurationReportWithServerName:@"111" serverZone:@"222" uid:@"333" ggid:@"444"];
   
#warning TEST AppsFlyer
    [AppsFlyerLib shared].appsFlyerDevKey = @"fZvuk792H9hJQKmaTwuXxA";
    [AppsFlyerLib shared].appleAppID = @"1382108510";
    [AppsFlyerLib shared].delegate = self;
    [AppsFlyerLib shared].isDebug = YES;
    NSString *openId = [TraceAnalysis getOpenId];
    [AppsFlyerLib shared].customerUserID = openId;
    
    NSString *appsFlyerId = [[AppsFlyerLib shared] getAppsFlyerUID];
    [TraceAnalysis setAppsFlyerId:appsFlyerId];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    OtherViewController *vc = [[OtherViewController alloc] init];
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [TraceAnalysis becomeActive];
    
#warning TEST AppsFlyer
    [[AppsFlyerLib shared] start];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [TraceAnalysis resignActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

#pragma mark - AppsFlyerTrackerDelegate

- (void)onConversionDataSuccess:(NSDictionary *)conversionInfo {
    
    NSString *json = [self dictionaryToString:conversionInfo];
    NSString *message = [NSString stringWithFormat:@"onConversionData Success conversionInfo : %@",json];
    NSLog(@"%@",message);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceCampaignLogNotification" object:message];
    
    [TraceAnalysis getConversionData:conversionInfo completion:^(NSError *error, NSString *campaign) {
        NSString *message;
        if (error) {
            message = [NSString stringWithFormat:@"onConversionData getConversionData error : %@",error];
        }
        else {
            message = [NSString stringWithFormat:@"onConversionData getConversionData succeed campaign : %@",campaign];
        }
        
        NSLog(@"%@",message);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceCampaignLogNotification" object:message];
    }];
}

- (void)onConversionDataFail:(NSError *)error {
    
    NSString *message = [NSString stringWithFormat:@"onConversionData Fail error : %@",error];
    NSLog(@"%@",message);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceCampaignLogNotification" object:message];
}

#pragma mark - Util

- (NSString *)dictionaryToString:(id)object {
    if (nil == object) {
        return @"{}";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
