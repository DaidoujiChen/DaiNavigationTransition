//
//  UINavigationController+Swizzling.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/17.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "UINavigationController+Swizzling.h"

#import <objc/runtime.h>
#import "DaiNavigationTransition.h"
#import "DaiNavigationTransition+AccessObject.h"
#import "UINavigationController+ForIOS6.h"

@implementation UINavigationController (Swizzling)

+(void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzling:@selector(init) to:@selector(swizzling_init)];
        [self swizzling:@selector(initWithCoder:) to:@selector(swizzling_initWithCoder:)];
        [self swizzling:@selector(initWithNavigationBarClass:toolbarClass:) to:@selector(swizzling_initWithNavigationBarClass:toolbarClass:)];
        [self swizzling:@selector(initWithNibName:bundle:) to:@selector(swizzling_initWithNibName:bundle:)];
        [self swizzling:@selector(initWithRootViewController:) to:@selector(swizzling_initWithRootViewController:)];
        
        [self swizzling:@selector(pushViewController:animated:) to:@selector(swizzling_pushViewController:animated:)];
        [self swizzling:@selector(popViewControllerAnimated:) to:@selector(swizzling_popViewControllerAnimated:)];
        [self swizzling:@selector(popToRootViewControllerAnimated:) to:@selector(swizzling_popToRootViewControllerAnimated:)];
        [self swizzling:@selector(popToViewController:animated:) to:@selector(swizzling_popToViewController:animated:)];
    });
}

#pragma mark - method swizzling

-(id) swizzling_init {
    
    id returnObject = [self swizzling_init];
    if ([returnObject respondsToSelector:@selector(setDelegate:)]) {
        [returnObject performSelector:@selector(setDelegate:) withObject:self];
    }
    return returnObject;
    
}

-(id) swizzling_initWithCoder : (NSCoder*) aDecoder {
    
    id returnObject = [self swizzling_initWithCoder:aDecoder];
    if ([returnObject respondsToSelector:@selector(setDelegate:)]) {
        [returnObject performSelector:@selector(setDelegate:) withObject:self];
    }
    return returnObject;
    
}

-(id) swizzling_initWithNavigationBarClass : (Class) navigationBarClass toolbarClass : (Class) toolbarClass {
    
    id returnObject = [self swizzling_initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if ([returnObject respondsToSelector:@selector(setDelegate:)]) {
        [returnObject performSelector:@selector(setDelegate:) withObject:self];
    }
    return returnObject;
}

-(id) swizzling_initWithNibName : (NSString*) nibNameOrNil bundle : (NSBundle*) nibBundleOrNil {
    
    id returnObject = [self swizzling_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ([returnObject respondsToSelector:@selector(setDelegate:)]) {
        [returnObject performSelector:@selector(setDelegate:) withObject:self];
    }
    return returnObject;
    
}

-(id) swizzling_initWithRootViewController : (UIViewController*) rootViewController {
    
    id returnObject = [self swizzling_initWithRootViewController:rootViewController];
    if ([returnObject respondsToSelector:@selector(setDelegate:)]) {
        [returnObject performSelector:@selector(setDelegate:) withObject:self];
    }
    return returnObject;
    
}

-(void) swizzling_pushViewController : (UIViewController*) viewController animated : (BOOL) animated {
    DaiNavigationTransition.objects.isPush = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self swizzling_pushViewController:viewController animated:animated];
    } else {
        
        if (animated) {
            NSDictionary *preProcessDictionary = [self preProcessAnimation];
            [self swizzling_pushViewController:viewController animated:NO];
            [self sufProcessAnimation:preProcessDictionary];
        } else {
            [self swizzling_pushViewController:viewController animated:animated];
        }
        
    }
    
}

-(UIViewController*) swizzling_popViewControllerAnimated : (BOOL) animated {
    DaiNavigationTransition.objects.isPush = NO;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        return [self swizzling_popViewControllerAnimated:animated];
    } else {
        
        if (animated) {
            NSDictionary *preProcessDictionary = [self preProcessAnimation];
            UIViewController *popViewController = [self swizzling_popViewControllerAnimated:NO];
            [self sufProcessAnimation:preProcessDictionary];
            return popViewController;
        } else {
            return [self swizzling_popViewControllerAnimated:animated];
        }
        
    }
    return [self swizzling_popViewControllerAnimated:animated];
}

-(NSArray*) swizzling_popToRootViewControllerAnimated : (BOOL) animated {
    DaiNavigationTransition.objects.isPush = NO;
    return [self swizzling_popToRootViewControllerAnimated:animated];
}

-(NSArray*) swizzling_popToViewController : (UIViewController*) viewController animated : (BOOL) animated {
    DaiNavigationTransition.objects.isPush = NO;
    return [self swizzling_popToViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate

-(id<UIViewControllerAnimatedTransitioning>) navigationController : (UINavigationController*) navigationController
                                  animationControllerForOperation : (UINavigationControllerOperation) operation
                                               fromViewController : (UIViewController*) fromVC
                                                 toViewController : (UIViewController*) toVC {
    return [DaiNavigationTransition new];
}

#pragma mark - private method

+(void) swizzling : (SEL) before to : (SEL) after {
    Class class = [self class];
    
    SEL originalSelector = before;
    SEL swizzledSelector = after;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
