//
//  OtherViewController.m
//  AvidlyAnalysis
//
//  Created by steve on 2020/4/18.
//  Copyright © 2020 samliu. All rights reserved.
//

#import "AppDelegate.h"
#import "OtherViewController.h"
#import <TraceAnalysisSDK/TraceAnalysis.h>
#import "NSUtils.h"

#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    #import <AppTrackingTransparency/AppTrackingTransparency.h>
#else
#endif

// AF
#if __has_include(<AppsFlyerLib/AppsFlyerLib.h>)
#import <AppsFlyerLib/AppsFlyerLib.h>
#endif

// Firebase
#if __has_include(<FirebaseAnalytics/FirebaseAnalytics.h>)
    #import <FirebaseAnalytics/FirebaseAnalytics.h>
#endif

#if __has_include(<AppsFlyerLib/AppsFlyerLib.h>)
@interface OtherViewController () <AppsFlyerLibDelegate>
#else
@interface OtherViewController ()
#endif
{

}
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:scrollView];
    
    float y = 20;
    float height = 40;
    UIColor *btnColor = [UIColor cyanColor];
    
    UIButton *initBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    initBtn.backgroundColor = btnColor;
    initBtn.frame = CGRectMake(70, y, 250, height);
    [initBtn setTitle:@"initSDK" forState:UIControlStateNormal];
    [initBtn addTarget:self action:@selector(initSDK) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:initBtn];
    y = initBtn.frame.origin.y + initBtn.frame.size.height + 30;
    
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logBtn.backgroundColor = btnColor;
    logBtn.frame = CGRectMake(70, y, 250, height);
    [logBtn setTitle:@"打点测试" forState:UIControlStateNormal];
    [logBtn addTarget:self action:@selector(logTestClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:logBtn];
    y = logBtn.frame.origin.y + logBtn.frame.size.height + 30;
    
    btnColor = [UIColor orangeColor];;
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.backgroundColor = btnColor;
    button4.frame = CGRectMake(70, y, 250, height);
    [button4 setTitle:@"获取token/userId" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(getTokenClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button4];
    y = button4.frame.origin.y + button4.frame.size.height + 30;
    
    UIButton *button14 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button14.backgroundColor = btnColor;
    button14.frame = CGRectMake(70, y, 250, height);
    [button14 setTitle:@"初始化AF" forState:UIControlStateNormal];
    [button14 addTarget:self action:@selector(afInitClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button14];
    y = button14.frame.origin.y + button14.frame.size.height + 30;
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button5.backgroundColor = btnColor;
    button5.frame = CGRectMake(70, y, 250, height);
    [button5 setTitle:@"请求授权使用IDFA" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(requestIDFA) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button5];
    y = button5.frame.origin.y + button5.frame.size.height + 30;
    
    btnColor = [UIColor yellowColor];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.backgroundColor = btnColor;
    button2.frame = CGRectMake(70, y, 250, height);
    [button2 setTitle:@"登录上报 测试" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(loginLogClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button2];
    y = button2.frame.origin.y + button2.frame.size.height + 30;
    
    UIButton *button11 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button11.backgroundColor = btnColor;
    button11.frame = CGRectMake(70, y, 250, height);
    [button11 setTitle:@"ATT上报 测试" forState:UIControlStateNormal];
    [button11 addTarget:self action:@selector(attClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button11];
    y = button11.frame.origin.y + button11.frame.size.height + 30;
    
    UIButton *button13 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button13.backgroundColor = btnColor;
    button13.frame = CGRectMake(70, y, 250, height);
    [button13 setTitle:@"FirebaseId测试" forState:UIControlStateNormal];
    [button13 addTarget:self action:@selector(firebaseIdClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button13];
    y = button13.frame.origin.y + button13.frame.size.height + 30;
    
    btnColor = [UIColor cyanColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.backgroundColor = btnColor;
    button1.frame = CGRectMake(70, y+20, 250, height);
    [button1 setTitle:@"推广用户标签 测试" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(campaignTestClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button1];
    y = button1.frame.origin.y + button1.frame.size.height + 30;
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.backgroundColor = btnColor;
    button3.frame = CGRectMake(70, y, 250, height);
    [button3 setTitle:@"付费用户标签 测试" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(payUserLayerClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button3];
    y = button3.frame.origin.y + button3.frame.size.height + 30;

    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button6.backgroundColor = btnColor;
    button6.frame = CGRectMake(70, y, 250, height);
    [button6 setTitle:@"广告用户标签 测试" forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(adUserLayerClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button6];
    y = button6.frame.origin.y + button6.frame.size.height + 30;
    
    UIButton *button9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button9.backgroundColor = btnColor;
    button9.frame = CGRectMake(70, y, 250, height);
    [button9 setTitle:@"deeplink标签 测试" forState:UIControlStateNormal];
    [button9 addTarget:self action:@selector(campaignTestClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button9];
    y = button9.frame.origin.y + button9.frame.size.height + 30;
    
    UIButton *button10 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button10.backgroundColor = btnColor;
    button10.frame = CGRectMake(70, y, 250, height);
    [button10 setTitle:@"ABTest标签 测试" forState:UIControlStateNormal];
    [button10 addTarget:self action:@selector(abTestClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button10];
    y = button10.frame.origin.y + button10.frame.size.height + 30;
    
    UIButton *button12 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button12.backgroundColor = btnColor;
    button12.frame = CGRectMake(70, y, 250, height);
    [button12 setTitle:@"其他测试" forState:UIControlStateNormal];
    [button12 addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button12];
    y = button12.frame.origin.y + button12.frame.size.height + 30;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, y);
}

#pragma mark - Click

- (void)close {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (void)initSDK {
    [TraceAnalysisDebug setDebugLevel:TraceAnalysisDebugLevelLog];
    // 测试分层
    [TraceAnalysis initWithProductId:kProductId ChannelId:kChannelId AppID:kAppleAppID];
    [TraceAnalysis initDurationReportWithServerName:kServerName serverZone:kserverZone uid:kPlayerId ggid:kGGID];
    
    NSString *title = @"Succeed";
    NSString *message = [NSString stringWithFormat:@"init sdk succeed"];

    [self showAlert:title message:message];
}

- (void)logTestClick {
    [TraceAnalysis logWithKey:@"TestKey" value:@"TestValue"];
}

- (void)campaignTestClick {
    
    NSLog(@"campaignTestClick");
    
#if __has_include(<AppsFlyerLib/AppsFlyerLib.h>)
    [AppsFlyerLib shared].delegate = self;
    [[AppsFlyerLib shared] start];
#endif
    
}

- (void)loginLogClick {
    
    // Apple登录
    [TraceAnalysis logCommonLoginWithType:TraceAnalysisLoginTypeApple playerId:@"610401568" loginToken:@"eyJpc3N1ZWRfYXQiOjE1OTEzNjE3MDAzNDksImFsZyI6IkhTMjU2IiwidHlwIjoiSldUIn0.eyJiaW5kQXZpZGx5IjoiZmFsc2UiLCJpc1ZlcmlmaWVkRW1haWwiOiJmYWxzZSIsImJpbmRBcHBsZUlEIjoidHJ1ZSIsImJpbmRHb29nbGUiOiJmYWxzZSIsInBkdGlkIjoiNjAwMTgxIiwiaWRmYSI6IjU5RjY4NTBCLTg4MTktNDM2RC05OUUyLUYxNzk3NDY4MTRERCIsImJpbmRGYiI6ImZhbHNlIiwiYmluZEluc3RhZ3JhbSI6ImZhbHNlIiwiYmluZFR3aXR0ZXIiOiJmYWxzZSIsImJpbmRWaWQiOiJmYWxzZSIsImdhbWVHdWVzdElkIjoiODIyNDk5MjI5NDYwMDczNDgiLCJiaW5kQXBwbGVHYW1lQ2VudGVyIjoiZmFsc2UiLCJpZGZ2IjoiMDgzOTc3QkItNTg4Ri00RTU0LThGNDYtRjEyRjNBQTVGQUM1IiwiZXhwIjoxNTkxNDQ4MTAwfQ.ZFN2SuJHBgV8UrRL6nHsf-qcb3ZjwS9KcWUs7fN33GI" extension:nil];
    
    // AASDK Apple登录
    [TraceAnalysis logAASLoginWithType:TraceAnalysisLoginTypeApple playerId:@"75773957298455537" loginToken:@"eyJpc3N1ZWRfYXQiOjE1OTM3NTYwNzcwMjUsImFsZyI6IkhTMjU2IiwidHlwIjoiSldUIn0" ggid:@"75773957298455537" extension:nil];
    
//    // email登录
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:@"value1" forKey:@"key1"];
//    [dic setValue:@"value1" forKey:@"key2"];
//    [dic setValue:@"value1" forKey:@"key3"];
//    NSString *json = [NSUtils dictionaryToString:dic];
//    NSString *base64Json = [NSUtils base64Encode:json];
//
//    NSMutableDictionary *extension = [[NSMutableDictionary alloc] init];
//    [extension setValue:base64Json forKey:@"extInfo"];
//
//    [TraceAnalysis logCommonLoginWithType:TraceAnalysisLoginTypeEmail playerId:@"100100100" loginToken:@"steve@game.com" extension:extension];
    
    
    NSString *message = @"登录上报结束";
    [self showAlert:@"Tip" message:message];
}

- (void)attClick {
//    [TraceAnalysis logTrackingAuthorizationStatus];
    
    NSString *message = @"ATT上报结束";
    [self showAlert:@"Tip" message:message];
}

- (void)payUserLayerClick {
    [TraceAnalysis getPayUserLayerWithCmpletion:^(NSError *error, NSString *payUserLayer) {
        NSString *title = @"Tip";
        NSString *message;
        if (error) {
            title = @"Error";
            message = [NSString stringWithFormat:@"getPayUserLayerWithCmpletion error : %@",error];
        }
        else {
            title = @"Succeed";
            message = [NSString stringWithFormat:@"getPayUserLayerWithCmpletion succeed payUserLayer : %@",payUserLayer];
        }
        
        [self showAlert:title message:message];
    }];
}

- (void)getTokenClick {
    
    NSString *token = [TraceAnalysis staToken];
    if (token == nil) {
        token = @"还未获取到token，请稍后再试";
    }
    
    [self showAlert:@"token" message:token];
}

- (void)requestIDFA {
    if (@available(iOS 14.0, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            
            NSString *message = @"\nATT授权结果说明:\n0 --> Determined\n1 -->    Restricted\n2 -->         Denied\n3 -->   Authorized";
            NSString *title = [NSString stringWithFormat:@"当前授权结果%i",(int)status];
            [self showAlert:title message:message];
            
        }];
    }
}

- (void)adUserLayerClick {
    [TraceAnalysis getAdUserLayerWithCmpletion:^(NSError *error, NSString *adUserLayer) {
        NSString *title = @"Tip";
        NSString *message;
        if (error) {
            title = @"Error";
            message = [NSString stringWithFormat:@"getAdUserLayerWithCmpletion error : %@",error];
        }
        else {
            title = @"Succeed";
            message = [NSString stringWithFormat:@"getAdUserLayerWithCmpletion succeed adUserLayer : %@",adUserLayer];
        }
        
        [self showAlert:title message:message];
    }];
}

- (void)firebaseIdClick {
    
#if __has_include(<FirebaseAnalytics/FirebaseAnalytics.h>)
    NSString *firebaseId = [FIRAnalytics appInstanceID];
    NSLog(@"%@",firebaseId);
    [TraceAnalysis setFirebaseId:firebaseId];
    
    NSString *message = [NSString stringWithFormat:@"setFirebaseId succeed firebaseId : %@",firebaseId];
    [self showAlert:@"Succeed" message:message];
#endif
}

- (void)afInitClick {
    // 测试AF
#if __has_include(<AppsFlyerLib/AppsFlyerLib.h>)
    NSString *version = [[AppsFlyerLib shared] getSDKVersion];
    NSLog(@"AppsFlyer version:%@",version);
    [AppsFlyerLib shared].appsFlyerDevKey = kAppsFlyerDevKey;
    [AppsFlyerLib shared].appleAppID = kAppleAppID;
    [AppsFlyerLib shared].delegate = self;
    [AppsFlyerLib shared].isDebug = YES;
//    NSString *openId = [TraceAnalysis getOpenId];
//    [AppsFlyerLib shared].customerUserID = openId;
    NSString *token = [TraceAnalysis staToken];
    [AppsFlyerLib shared].customerUserID = token;
    [[AppsFlyerLib shared] start];
#endif
}

- (void)abTestClick {
//    NSString *playerId = [NSUUID UUID].UUIDString;
//    NSString *playerId = @"your player id";
//    [TraceAnalysis getABTestWithPlayerId:playerId completion:^(NSError *error, NSString *abTest) {
//        NSString *title = @"Tip";
//        NSString *message;
//        if (error) {
//            title = @"Error";
//            message = [NSString stringWithFormat:@"getABTestWithCompletion playerId : %@ error : %@", playerId, error];
//        }
//        else {
//            title = @"Succeed";
//            message = [NSString stringWithFormat:@"getABTestWithCompletion playerId :%@ succeed abTest : %@", playerId, abTest];
//        }
//
//        [self showAlert:title message:message];
//    }];
    
//    NSString *playerId = [NSUUID UUID].UUIDString;
//    [TraceAnalysis getABTestWithCmpletion:^(NSError *error, NSString *abTest) {
//        NSString *title = @"Tip";
//        NSString *message;
//        if (error) {
//            title = @"Error";
//            message = [NSString stringWithFormat:@"getABTestWithCompletion playerId : %@ error : %@", playerId, error];
//        }
//        else {
//            title = @"Succeed";
//            message = [NSString stringWithFormat:@"getABTestWithCompletion playerId :%@ succeed abTest : %@", playerId, abTest];
//        }
//
//        [self showAlert:title message:message];
//    }];
}

#pragma mark - AppsFlyerTrackerDelegate

- (void)onConversionDataSuccess:(NSDictionary *)conversionInfo {
    
    NSString *json = [NSUtils dictionaryToString:conversionInfo];
    NSString *message = [NSString stringWithFormat:@"onConversionData Success conversionInfo : %@",json];
    NSLog(@"%@",message);
    
    [TraceAnalysis getConversionData:conversionInfo completion:^(NSError *error, NSString *campaign) {
        NSString *message;
        if (error) {
            message = [NSString stringWithFormat:@"getConversionData error : %@",error];
        }
        else {
            message = [NSString stringWithFormat:@"getConversionData succeed campaign : %@",campaign];
        }
        
        [self showAlert:@"Tip" message:message];
    }];
    
//    [TraceAnalysis getDeeplink:conversionInfo completion:^(NSError *error, NSString *deeplink) {
//        NSString *message;
//        if (error) {
//            message = [NSString stringWithFormat:@"getDeeplink error : %@",error];
//        }
//        else {
//            message = [NSString stringWithFormat:@"getDeeplink succeed deeplink : %@",deeplink];
//        }
//        
//        [self showAlert:@"Tip" message:message];
//    }];
}

- (void)onConversionDataFail:(NSError *)error {
    
    NSString *message = [NSString stringWithFormat:@"onConversionData Fail error : %@",error];
    NSLog(@"%@",message);
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceCampaignLogNotification" object:message];
//
//    [self close];
    
    [self showAlert:@"Tip" message:message];
}

#pragma mark - Alert

- (void)showAlert:(NSString *)title message:(NSString *)message {
    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - test

- (void)test {
    
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
        [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL success) {
            NSLog(@"xxxxxxxxxxxxxx");
        }];
    }
}

@end
