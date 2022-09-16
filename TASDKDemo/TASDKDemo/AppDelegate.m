//
//  AppDelegate.m

//
//  Created by samliu on 2017/6/29.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "AppDelegate.h"
#import "OtherViewController.h"
#import <TraceAnalysisSDK/TraceAnalysis.h>
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <StoreKit/StoreKit.h>>

@interface AppDelegate ()

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
    
    return YES;
    
    SKStoreProductViewController *vc;
}

@end
