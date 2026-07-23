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

+ (NSString *)dictionaryToString:(id)object {
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

+ (NSString *)base64Encode:(NSString *)value {
    NSData * data = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}


@end
