//
//  UINavigationController+ForIOS6.h
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/5/20.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ForIOS6)

-(NSDictionary*) preProcessAnimation;
-(void) sufProcessAnimation : (NSDictionary*) preProcessDictionary;

@end
