//
//  JYHomeTableHeaderListCell.m
//  CYSDemo
//
//  Created by Paul on 2017/5/8.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYHomeTableHeaderListCell.h"

@implementation JYHomeTableHeaderListCell

+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel
{
    return 120;
}

- (void)setup
{
    self.topLeftLb.textColor = [UIColor blackColor];
    self.topLeftLb.font = [UIFont systemFontOfSize:16];
    
    self.topCenterLb.textColor = [UIColor grayColor];
    self.topCenterLb.font = [UIFont systemFontOfSize:14];

    self.topRightImg.image = [UIImage imageNamed:@"back"];
    
}

- (void)updateCellFrame
{
    self.topLeftLb.frame = CGRectMake(10, 5, 100, 30);
    self.topCenterLb.frame = CGRectMake(200, 5, 100, 30);
    self.topRightImg.frame = CGRectMake(300, 5, 30, 30);
}




@end
