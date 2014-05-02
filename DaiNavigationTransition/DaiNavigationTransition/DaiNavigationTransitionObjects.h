//
//  DaiNavigationTransitionObjects.h
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/5/2.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaiNavigationTransitionObjects : NSObject

@property (nonatomic, strong) NSMutableArray* transitionStack;
@property (nonatomic, assign) BOOL isPush;

@end
