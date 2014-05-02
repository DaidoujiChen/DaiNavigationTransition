//
//  DaiNavigationTransition.h
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/17.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DaiNavigationTransitionObjects.h"

typedef UIView*(^TransitionBlock)(UIViewController* viewcontroller);

@interface DaiNavigationTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end
