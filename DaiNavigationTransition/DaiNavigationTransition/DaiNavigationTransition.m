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

@interface DaiNavigationTransition ()

- (void)daiAnimationFromViewController:(UIViewController *)fromViewController fromBlock:(TransitionBlock)fromBlock toViewController:(UIViewController *)toViewController toBlock:(TransitionBlock)toBlock containerView:(UIView *)containerView isNeedPop:(BOOL)isNeedPop duration:(NSTimeInterval)duration transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)defaultAnimationFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController containerView:(UIView *)containerView duration:(NSTimeInterval)duration transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

@end

@implementation DaiNavigationTransition

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    NSDictionary *stackDictionary = [DaiNavigationTransition topTransition];
    
    TransitionBlock fromBlock;
    TransitionBlock toBlock;

    if (fromViewController == stackDictionary[@"fromViewController"] && toViewController == stackDictionary[@"toViewController"]) {
        
        //when fromViewController = stackDictionary[@"fromViewController"], is a push action
        fromBlock = stackDictionary[@"fromBlock"];
        toBlock = stackDictionary[@"toBlock"];

        [self daiAnimationFromViewController:fromViewController fromBlock:fromBlock toViewController:toViewController toBlock:toBlock containerView:containerView isNeedPop:NO duration:duration transitionContext:transitionContext];
    } else if (fromViewController == stackDictionary[@"toViewController"] && toViewController == stackDictionary[@"fromViewController"]) {
        
        //when fromViewController = stackDictionary[@"fromViewController"], is a pop action
        fromBlock = stackDictionary[@"toBlock"];
        toBlock = stackDictionary[@"fromBlock"];
        
        [self daiAnimationFromViewController:fromViewController fromBlock:fromBlock toViewController:toViewController toBlock:toBlock containerView:containerView isNeedPop:YES duration:duration transitionContext:transitionContext];
    } else {
        
        // if not in stack, make a normal animation
        [self defaultAnimationFromViewController:fromViewController toViewController:toViewController containerView:containerView duration:duration transitionContext:transitionContext];
    }
    
}

#pragma mark - private

- (void)defaultAnimationFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController containerView:(UIView *)containerView duration:(NSTimeInterval)duration transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    float deviation = ([DaiNavigationTransition objects].isPush)?1.0f:-1.0f;
    
    CGRect newFrame = toViewController.view.frame;
    newFrame.origin.x += newFrame.size.width*deviation;
    toViewController.view.frame = newFrame;
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect animationFrame = toViewController.view.frame;
        animationFrame.origin.x -= animationFrame.size.width*deviation;
        toViewController.view.frame = animationFrame;
        
        animationFrame = fromViewController.view.frame;
        animationFrame.origin.x -= animationFrame.size.width*deviation;
        fromViewController.view.frame = animationFrame;
        
    } completion:^(BOOL finished) {
        [fromViewController.view removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

- (void)daiAnimationFromViewController:(UIViewController *)fromViewController fromBlock:(TransitionBlock)fromBlock toViewController:(UIViewController *)toViewController toBlock:(TransitionBlock)toBlock containerView:(UIView *)containerView isNeedPop:(BOOL)isNeedPop duration:(NSTimeInterval)duration transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
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
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if (isNeedPop) {
            [DaiNavigationTransition popTransition];
        }
    }];
    
}

@end
