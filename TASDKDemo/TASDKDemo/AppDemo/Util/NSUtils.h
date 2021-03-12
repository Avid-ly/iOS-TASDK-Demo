//
//  Utils.h
//  Recipe
//
//  Created by samliu on 2017/2/15.
//  Copyright © 2017年 Tasty Story. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSUtils : NSObject

+(NSString*) getLocalisedString:(NSString*) key;

+ (void)adjustLabelHeightToFitContent:(UILabel *)label;
+ (void)adjustLabelWeightToFitContent:(UILabel *)label;
+ (CGSize) getUILabelTextCGSizeUILabel:(UILabel *) label;
+ (void)adjustLabelHeightFitInCenter:(UILabel *)label height:(CGFloat) height;

+ (void)openAppStoreForInfo:(NSString*) appid;
+ (void)openAppStoreForRate:(NSString*) appid;
+ (void)openAppStoreForInstall:(NSString*) appid;

+ (void)showShortToastMessage:(NSString *)message;
+ (void)showLongToastMessage:(NSString *)message;

+ (NSString *)idfv;
+ (NSString *)idfa;
+ (void)logMessage:(NSString *)message;
+ (void)logTag:(NSString *)tag message:(NSString *)message;

+ (NSString *)getDateFormatterString:(int64_t)time;
@end
