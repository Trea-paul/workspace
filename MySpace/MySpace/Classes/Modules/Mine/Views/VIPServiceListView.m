//
//  VIPServiceListView.m
//  CYSDemo
//
//  Created by Paul on 2017/6/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "VIPServiceListView.h"

@interface VIPServiceListView ()

@property (nonatomic, strong) UILabel *titleLb;    // 标题


@end

@implementation VIPServiceListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIButton *)renewBtn
{
    if (!_renewBtn) {
        _renewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_renewBtn setTitle:@"续费" forState:UIControlStateNormal];
        [_renewBtn setTitleColor:COLOR_STYLE_2 forState:UIControlStateNormal];
        [_renewBtn setBackgroundImage:[InterfaceUtils createImageWithColor:COLOR_STYLE_12] forState:UIControlStateHighlighted];
        _renewBtn.titleLabel.font = FONT_SIZE(12);
        _renewBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        
        JYViewBorder(_renewBtn, 11, 1, COLOR_STYLE_2);
        
        [self addSubview:_renewBtn];
    }
    return _renewBtn;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = FONT_SIZE(18);
        _titleLb.textColor = COLOR_STYLE_6;
        [self addSubview:_titleLb];
    }
    return _titleLb;
}

- (UILabel *)remainLb
{
    if (!_remainLb) {
        _remainLb = [[UILabel alloc] init];
        _remainLb.font = FONT_SIZE(15);
        _remainLb.textColor = COLOR_STYLE_2;
        [self addSubview:_remainLb];
    }
    return _remainLb;
}

- (void)updateDataViewWithIsLogin:(BOOL)isLogin;
{
    self.titleLb.text = self.serviceTitle;
    self.remainLb.text = self.remain;
    
    if (isLogin) {
        
        if (self.showRenew && self.showRenew.boolValue) {
            self.renewBtn.hidden = NO;
        } else {
            self.renewBtn.hidden = YES;
        }
        
        self.titleLb.hidden = NO;
        self.remainLb.hidden = NO;
        
        [self layoutIfNeeded];
    } else {
        self.renewBtn.hidden = YES;
        self.titleLb.hidden = YES;
        self.remainLb.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WeakSelf(self);
    [self.renewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        CGSize titleSize = [weakself.renewBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: weakself.renewBtn.titleLabel.font}];
        make.size.mas_equalTo(CGSizeMake(titleSize.width + 20, 25));
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(122);
        make.top.mas_equalTo(32);
        make.height.mas_equalTo(18);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.remainLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(weakself.titleLb.mas_left);
        make.top.mas_equalTo(weakself.titleLb.mas_bottom).offset(8);
        make.height.mas_equalTo(15);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    
}

@end
