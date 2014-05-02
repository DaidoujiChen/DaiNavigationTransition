//
//  DaiNavigationTransition+TransitionStack.h
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/5/2.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransition.h"

@interface DaiNavigationTransition (TransitionStack)

void pushTransition(UIViewController* fromViewController, UIViewController* toViewController, TransitionBlock fromBlock, TransitionBlock toBlock);
void popTransition();
void clearStack();
NSDictionary* topTransition();

@end
