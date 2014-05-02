//
//  DaiNavigationTransition+AccessObject.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/18.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransition+AccessObject.h"

#import <objc/runtime.h>

@implementation DaiNavigationTransition (AccessObject)

static const char OBJECTSPOINTER;

+(DaiNavigationTransitionObjects*) objects {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objc_setAssociatedObject(self, &OBJECTSPOINTER, [DaiNavigationTransitionObjects new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
    return objc_getAssociatedObject(self, &OBJECTSPOINTER);
    
}

@end
