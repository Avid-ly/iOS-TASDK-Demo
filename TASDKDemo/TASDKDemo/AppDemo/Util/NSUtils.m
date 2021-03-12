//
//  Utils.m
//  Recipe
//
//  Created by samliu on 2017/2/15.
//  Copyright © 2017年 Tasty Story. All rights reserved.
//

#import "NSUtils.h"
#import <AdSupport/AdSupport.h>
#import "AppBasicDefine.h"
@implementation NSUtils
const static CGFloat TOAST_SHORT_TIME = 1.5;
const static CGFloat TOAST_LONG_TIME = 3;

+(NSString*) getLocalisedString:(NSString*) key {
    NSString* text = NSLocalizedString(key, nil);
    return text;
}

+ (void)adjustLabelHeightFitInCenter:(UILabel *)label height:(CGFloat) height {
    CGRect newFrame = label.frame;
    CGSize newSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    // adjust the label the the new height.
    newFrame.size.height = newSize.height;
    newFrame.origin.y += (height - newSize.height) / 2;
    label.frame = newFrame;
}

+ (void)adjustLabelHeightToFitContent:(UILabel *)label {
    CGRect newFrame = label.frame;
    CGSize newSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, CGFLOAT_MAX)];
    // adjust the label the the new height.
    newFrame.size.height = newSize.height;
    label.frame = newFrame;
}

+ (void)adjustLabelWeightToFitContent:(UILabel *)label {
    CGRect newFrame = label.frame;
    CGSize newSize = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, label.frame.size.height)];
    // adjust the label the the new height.
    newFrame.size.width = newSize.width;
    label.frame = newFrame;
}

+ (CGSize) getUILabelTextCGSizeUILabel:(UILabel *) label {
    NSDictionary *dictionary = @{NSFontAttributeName: label.font};
    CGSize cgSize = [label.text boundingRectWithSize:CGSizeMake(0,0) options:NSStringDrawingTruncatesLastVisibleLine
                     | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:dictionary context:nil]
    .size;
    return cgSize;
}

+ (void)openAppStoreForInstall:(NSString *)appid{
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openAppStoreForInfo:(NSString *)appid{
    NSString * url = [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)openAppStoreForRate:(NSString *)appid{
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",appid];
    
//    NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appid];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)showShortToastMessage:(NSString *)message {
    [self showToastMessage:message isShort:YES];
}

+ (void)showLongToastMessage:(NSString *)message {
    [self showToastMessage:message isShort:NO];
}

+ (void)showToastMessage:(NSString *)message isShort:(BOOL)isShort {

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showView = [[UIView alloc]init];
    showView.backgroundColor = UIColorRGBAif(0, 0, 0, 0.75);
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 0;
    showView.layer.cornerRadius = 4.0f;
    showView.layer.masksToBounds = YES;
    [window addSubview:showView];

    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, 300, 300);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    [self adjustLabelWeightToFitContent:label];
    CGRect labelFrame = label.frame;
    if (labelFrame.size.width > window.frame.size.width - 30 * 2) {
        labelFrame.size.width = window.frame.size.width - 30 * 2;
        label.frame = labelFrame;
    }
    [self adjustLabelHeightToFitContent:label];
    [showView addSubview:label];

    showView.frame = CGRectMake(0, 0,
            label.frame.size.width + 20 * 2, label.frame.size.height + 20 * 2);
    showView.center = CGPointMake(window.frame.size.width / 2, window.frame.size.height / 2);
    label.center = CGPointMake(showView.frame.size.width / 2, showView.frame.size.height / 2);
    [UIView animateWithDuration:0.5 animations:^{ showView.alpha = 1; }
            completion:^(BOOL finished) {
                if (finished) {
                    [self performSelector:@selector(removeFromSuperviewWithView:)
                               withObject:showView
                               afterDelay:isShort ? TOAST_SHORT_TIME : TOAST_LONG_TIME];
                }
            }];
}

+ (void)removeFromSuperviewWithView:(UIView *)view {
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

+ (NSString *)idfv {
    NSString *str = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return str;
}

+ (NSString *)idfa {
    NSString *str = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return str;
}

+ (void)logTag:(NSString *)tag message:(NSString *)message {
    [self logMessage:[NSString stringWithFormat:@"%@ %@", tag, message]];
}

+ (void)logMessage:(NSString *)message {
#ifdef DEBUG
    NSLog(@"%@", message);
#endif
}

+ (NSString *)getDateFormatterString:(int64_t)time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];

    return [dateFormatter stringFromDate:date];
}
@end
