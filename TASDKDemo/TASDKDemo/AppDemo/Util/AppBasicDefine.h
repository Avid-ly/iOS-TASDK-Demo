//
//  AppBasicDefine.h
//
//  Created by samliu on 2017/7/7.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define KDeviceHeight ([UIScreen mainScreen].bounds.size.height)

#define kScaleX (kDeviceWidth/360.0)

//颜色
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorRGBAif(r,g,b,a) [UIColor \
colorWithRed:((float)(r))/255.0 \
green:((float)(g))/255.0 \
blue:((float)(b))/255.0 alpha:a]

#define UIColorRGBAi(r,g,b,a) [UIColor \
colorWithRed:((float)(r))/255.0 \
green:((float)(g))/255.0 \
blue:((float)(b))/255.0 alpha:((float)(a))/255.0]

#define UIColorRGBAf(r,g,b,a) [UIColor \
colorWithRed:r \
green:g \
blue:b alpha:a]

#define BoolToString(s) (s?@"True":@"False")


//字体
#define STFont(s) ([UIFont systemFontOfSize:s])
#define STBoldFont(s) ([UIFont boldSystemFontOfSize:s])
#define UIFontWithNameSize(n,s) ([UIFont fontWithName:n size:s])
