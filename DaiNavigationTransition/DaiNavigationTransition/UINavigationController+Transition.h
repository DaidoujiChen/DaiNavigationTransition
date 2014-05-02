//
//  UINavigationController+Transition.h
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/17.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DaiNavigationTransition+TransitionStack.h"
#import "UINavigationController+Swizzling.h"

@interface UINavigationController (Transition)

-(void) pushViewController:(UIViewController *)viewController fromView : (TransitionBlock) fromView toView : (TransitionBlock) toView;
-(void) clearTransitions;

@end
