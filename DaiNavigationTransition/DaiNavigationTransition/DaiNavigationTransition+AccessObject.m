//
//  DaiNavigationTransition+AccessObject.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/18.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransition+AccessObject.h"

#import <objc/runtime.h>

@implementation DaiNavigationTransition (AccessObject)

static const char TRANSITIONSTACKPOINTER;

NSMutableArray* transitionStack() {
    
    static id self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self = [DaiNavigationTransition class];
        objc_setAssociatedObject(self, &TRANSITIONSTACKPOINTER, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &TRANSITIONSTACKPOINTER);
    
}

void pushTransition(UIViewController* fromViewController, UIViewController* toViewController, TransitionBlock fromBlock, TransitionBlock toBlock) {
    
    NSMutableDictionary *stackDictionary = [NSMutableDictionary dictionary];
    
    [stackDictionary setObject:fromViewController forKey:@"fromViewController"];
    [stackDictionary setObject:toViewController forKey:@"toViewController"];
    [stackDictionary setObject:[fromBlock copy] forKey:@"fromBlock"];
    [stackDictionary setObject:[toBlock copy] forKey:@"toBlock"];
    
    [transitionStack() addObject:stackDictionary];
    
}

void popTransition() {
    [transitionStack() removeLastObject];
}

NSDictionary* topTransition() {
    return [transitionStack() lastObject];
}

@end
