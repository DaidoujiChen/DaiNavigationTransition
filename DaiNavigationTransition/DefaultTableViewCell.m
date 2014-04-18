//
//  DefaultTableViewCell.m
//  DaiNavigationTransition
//
//  Created by 啟倫 陳 on 2014/4/18.
//  Copyright (c) 2014年 ChilunChen. All rights reserved.
//

#import "DefaultTableViewCell.h"

@implementation DefaultTableViewCell

-(id) initWithStyle : (UITableViewCellStyle) style reuseIdentifier : (NSString*) reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
    
}


@end
