//
//  JYHomeNewsTableViewCell.m
//  CYSDemo
//
//  Created by Paul on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYHomeNewsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "HomeModel.h"

@interface JYHomeNewsTableViewCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIView *tagView;

@end

@implementation JYHomeNewsTableViewCell


- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 5;
        _iconView.clipsToBounds = YES;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        _tagView.clipsToBounds = YES;
        [self.contentView addSubview:_tagView];
    }
    return _tagView;
}

- (void)setup
{
    self.iconView.hidden = NO;
    
    self.topCenterLb.textColor = [UIColor blackColor];
    self.topCenterLb.font = [UIFont systemFontOfSize:17];
    self.topCenterLb.numberOfLines = 3;

    // 文章导读 需隐藏 （预留中，请勿使用）
    self.topRightLb.hidden = YES;
    self.topRightLb.textColor = [UIColor grayColor];
    self.topRightLb.font = [UIFont systemFontOfSize:12];
    self.topRightLb.numberOfLines = 3;
    
    
}




- (void)updateCellFrame
{
    CGFloat labelX = SPA_STYLE_2;
    NSString *imageUrl = self.cellModel.topLeftLbTitle;
    
    WeakSelf(self)
    
    if (imageUrl && imageUrl.length) {
        
        labelX = 2 * SPA_STYLE_2 + 92;
        self.iconView.hidden = NO;
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"home_press"] options:SDWebImageRetryFailed];
        
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.contentView.mas_left).offset(SPA_STYLE_2);
            make.size.mas_equalTo(CGSizeMake(92, 80));
            make.centerY.equalTo(weakself.contentView.mas_centerY);
            
        }];
    }
    else
    {
        labelX = SPA_STYLE_2;
        self.iconView.hidden = YES;
    }
    
    [self.topCenterLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labelX);
        make.top.mas_equalTo(SPA_STYLE_5);
        make.right.mas_equalTo(-SPA_STYLE_2);
//        make.centerY.equalTo(weakself.contentView.mas_centerY);
//        make.bottom.mas_equalTo(weakSelf.view).mas_offset(-20);
    }];
    
    
    [self.topRightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.topCenterLb.mas_left);
        make.bottom.mas_equalTo(-SPA_STYLE_5);
        make.right.mas_equalTo(-SPA_STYLE_2);
    }];
    
    [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.topCenterLb.mas_left);
        make.bottom.mas_equalTo(-SPA_STYLE_7);
        make.right.mas_equalTo(-SPA_STYLE_2);
        make.height.mas_equalTo(HEI_STYLE_7);
    }];
    
    if (self.cellModel.centerLeftLbTitle.length) {
        
        self.tagView.hidden = NO;
        [self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSArray *tagArray = [StringUtils separatedString:self.cellModel.centerLeftLbTitle byComponent:@","];
        CGFloat labelX = 0;
        for (int i = 0; i < tagArray.count; i ++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = tagArray[i];
            label.textColor = COLOR_STYLE_2;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FONT_SIZE(12);
            JYViewBorder(label, 2, 1, COLOR_STYLE_2);
            CGSize lableSize = [StringUtils sizeWithString:label.text font:label.font];
            label.frame = CGRectMake(labelX, 0, lableSize.width + 15, 20);
            [self.tagView addSubview:label];
            
            labelX += label.mj_w + SPA_STYLE_2;
        }
        
        
    } else {
        self.tagView.hidden = YES;
    }
    
    

}



// 根据模型计算高度
+ (CGFloat)heightForRowWithModel:(ArticleModel *)model
{
    CGFloat Height = 0;
    CGFloat titleWidth = SCREEN_WIDTH - 2 * SPA_STYLE_2;
    NSString *title = model.title;
    NSString *tag = model.tags;
//    NSString *subTitle = [model objectForKey:@"value"];
    NSString *imageUrl = model.icon;
    
    if (imageUrl.length) {
        titleWidth -= 104;
    }
    
    if (title.length)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        label.font = [UIFont systemFontOfSize:17];
        label.numberOfLines = 3;
        CGSize maxSize = CGSizeMake(titleWidth , 63);
        
        CGSize labelSize = [StringUtils sizeWithString:label.text font:label.font limitSize:maxSize];
        
        Height += labelSize.height + 16;
    }
    
//    if (subTitle.length) {
//        UILabel *label = [[UILabel alloc] init];
//        label.text = subTitle;
//        label.font = [UIFont systemFontOfSize:14];
//        label.numberOfLines = 3;
//        CGSize maxSize = CGSizeMake(titleWidth , 62);
//        
//        CGSize labelSize = [StringUtils sizeWithString:label.text font:label.font limitSize:maxSize];
//        
//        Height += labelSize.height + 20;
//    }
    
    if (tag.length) {
        Height += 18 + 20 + 10;
    }
    
    
    if (imageUrl.length) {
        Height = MAX(Height, 104);
    }
    
    return Height;
}

@end
