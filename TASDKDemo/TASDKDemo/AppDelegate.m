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
#import <AppsFlyerLib/AppsFlyerTracker.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

//#import "SensorsAnalyticsSDK.h"

@interface AppDelegate () <AppsFlyerTrackerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"idfa:%@",idfa);
    
    NSString *version = [[AppsFlyerTracker sharedTracker] getSDKVersion];
    NSLog(@"AppsFlyer version:%@",version);
    
    [TraceAnalysisDebug setDebugLevel:TraceAnalysisDebugLevelLog];
    [TraceAnalysis initWithProductId:@"600108" ChannelId:@"32407" AppID:@"hello" zone:1];
    [TraceAnalysis initDurationReportWithServerName:@"111" serverZone:@"222" uid:@"333" ggid:@"444"];
   
#warning TEST AppsFlyer
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"fZvuk792H9hJQKmaTwuXxA";
    [AppsFlyerTracker sharedTracker].appleAppID = @"1382108510";
    [AppsFlyerTracker sharedTracker].delegate = self;
    [AppsFlyerTracker sharedTracker].isDebug = YES;
    NSString *openId = [TraceAnalysis getOpenId];
    [AppsFlyerTracker sharedTracker].customerUserID = openId;
    
    NSString *appsFlyerId = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
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
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
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
