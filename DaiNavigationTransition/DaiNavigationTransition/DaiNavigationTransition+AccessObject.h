//
//  DaiNavigationTransition+AccessObject.h
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/18.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransition.h"

typedef UIView*(^TransitionBlock)(UIViewController* viewcontroller);

@interface DaiNavigationTransition (AccessObject)

void pushTransition(UIViewController* fromViewController, UIViewController* toViewController, TransitionBlock fromBlock, TransitionBlock toBlock);
void popTransition();
NSDictionary* topTransition();

@end
