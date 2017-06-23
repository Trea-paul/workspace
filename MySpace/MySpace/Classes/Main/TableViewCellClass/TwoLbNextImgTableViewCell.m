//
//  TwoLbNextImgTableViewCell.m
//  CYSDemo
//
//  Created by Paul on 2017/5/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "TwoLbNextImgTableViewCell.h"


@implementation TwoLbNextImgTableViewCell


+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel
{
    return 45;
}

- (void)setup
{
    self.topLeftLb.font = FONT_SIZE(17);
    self.topLeftLb.textColor = HexRGB(0x333333);
    
    self.topCenterLb.font = FONT_SIZE(15);
    self.topCenterLb.textColor = HexRGB(0x999999);
    self.topCenterLb.textAlignment = NSTextAlignmentRight;
    
//    RACChannelTo(self.topCenterLb, text) = RACChannelTo(self, cellModel.value);
    RAC(self,topCenterLb.text) = RACObserve(self, cellModel.value);
    
    self.topRightImg.image = [UIImage imageNamed:@"cell_more"];
}

- (void)updateCellFrame
{
    WeakSelf(self);
    [self.topLeftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 45));
    }];
    
    [self.topCenterLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-36);
        make.size.mas_equalTo(CGSizeMake(200, 45));
    }];
    
    [self.topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(6, 10));
        make.centerY.mas_equalTo(weakself.mas_centerY);
    }];
    
    
    
    
}





@end
