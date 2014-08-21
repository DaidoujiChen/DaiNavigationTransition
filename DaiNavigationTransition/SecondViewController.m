//
//  SecondViewController.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/18.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@end

@implementation SecondViewController

#pragma mark - ibaction

- (IBAction)pushAction:(id)sender
{
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}

@end
