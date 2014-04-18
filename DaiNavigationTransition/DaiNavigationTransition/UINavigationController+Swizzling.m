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

@implementation UINavigationController (Swizzling)

+(void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzling:@selector(initWithRootViewController:) to:@selector(swizzling_initWithRootViewController:)];
    });
}

#pragma mark - method swizzling

-(id) swizzling_initWithRootViewController : (UIViewController*) rootViewController {
    
    id returnObject = [self swizzling_initWithRootViewController:rootViewController];
    if ([returnObject respondsToSelector:@selector(setDelegate:)]) {
        [returnObject performSelector:@selector(setDelegate:) withObject:self];
    }
    return returnObject;
    
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
