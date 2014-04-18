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

#pragma mark - UITableViewDataSource

-(NSInteger) tableView : (UITableView*) tableView numberOfRowsInSection : (NSInteger) section {
    
    return 20;
    
}

-(UITableViewCell*) tableView : (UITableView*) tableView cellForRowAtIndexPath : (NSIndexPath*) indexPath {
    
    static NSString *CellIdentifier = @"DefaultTableViewCell";
    DefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void) tableView : (UITableView*) tableView didSelectRowAtIndexPath : (NSIndexPath*) indexPath {
    
    [self.navigationController pushViewController:[SecondViewController new]
                                         fromView:^UIView *(UIViewController *viewcontroller) {
                                             MainViewController *main = (MainViewController*) viewcontroller;
                                             DefaultTableViewCell *cell = (DefaultTableViewCell*) [main.demoTableView cellForRowAtIndexPath:[main.demoTableView indexPathForSelectedRow]];
                                             return cell.redView;
                                         }
                                           toView:^UIView *(UIViewController *viewcontroller) {
                                               SecondViewController *second = (SecondViewController*) viewcontroller;
                                               return second.redView;
                                           }];
    
}

#pragma mark - life cycle

-(void) viewDidLoad {
    [super viewDidLoad];
    
    [self.demoTableView registerClass:[DefaultTableViewCell class] forCellReuseIdentifier:@"DefaultTableViewCell"];
}

@end
