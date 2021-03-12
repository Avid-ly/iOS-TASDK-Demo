//
//
//  Created by samliu on 2017/7/10.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "LogItemData.h"

@implementation LogItemData

+(instancetype)LogData:(NSString*)log {
    LogItemData *d = [[LogItemData alloc] init];
    d.log = log;
    return d;
}

@end
