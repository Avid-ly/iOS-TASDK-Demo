//
//  LogEventThread.h
//
//  Created by samliu on 2017/7/7.
//  Copyright © 2017年 samliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogEventThreadListener <NSObject>

@optional
- (void)eventLogCount:(NSInteger)logCount;

- (void)eventLogFinish:(NSInteger)logCount;

- (void)eventLogValue:(NSString*)value;

@end

@interface LogEventThread : NSObject

@property (nonatomic) NSInteger groupId;
@property (nonatomic) NSInteger sleepTime;
@property (nonatomic) NSInteger threadCount;
@property (nonatomic) NSInteger sendCount;
@property (nonatomic, copy) NSString *key;

@property (nonatomic) id<LogEventThreadListener> logEventCallback;

- (void)start;

@end
