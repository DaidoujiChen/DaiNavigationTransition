//
//  UINavigationController+Transition.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/17.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "UINavigationController+Transition.h"

@implementation UINavigationController (Transition)

-(void) pushViewController : (UIViewController*) viewController fromView : (TransitionBlock) fromView toView : (TransitionBlock) toView {

    pushTransition(self.topViewController, viewController, fromView, toView);
    [self pushViewController:viewController animated:YES];
    
}

-(void) clearTransitions {
    clearStack();
}

@end
