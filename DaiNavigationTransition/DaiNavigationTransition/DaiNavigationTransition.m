//
//  DaiNavigationTransition.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/17.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransition.h"

#import "DaiNavigationTransition+AccessObject.h"
#import "DaiNavigationTransition+TransitionStack.h"

@implementation DaiNavigationTransition

-(NSTimeInterval) transitionDuration : (id<UIViewControllerContextTransitioning>) transitionContext {
    return 0.5f;
}

-(void) animateTransition : (id<UIViewControllerContextTransitioning>) transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    NSDictionary *stackDictionary = topTransition();
    
    TransitionBlock fromBlock;
    TransitionBlock toBlock;
    
    BOOL isNeedPop;
    
    if (fromViewController == [stackDictionary objectForKey:@"fromViewController"] &&
        toViewController == [stackDictionary objectForKey:@"toViewController"]) {
        fromBlock = [stackDictionary objectForKey:@"fromBlock"];
        toBlock = [stackDictionary objectForKey:@"toBlock"];
        isNeedPop = NO;
    } else if (fromViewController == [stackDictionary objectForKey:@"toViewController"] &&
               toViewController == [stackDictionary objectForKey:@"fromViewController"]) {
        fromBlock = [stackDictionary objectForKey:@"toBlock"];
        toBlock = [stackDictionary objectForKey:@"fromBlock"];
        isNeedPop = YES;
    } else {
        
        float deviation;
        
        if (DaiNavigationTransition.objects.isPush) deviation = 1.0f;
        else deviation = -1.0f;

        CGRect newFrame = toViewController.view.frame;
        newFrame.origin.x += newFrame.size.width*deviation;
        [toViewController.view setFrame:newFrame];
        [containerView addSubview:toViewController.view];
        
        [containerView addSubview:fromViewController.view];
        
        [UIView animateWithDuration:duration animations:^{
            
            CGRect animationFrame = toViewController.view.frame;
            animationFrame.origin.x -= animationFrame.size.width*deviation;
            [toViewController.view setFrame:animationFrame];
            
            animationFrame = fromViewController.view.frame;
            animationFrame.origin.x -= animationFrame.size.width*deviation;
            [fromViewController.view setFrame:animationFrame];
            
        } completion:^(BOOL finished) {
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
        return;
    }
    
    UIView *fromView = fromBlock(fromViewController);
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    fromViewSnapshot.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    fromView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    UIView *toView = toBlock(toViewController);
    toView.hidden = YES;

    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        CGRect frame = [containerView convertRect:toView.frame fromView:toView.superview];
        fromViewSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        
        toView.hidden = NO;
        fromView.hidden = NO;
        [fromViewSnapshot removeFromSuperview];

        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        if (isNeedPop) {
            popTransition();
        }
    }];
    
}

@end
