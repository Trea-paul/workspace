//
//  EditUserInfoTableListCell.m
//  CYSDemo
//
//  Created by Paul on 2017/6/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "EditUserInfoTableListCell.h"
#import "UIImageView+WebCache.h"
#import "VIPServiceListView.h"

@interface EditUserInfoTableListCell ()

@property (nonatomic, strong) VIPServiceListView *serviceImageView;

@end

@implementation EditUserInfoTableListCell

+ (CGFloat)cellHeightForCellModel:(JYTableViewCellModel *)cellModel
{
    return 245;
}

- (UIImageView *)serviceImageView
{
    if (!_serviceImageView) {
        _serviceImageView = [[VIPServiceListView alloc] init];
        [self.contentView addSubview:_serviceImageView];
    }
    return _serviceImageView;
}


- (void)setup
{
    self.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
    
    // 昵称
    self.topLeftLb.font = FONT_SIZE(20);
    self.topLeftLb.textColor = COLOR_STYLE_6;
    
    // 欢迎
    self.centerLeftLb.font = FONT_SIZE(15);
    self.centerLeftLb.textColor = COLOR_STYLE_10;
    
    // 编辑按钮
    [self.bottomLeftBtn setTitleColor:COLOR_STYLE_2 forState:UIControlStateNormal];
//    [self.bottomLeftBtn setTitleColor:COLOR_STYLE_12 forState:UIControlStateHighlighted];
    [self.bottomLeftBtn setBackgroundImage:[InterfaceUtils createImageWithColor:COLOR_STYLE_12] forState:UIControlStateHighlighted];
    
    self.bottomLeftBtn.titleLabel.font = FONT_SIZE(12);
    self.bottomLeftBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    self.bottomLeftBtn.tag = 101;
    
    JYViewBorder(self.bottomLeftBtn, 11, 1, COLOR_STYLE_2);
    
    
     // 一键登录按钮
    [self.centerBtn setTitleColor:COLOR_STYLE_2 forState:UIControlStateNormal];
    [self.centerBtn setBackgroundImage:[InterfaceUtils createImageWithColor:COLOR_STYLE_12] forState:UIControlStateHighlighted];
    
    self.centerBtn.titleLabel.font = FONT_SIZE(20);
    self.centerBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    self.centerBtn.tag = 102;
    
    JYViewBorder(self.centerBtn, 20, 1, COLOR_STYLE_2);
    
    // 头像
    WeakSelf(self);
    [RACObserve(self, cellModel.topRightLbTitle) subscribeNext:^(NSString *topRightLbTitle) {
        if (topRightLbTitle.length) {
            [weakself.topRightImg sd_setImageWithURL:[NSURL URLWithString:topRightLbTitle] placeholderImage:ImageNamed(@"icon_Login_head")];
        } else {
            weakself.topRightImg.image = ImageNamed(@"icon_Login_head");
        }
    }];
    
    JYViewBorder(self.topRightImg, 45, 1, COLOR_STYLE_2);
    
    // 私人医生服务
    self.serviceImageView.image = ImageNamed(@"bg_index_member");
    self.serviceImageView.serviceTitle = @"私人医生服务";
    self.serviceImageView.remain = self.cellModel.bottomLeftLbTitle;
    self.serviceImageView.showRenew = @YES;
    
    self.serviceImageView.renewBtn.tag = 103;
    [self.serviceImageView.renewBtn addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 判断登录状态
    [RACObserve(self, cellModel.centerRightLbTitle) subscribeNext:^(NSString *centerRightLbTitle) {
        
        if (!centerRightLbTitle) {
            return ;
        }
        
        weakself.serviceImageView.remain = weakself.cellModel.bottomLeftLbTitle;
        
        if ([centerRightLbTitle isEqualToString:@"true"]) {
            
            // 已登录
            weakself.topLeftLb.hidden = NO;
            weakself.centerLeftLb.hidden = NO;
            weakself.bottomLeftBtn.hidden = NO;
            weakself.topRightImg.hidden = NO;
            weakself.centerBtn.hidden = YES;
            
            [weakself.serviceImageView updateDataViewWithIsLogin:YES];
            
        }
        else
        {
            // 未登录
            weakself.topLeftLb.hidden = YES;
            weakself.centerLeftLb.hidden = YES;
            weakself.bottomLeftBtn.hidden = YES;
            weakself.topRightImg.hidden = YES;
            weakself.centerBtn.hidden = NO;
            
            [weakself.serviceImageView updateDataViewWithIsLogin:NO];
            
        }
        
    }];
    
    
    
    
    
    
    
}

- (void)updateCellFrame
{
    
    WeakSelf(self);
    
    [self.topLeftLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(SPA_STYLE_2);
        make.top.mas_equalTo(28);
        make.height.mas_equalTo(20);
    }];
    
    [self.centerLeftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakself.topLeftLb);
        make.top.mas_equalTo(weakself.topLeftLb.mas_bottom).offset(SPA_STYLE_2);
        make.height.mas_equalTo(15);
    }];
    
    [self.bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakself.topLeftLb);
        make.top.mas_equalTo(weakself.centerLeftLb.mas_bottom).offset(SPA_STYLE_2);
        
        CGSize titleSize = [weakself.bottomLeftBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: weakself.bottomLeftBtn.titleLabel.font}];
        make.size.mas_equalTo(CGSizeMake(titleSize.width + 20, 25));
    }];
    
    [self.topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-SPA_STYLE_2);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(115);
    }];
    
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(weakself);
        make.centerY.mas_equalTo(weakself.mas_top).offset(65);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    
    
    
}





@end
