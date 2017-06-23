//
//  JYLiverTableViewListCell.m
//  CYSDemo
//
//  Created by Paul on 2017/6/7.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYLiverTableViewListCell.h"

@implementation JYLiverTableViewListCell

+ (CGFloat)cellHeightForCellModel:(JYTableViewListCellModel *)cellModel
{
    if (cellModel.topLeftLbTitle.length) {
        return 100;
    }
    return 84;
}

- (void)setup
{
    self.topLeftImg.image = ImageNamed(@"icon_index_live");
    self.topLeftImg.layer.cornerRadius = 5;
    
    // 热点
    self.topLeftLb.textColor = COLOR_STYLE_1;
    self.topLeftLb.font = FONT_SIZE(11);
    self.topLeftLb.layer.cornerRadius = 8.0f;
    self.topLeftLb.clipsToBounds = YES;
    self.topLeftLb.backgroundColor = COLOR_STYLE_9;
    self.topLeftLb.textAlignment = NSTextAlignmentCenter;
    
    // 标题
    self.topCenterLb.textColor = COLOR_STYLE_6;
    self.topCenterLb.font = FONT_SIZE(17);
    
    // 副标题
    self.centerLb.textColor = COLOR_STYLE_10;
    self.centerLb.font = FONT_SIZE(14);
    
    // 时间
    self.centerRightLb.textColor = COLOR_STYLE_5;
    self.centerRightLb.font = FONT_SIZE(12);
    self.centerRightLb.textAlignment = NSTextAlignmentRight;
    
    
}

- (void)updateCellFrame
{
    // 无热点提醒 paddingH = 12 有热点提醒 paddingH = 20
    CGFloat paddingH = SPA_STYLE_2;
    
    if (self.cellModel.topLeftLbTitle.length) {
        self.topLeftLb.hidden = NO;
        paddingH = SPA_STYLE_7;
    } else {
        self.topLeftLb.hidden = YES;
    }
    
    WeakSelf(self);
    [self.topLeftImg mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(SPA_STYLE_2);
        make.top.mas_equalTo(paddingH);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.topLeftLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(weakself.topLeftImg.mas_right);
        make.centerY.mas_equalTo(weakself.topLeftImg.mas_top);
        make.size.mas_equalTo(CGSizeMake(36, 16));
    }];
    
    [self.centerRightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(16);
        
        make.right.mas_equalTo(weakself.contentView.mas_right).offset(-12);
        make.centerY.mas_equalTo(weakself.contentView.mas_centerY);
        
    }];
    
    [self.topCenterLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakself.topLeftImg.mas_right).offset(12);
        make.right.mas_equalTo(weakself.centerRightLb.mas_left).offset(-12);
        make.top.mas_equalTo(paddingH + 8);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.centerLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakself.topCenterLb.mas_left);
        make.top.mas_equalTo(weakself.topCenterLb.mas_bottom).offset(8);
        make.right.mas_equalTo(weakself.centerRightLb.mas_left).offset(-12);
        make.height.mas_equalTo(20);
    }];
    
    // 时间宽度不够时，不能压缩
    [self.centerRightLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}


@end
