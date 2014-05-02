//
//  DaiNavigationTransition+TransitionStack.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/5/2.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransition+TransitionStack.h"

#import "DaiNavigationTransition+AccessObject.h"

@implementation DaiNavigationTransition (TransitionStack)

void pushTransition(UIViewController* fromViewController, UIViewController* toViewController, TransitionBlock fromBlock, TransitionBlock toBlock) {
    
    NSMutableDictionary *stackDictionary = [NSMutableDictionary dictionary];
    
    [stackDictionary setObject:fromViewController forKey:@"fromViewController"];
    [stackDictionary setObject:toViewController forKey:@"toViewController"];
    [stackDictionary setObject:[fromBlock copy] forKey:@"fromBlock"];
    [stackDictionary setObject:[toBlock copy] forKey:@"toBlock"];
    
    [DaiNavigationTransition.objects.transitionStack addObject:stackDictionary];
    
}

void popTransition() {
    [DaiNavigationTransition.objects.transitionStack removeLastObject];
}

void clearStack() {
    [DaiNavigationTransition.objects.transitionStack removeAllObjects];
}

NSDictionary* topTransition() {
    return [DaiNavigationTransition.objects.transitionStack lastObject];
}

@end
