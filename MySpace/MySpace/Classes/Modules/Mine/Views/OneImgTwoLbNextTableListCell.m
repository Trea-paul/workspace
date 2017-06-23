//
//  OneImgTwoLbNextTableListCell.m
//  CYSDemo
//
//  Created by Paul on 2017/6/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "OneImgTwoLbNextTableListCell.h"

@implementation OneImgTwoLbNextTableListCell

+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel
{
    return 44;
}

- (void)setup
{
    WeakSelf(self);
    // 配图
    [RACObserve(self, cellModel.topLeftLbTitle) subscribeNext:^(NSString *topLeftLbTitle) {
        if (topLeftLbTitle) {
            weakself.topLeftImg.image = ImageNamed(topLeftLbTitle);
        }
    }];
    
    // 标题
    self.centerLeftLb.font = FONT_SIZE(16);
    self.centerLeftLb.textColor = COLOR_STYLE_6;
    
    [self.centerLeftLb setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // 描述
    self.centerLb.font = FONT_SIZE(14);
    self.centerLb.textColor = COLOR_STYLE_4;
    self.centerLb.textAlignment = NSTextAlignmentRight;
    
    [RACObserve(self, cellModel.displayValue) subscribeNext:^(NSString *display) {
        
        // 设置图文混排
        if (display.length) {
            
            if ([display hasPrefix:@"MOODIMAGE"]) {
                
                // value格式 @"MOODIMAGE图片名:备注"
                NSString *valueString = [display substringFromIndex:9];
                NSArray *array = [valueString componentsSeparatedByString:@":"];
                
                NSString *imageName = array[0];
                NSString *remarkStr = array[1];
                
                if (!imageName || [imageName isEqualToString:@""]) {
                    
                    if (!remarkStr.length) {
                        weakself.centerLb.text = weakself.cellModel.centerLbTitle;
                        return;
                    }
                    
                    weakself.centerLb.text = remarkStr;
                    return ;
                }
                
                // 创建一个富文本
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", remarkStr] attributes:@{NSBaselineOffsetAttributeName : @5}];
                
                
                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = ImageNamed(imageName);
                // 设置图片大小
                attch.bounds = CGRectMake(0, 0, 22, 22);
                
                
                // 创建带有图片的富文本
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:imageStr atIndex:0];
                
                
                // 用label的attributedText属性来使用富文本
                self.centerLb.attributedText = attri;
                
                
            } else {
                
                weakself.centerLb.text = display;
            }
            
        } else {
            weakself.centerLb.text = weakself.cellModel.centerLbTitle;
        }
    }];
    
    
    self.topRightImg.image = ImageNamed(@"cell_more");
    
}

- (void)updateCellFrame
{
    WeakSelf(self);
    
    [self.topLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(24);
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.centerY.mas_equalTo(weakself);
    }];
    
    [self.topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-24);
        make.size.mas_equalTo(CGSizeMake(6, 10));
        make.centerY.mas_equalTo(weakself);
    }];
    
    [self.centerLeftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakself.topLeftImg.mas_right).offset(20);
        make.centerY.mas_equalTo(weakself);
        make.height.mas_equalTo(16);
    }];
    
    [self.centerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(weakself.topRightImg.mas_left).offset(-5);
        make.left.mas_equalTo(weakself.centerLeftLb.mas_right).offset(20);
        make.centerY.mas_equalTo(weakself);
        make.height.mas_equalTo(30);
    }];
    
    if (self.cellModel.centerLbTitle.length) {
        NSString *desc = self.cellModel.centerLbTitle;
        self.centerLb.textColor = [desc hasPrefix:@"400-"] ? COLOR_STYLE_2 : COLOR_STYLE_4;
    }
    
    
    
}


@end
