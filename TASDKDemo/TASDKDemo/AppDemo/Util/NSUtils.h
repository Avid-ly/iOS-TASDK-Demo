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

+ (void)adjustLabelHeightToFitContent:(UILabel *)label;
+ (void)adjustLabelWeightToFitContent:(UILabel *)label;


+ (NSString *)dictionaryToString:(id)object;
+ (NSString *)base64Encode:(NSString *)value;

@end
