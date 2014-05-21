//
//  UINavigationController+ForIOS6.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/5/20.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "UINavigationController+ForIOS6.h"

#import "DispatchTimer.h"
#import "DaiNavigationTransition+AccessObject.h"
#import "DaiNavigationTransition+TransitionStack.h"

@implementation UIView (ConvertToImage)

-(UIImage*) convertToImage {

    UIImage *returnimage;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnimage;
    
}

@end

@implementation UINavigationController (ForIOS6)

-(NSDictionary*) preProcessAnimation {
    
    NSString *viewControllerKeyString;
    NSString *blockKeyString;
    
    if (DaiNavigationTransition.objects.isPush) {
        viewControllerKeyString = @"fromViewController";
        blockKeyString = @"fromBlock";
    } else {
        viewControllerKeyString = @"toViewController";
        blockKeyString = @"toBlock";
    }
    
    NSDictionary *stackDictionary = topTransition();
    
    if (self.topViewController == [stackDictionary objectForKey:viewControllerKeyString]) {
        
        TransitionBlock fromBlock = [stackDictionary objectForKey:blockKeyString];
        UIView *fromView = fromBlock(self.topViewController);
        fromView.hidden = YES;
        UIImageView *fromViewControllerSnapshot = [[UIImageView alloc] initWithImage:[self.view convertToImage]];
        fromView.hidden = NO;
        UIImageView *fromViewSnapshot = [[UIImageView alloc] initWithImage:[fromView convertToImage]];
        CGRect fromViewFrame = [self.view convertRect:fromView.frame fromView:fromView.superview];
        return @{@"fromViewControllerSnapshot": fromViewControllerSnapshot, @"fromViewSnapshot": fromViewSnapshot, @"fromViewFrame": [NSValue valueWithCGRect:fromViewFrame]};
        
    } else {
        UIImageView *fromViewControllerSnapshot = [[UIImageView alloc] initWithImage:[self.view convertToImage]];
        return @{@"fromViewControllerSnapshot": fromViewControllerSnapshot};
    }
    
    return nil;
    
}

-(void) sufProcessAnimation : (NSDictionary*) preProcessDictionary {
    
    NSString *viewControllerKeyString;
    NSString *blockKeyString;
    
    if (DaiNavigationTransition.objects.isPush) {
        viewControllerKeyString = @"toViewController";
        blockKeyString = @"toBlock";
    } else {
        viewControllerKeyString = @"fromViewController";
        blockKeyString = @"fromBlock";
    }
    
    NSDictionary *stackDictionary = topTransition();
    
    if (self.topViewController == [stackDictionary objectForKey:viewControllerKeyString]) {
        
        UIImageView *fromViewControllerSnapshot = [preProcessDictionary objectForKey:@"fromViewControllerSnapshot"];
        UIImageView *fromViewSnapshot = [preProcessDictionary objectForKey:@"fromViewSnapshot"];
        CGRect fromViewFrame = [[preProcessDictionary objectForKey:@"fromViewFrame"] CGRectValue];
        
        TransitionBlock toBlock = [stackDictionary objectForKey:blockKeyString];
        
        UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        fromViewControllerSnapshot.alpha = 1.0f;
        [containerView addSubview:fromViewControllerSnapshot];
        
        fromViewSnapshot.frame = fromViewFrame;
        [containerView addSubview:fromViewSnapshot];
        
        [self.view addSubview:containerView];
        
        [self waitingForDone:self.topViewController withBlock:toBlock completion:^{
            
            UIView *toView = toBlock(self.topViewController);
            toView.hidden = YES;
            [containerView removeFromSuperview];
            UIImageView *toViewControllerSnapshot = [[UIImageView alloc] initWithImage:[self.view convertToImage]];
            toView.hidden = NO;
            CGRect toViewFrame = [self.view convertRect:toView.frame fromView:toView.superview];
            
            [self.view addSubview:containerView];
            
            toViewControllerSnapshot.alpha = 0.0f;
            [containerView addSubview:toViewControllerSnapshot];
            
            [containerView bringSubviewToFront:fromViewSnapshot];
            
            [UIView animateWithDuration:animationDuration animations:^{
                fromViewControllerSnapshot.alpha = 0;
                toViewControllerSnapshot.alpha = 1.0f;
                fromViewSnapshot.frame = toViewFrame;
            } completion:^(BOOL finished) {
                [containerView removeFromSuperview];
            }];
            
        }];
        
    } else {
        
        UIImageView *fromViewControllerSnapshot = [preProcessDictionary objectForKey:@"fromViewControllerSnapshot"];
        UIImageView *toViewControllerSnapshot = [[UIImageView alloc] initWithImage:[self.view convertToImage]];
        
        UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        float deviation;
        if (DaiNavigationTransition.objects.isPush) deviation = 1.0f;
        else deviation = -1.0f;
        
        CGRect newFrame = containerView.frame;
        newFrame.origin.x += newFrame.size.width*deviation;
        [toViewControllerSnapshot setFrame:newFrame];
        [containerView addSubview:toViewControllerSnapshot];
        
        [containerView addSubview:fromViewControllerSnapshot];
        
        [self.view addSubview:containerView];
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            CGRect animationFrame = toViewControllerSnapshot.frame;
            animationFrame.origin.x -= animationFrame.size.width*deviation;
            [toViewControllerSnapshot setFrame:animationFrame];
            
            animationFrame = fromViewControllerSnapshot.frame;
            animationFrame.origin.x -= animationFrame.size.width*deviation;
            [fromViewControllerSnapshot setFrame:animationFrame];
            
        } completion:^(BOOL finished) {
            [containerView removeFromSuperview];
        }];
        
    }
    
}

#pragma mark - private

-(void) waitingForDone : (UIViewController*) controller withBlock : (TransitionBlock) block completion : (void(^)(void)) completion {
    
    static DispatchTimer *waitingTimer;
    
    waitingTimer = [DispatchTimer scheduledOnMainThreadImmediatelyWithTimeInterval:0.05f block:^{
        
        if (block(controller)) {
            [waitingTimer invalidate];
            waitingTimer = nil;
            completion();
        }
        
    }];
    
}

@end
