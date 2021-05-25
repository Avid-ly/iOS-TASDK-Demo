//
//  OtherViewController.m
//  AvidlyAnalysis
//
//  Created by steve on 2020/4/18.
//  Copyright © 2020 samliu. All rights reserved.
//

#import "OtherViewController.h"
//#import "TraceJsonUtil.h"
//#import "TraceAnalysis.h"
#import <TraceAnalysisSDK/TraceAnalysis.h>
#import <AppsFlyerLib/AppsFlyerTracker.h>

#import <objc/runtime.h>
#import <objc/message.h>

#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#else
#endif

//#import "SensorsAnalyticsSDK.h"
//#import "SATestDatabase.h"

@interface OtherViewController () <AppsFlyerTrackerDelegate>
{
//    SATestDatabase *_testDataBase;
}
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setTitle:@"close" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = [UIColor orangeColor];
    
    float y = 100;
    float height = 40;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.backgroundColor = [UIColor orangeColor];
    button1.frame = CGRectMake(70, y, 250, height);
    [button1 setTitle:@"campaign测试" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(campaignTestClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button1];
    y = button1.frame.origin.y + button1.frame.size.height + 30;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.backgroundColor = [UIColor orangeColor];
    button2.frame = CGRectMake(70, y, 250, height);
    [button2 setTitle:@"loginLog测试" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(loginLogClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button2];
    y = button2.frame.origin.y + button2.frame.size.height + 30;
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.backgroundColor = [UIColor orangeColor];
    button3.frame = CGRectMake(70, y, 250, height);
    [button3 setTitle:@"payUserLayer" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(payUserLayerClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button3];
    y = button3.frame.origin.y + button3.frame.size.height + 30;
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.backgroundColor = [UIColor orangeColor];
    button4.frame = CGRectMake(70, y, 250, height);
    [button4 setTitle:@"GetToken" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(getTokenClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button4];
    y = button4.frame.origin.y + button4.frame.size.height + 30;
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button5.backgroundColor = [UIColor orangeColor];
    button5.frame = CGRectMake(70, y, 250, height);
    [button5 setTitle:@"请求授权IDFA" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(requestIDFA) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button5];
    y = button5.frame.origin.y + button5.frame.size.height + 30;
    
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button6.backgroundColor = [UIColor orangeColor];
    button6.frame = CGRectMake(70, y, 250, height);
    [button6 setTitle:@"adUserLayer" forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(adUserLayerClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button6];
    y = button6.frame.origin.y + button6.frame.size.height + 30;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, y);
}

- (void)close {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (void)campaignTestClick {
    
    [AppsFlyerTracker sharedTracker].delegate = self;
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)loginLogClick {
//    [TraceAnalysis commonLoginWithPlayerId:@"1111" loginType:@"appid" loginToken:@"22222"];
    
//    [TraceAnalysis commonLoginWithPlayerId:@"610401568" loginType:@"apple" loginToken:@"eyJpc3N1ZWRfYXQiOjE1OTEzNjE3MDAzNDksImFsZyI6IkhTMjU2IiwidHlwIjoiSldUIn0.eyJiaW5kQXZpZGx5IjoiZmFsc2UiLCJpc1ZlcmlmaWVkRW1haWwiOiJmYWxzZSIsImJpbmRBcHBsZUlEIjoidHJ1ZSIsImJpbmRHb29nbGUiOiJmYWxzZSIsInBkdGlkIjoiNjAwMTgxIiwiaWRmYSI6IjU5RjY4NTBCLTg4MTktNDM2RC05OUUyLUYxNzk3NDY4MTRERCIsImJpbmRGYiI6ImZhbHNlIiwiYmluZEluc3RhZ3JhbSI6ImZhbHNlIiwiYmluZFR3aXR0ZXIiOiJmYWxzZSIsImJpbmRWaWQiOiJmYWxzZSIsImdhbWVHdWVzdElkIjoiODIyNDk5MjI5NDYwMDczNDgiLCJiaW5kQXBwbGVHYW1lQ2VudGVyIjoiZmFsc2UiLCJpZGZ2IjoiMDgzOTc3QkItNTg4Ri00RTU0LThGNDYtRjEyRjNBQTVGQUM1IiwiZXhwIjoxNTkxNDQ4MTAwfQ.ZFN2SuJHBgV8UrRL6nHsf-qcb3ZjwS9KcWUs7fN33GI"];
    
//    [TraceAnalysis logAASLoginWithType:TraceAnalysisLoginTypeApple playerId:@"75773957298455537" loginToken:@"eyJpc3N1ZWRfYXQiOjE1OTM3NTYwNzcwMjUsImFsZyI6IkhTMjU2IiwidHlwIjoiSldUIn0" ggid:@"75773957298455537" extension:nil];
    
    [TraceAnalysis guestLoginWithGameId:@"user12345"];
}

- (void)payUserLayerClick {
    [TraceAnalysis getPayUserLayerWithCmpletion:^(NSError *error, NSString *payUserLayer) {
        if (error) {
            NSLog(@"error:%@",error);
        }
        else {
            NSLog(@"payUserLayer:%@",payUserLayer);
        }
    }];
}

- (void)getTokenClick {
    
    NSString *token = [TraceAnalysis staToken];
    if (token) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"token" message:token preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"token" message:@"还未获取到token，请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)requestIDFA {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"111"];
    if (@available(iOS 14.0, *)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"222"];
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"333"];
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"444"];
        }];
#else
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"555"];
        [self requestTrackingAuthorizationWithCompletionHandler:^(NSInteger status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"666"];
        }];
#endif
    }
}

- (void)requestTrackingAuthorizationWithCompletionHandler:(void(^)(NSInteger status))c {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"777"];
    Class ATTrackingManager = NSClassFromString(@"ATTrackingManager");
    if (ATTrackingManager != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"888"];
        SEL s = NSSelectorFromString(@"requestTrackingAuthorizationWithCompletionHandler:");
        ((void (*)(id, SEL, void(^)(NSInteger status))) objc_msgSend)(ATTrackingManager, s, c);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"999"];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"1010"];
        NSBundle *bundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AppTrackingTransparency.framework"];
        [bundle load];
        ATTrackingManager = NSClassFromString(@"ATTrackingManager");
        if (ATTrackingManager == nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"1111"];
            return;
        }
        else {
            SEL s = NSSelectorFromString(@"requestTrackingAuthorizationWithCompletionHandler:");
            ((void (*)(id, SEL, void(^)(NSInteger status))) objc_msgSend)(ATTrackingManager, s, c);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceIDFALogNotification" object:@"1212"];
        }
    }
}

- (void)adUserLayerClick {
    [TraceAnalysis getAdUserLayerWithCmpletion:^(NSError *error, NSString *adUserLayer) {
        if (error) {
            NSLog(@"error:%@",error);
        }
        else {
            NSLog(@"adUserLayer:%@",adUserLayer);
        }
    }];
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
        
        [self close];
    }];
    
    [TraceAnalysis getDeeplink:conversionInfo completion:^(NSError *error, NSString *deeplink) {
        if (error) {
            // error
        }
        else {
            // succeed
        }
    }];
    
    
}

- (void)onConversionDataFail:(NSError *)error {
    
    NSString *message = [NSString stringWithFormat:@"onConversionData Fail error : %@",error];
    NSLog(@"%@",message);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TraceCampaignLogNotification" object:message];
    
    [self close];
}

#pragma mark - Util

- (NSString *)dictionaryToString:(id)object {
    if (nil == object) {
        return @"{}";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
    }
    else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
