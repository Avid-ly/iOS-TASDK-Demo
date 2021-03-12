//
//  LogEventThread.m
//
//  Created by samliu on 2017/7/7.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import "LogEventThread.h"
//#import "TraceAnalysis.h"
#import <TraceAnalysisSDK/TraceAnalysis.h>

@interface LogEventThread() {
    BOOL _isDoing;
    NSInteger _logCount;
    BOOL _finish;
    NSLock *_lock;
}

@end

@implementation LogEventThread

-(instancetype)init {
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
    }
    return self;
}

//float randomFloat(float Min, float Max){
//    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
//}

-(float) randomFloat:(float) Min max:(float)Max{
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

- (NSInteger)logCount{
    [_lock lock];
    if (_finish) {
        return _logCount;
    }
    _logCount ++;
    _finish = _logCount >= _sendCount;
    if (_finish) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // send finish
            if (_logEventCallback && [_logEventCallback respondsToSelector:@selector(eventLogFinish:)]) {
                _isDoing = NO;
                [_logEventCallback eventLogFinish:_sendCount];
            }
        });
    }
    [_lock unlock];
    return _logCount;
}

- (void)start{
    if (_isDoing) {
        return;
    }
    _finish = NO;
    _isDoing = YES;
    NSString * ll = [NSString stringWithFormat:@"%ld", _sendCount];
    NSInteger len = ll.length;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    //[numberFormatter setPositiveFormat:@"######"];
    //numberFormatter.formatWidth = 6;
    //numberFormatter.maximumIntegerDigits = 6;
    numberFormatter.minimumIntegerDigits = len;
    

    for (NSInteger i = 0; i < _threadCount; i++) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [NSThread sleepForTimeInterval:[self randomFloat:0 max:0.2]];
            while (true) {
                if (!_finish) {
                    NSInteger p = [self logCount];
                    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:p]];
                    NSString *value = [NSString stringWithFormat:@"[%@-%ld] : %@",_key, _groupId, formattedNumberString];
                    
                    [TraceAnalysis logWithKey:_key value:@{@"string":value, @"map":@{@"value_text":@"this is a map 240,172ba71246e542af9a4b8b6d520ef34a,2018-03-19 06:14:26,2018-03-19 03:44:28,600082,32400,2113123,_NEW_VI_LOAD,5,157.48.37.174,NA,NA,4,3006,NA,ID,[__brand:samsung`__env:1`__ad_id:0`__language:en_GB`__android_id:8d277d6a6da9e806`__config_ver:24`__orientation:l`__pkg:badminton.king.sportsgame.smash`__ver_name:2.11.3123`__model:SM-J110F`__system_version:19`__h:800`__os:android`__gaid:ff2f4537-e9fa-4c9d-80f7-d776e14878ac`__ver_code:2113123`__sta_token:172ba71246e542af9a4b8b6d520ef34a`__sdk_ver:2036`__device_id:`__install_fb:0`__act:_NEW_VI_LOAD`__aff_info:__w:480`__location:IN"}}];
                    if (p < 10) {
                        if (_logEventCallback && [_logEventCallback respondsToSelector:@selector(eventLogValue:)]) {
                            [_logEventCallback eventLogValue:value];
                        }
                    }
                    if (_logEventCallback && [_logEventCallback respondsToSelector:@selector(eventLogCount:)]) {
                        [_logEventCallback eventLogCount:p];
                    }
                    [NSThread sleepForTimeInterval:[self randomFloat:0 max:_sleepTime/1000.0]];
                }
                else{
                    break;
                }
            }
            
        });
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self randomFloat:0 max:0.2] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            //
//            
//        });
    }
}


@end
