//
//  MainViewController.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/18.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ibaction

-(IBAction) pushAction : (id) sender {
    
    [self.navigationController pushViewController:[SecondViewController new]
                                         fromView:^UIView *(UIViewController *viewcontroller) {
                                             MainViewController *main = (MainViewController*) viewcontroller;
                                             return main.redView;
                                         }
                                           toView:^UIView *(UIViewController *viewcontroller) {
                                               SecondViewController *second = (SecondViewController*) viewcontroller;
                                               return second.redView;
                                           }];
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
}

@end
