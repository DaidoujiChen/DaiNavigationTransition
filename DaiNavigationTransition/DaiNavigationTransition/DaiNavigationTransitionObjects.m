//
//  DaiNavigationTransitionObjects.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/5/2.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DaiNavigationTransitionObjects.h"

@implementation DaiNavigationTransitionObjects

-(id) init {
    
    self = [super init];
    if (self) {
        self.transitionStack = [NSMutableArray array];
    }
    return self;
    
}

@end
