//
//  DispatchTimer.h
//  DispatchTimer
//
//  Created by 啟倫 陳 on 2014/3/30.
//  Copyright (c) 2014年 啟倫 陳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DispatchTimerStatusRunning,
    DispatchTimerStatusInvalidate
} DispatchTimerStatus;

typedef void(^voidBlock)(void);

@interface DispatchTimer : NSObject

#pragma mark - Fire Immediately

+(DispatchTimer*) scheduledOnMainThreadImmediatelyWithTimeInterval : (NSTimeInterval) timeInterval
                                                             block : (voidBlock) block;

+(DispatchTimer*) scheduledInBackgroundImmediatelyWithTimeInterval : (NSTimeInterval) timeInterval
                                                             block : (voidBlock) block;

#pragma mark - Fire After Delay

+(DispatchTimer*) scheduledOnMainThreadAfterDelay : (NSTimeInterval) delay
                                     timeInterval : (NSTimeInterval) timeInterval
                                            block : (voidBlock) block;

+(DispatchTimer*) scheduledInBackgroundAfterDelay : (NSTimeInterval) delay
                                     timeInterval : (NSTimeInterval) timeInterval
                                            block : (voidBlock) block;

#pragma mark - Fire Once

+(DispatchTimer*) scheduledOnMainThreadOnceAfterDelay : (NSTimeInterval) delay
                                                block : (voidBlock) block;

+(DispatchTimer*) scheduledInBackgroundOnceAfterDelay : (NSTimeInterval) delay
                                                block : (voidBlock) block;

#pragma mark - Cancel Timer

-(void) invalidate;
-(DispatchTimerStatus) status;

@end
