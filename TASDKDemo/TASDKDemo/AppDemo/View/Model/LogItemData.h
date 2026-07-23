//
//  Created by samliu on 2017/7/10.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LOGLEVEL) {
    LOGLEVEL_v = 0,
    LOGLEVEL_i = 1,
    LOGLEVEL_d = 2,
    LOGLEVEL_w = 3,
    LOGLEVEL_e = 4,
};

@interface LogItemData : NSObject

+(instancetype)LogData:(NSString*)log;

@property (nonatomic) NSString *log;
@property (nonatomic) LOGLEVEL level;

@end
