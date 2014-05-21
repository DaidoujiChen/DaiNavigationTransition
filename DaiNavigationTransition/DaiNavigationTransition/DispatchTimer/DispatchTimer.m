//
//  DispatchTimer.m
//  DispatchTimer
//
//  Created by 啟倫 陳 on 2014/3/30.
//  Copyright (c) 2014年 啟倫 陳. All rights reserved.
//

#import "DispatchTimer.h"

@interface DispatchTimer ()
@property (nonatomic) dispatch_source_t source;
@property (nonatomic, assign) DispatchTimerStatus innerStatus;
DispatchTimer* fireBlock(voidBlock block, NSTimeInterval delay, NSTimeInterval timeInterval, BOOL onMainThread, BOOL isRunOnce);
@end

@implementation DispatchTimer

#pragma mark - class method

+(DispatchTimer*) scheduledOnMainThreadImmediatelyWithTimeInterval : (NSTimeInterval) timeInterval
                                                             block : (voidBlock) block {
    return fireBlock(block, 0, timeInterval, YES, NO);
}

+(DispatchTimer*) scheduledInBackgroundImmediatelyWithTimeInterval : (NSTimeInterval) timeInterval
                                                             block : (voidBlock) block {
    return fireBlock(block, 0, timeInterval, NO, NO);
}

+(DispatchTimer*) scheduledOnMainThreadAfterDelay : (NSTimeInterval) delay
                                     timeInterval : (NSTimeInterval) timeInterval
                                            block : (voidBlock) block {
    return fireBlock(block, delay, timeInterval, YES, NO);
}

+(DispatchTimer*) scheduledInBackgroundAfterDelay : (NSTimeInterval) delay
                                     timeInterval : (NSTimeInterval) timeInterval
                                            block : (voidBlock) block {
    return fireBlock(block, delay, timeInterval, NO, NO);
}

+(DispatchTimer*) scheduledOnMainThreadOnceAfterDelay : (NSTimeInterval) delay
                                                block : (voidBlock) block {
    return fireBlock(block, delay, 0, YES, YES);
}

+(DispatchTimer*) scheduledInBackgroundOnceAfterDelay : (NSTimeInterval) delay
                                                block : (voidBlock) block {
    return fireBlock(block, delay, 0, NO, YES);
}

#pragma mark - instance method

-(void) invalidate {
    if (self.source) {
        self.innerStatus = DispatchTimerStatusInvalidate;
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
}

-(DispatchTimerStatus) status {
    return self.innerStatus;
}

#pragma mark - private

DispatchTimer* fireBlock(voidBlock block, NSTimeInterval delay, NSTimeInterval timeInterval, BOOL onMainThread, BOOL isRunOnce) {
    
    DispatchTimer *newTimer = [DispatchTimer new];
    newTimer.innerStatus = DispatchTimerStatusRunning;
    
    if (onMainThread) {
        newTimer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                 0,
                                                 0,
                                                 dispatch_get_main_queue());
    } else {
        newTimer.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                 0,
                                                 0,
                                                 dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    
    if (isRunOnce) {
        
        dispatch_source_set_timer(newTimer.source,
                                  dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC),
                                  DISPATCH_TIME_FOREVER,
                                  0);
        
        void(^onceBlock)(void) = ^() {
            block();
            [newTimer invalidate];
        };
        
        dispatch_source_set_event_handler(newTimer.source, onceBlock);
        
    } else {
        
        dispatch_source_set_timer(newTimer.source,
                                  dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC),
                                  timeInterval * NSEC_PER_SEC,
                                  0);
        
        dispatch_source_set_event_handler(newTimer.source, block);
        
    }
    
    dispatch_resume(newTimer.source);
    
    return newTimer;
}

@end
