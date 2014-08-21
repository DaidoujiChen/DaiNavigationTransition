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

+ (void)pushTransition:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController fromBlock:(TransitionBlock)fromBlock toBlock:(TransitionBlock)toBlock
{
    [[DaiNavigationTransition objects].transitionStack addObject:@{@"fromViewController": fromViewController, @"toViewController": toViewController, @"fromBlock": [fromBlock copy], @"toBlock": [toBlock copy]}];
}

+ (void)popTransition
{
    [[DaiNavigationTransition objects].transitionStack removeLastObject];
}

+ (void)clearStack
{
    [[DaiNavigationTransition objects].transitionStack removeAllObjects];
}

+ (NSDictionary *)topTransition
{
    return [[DaiNavigationTransition objects].transitionStack lastObject];
}

@end
