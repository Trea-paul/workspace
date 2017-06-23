//
//  RulerTableViewListCell.m
//  CYSDemo
//
//  Created by Paul on 2017/6/19.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "RulerTableViewListCell.h"
#import "RulerView.h"

@interface RulerTableViewListCell ()<RulerViewDelegate>

@property (nonatomic, strong) RulerView *rulerView;

@property (nonatomic, strong) UIView *indicator;

@end

@implementation RulerTableViewListCell

+ (CGFloat)cellHeightForCellModel:(JYTableViewListCellModel *)cellModel
{
    return 150;
    
}


- (void)setup
{
    self.topLeftLb.hidden = NO;
    self.topRightBtn.hidden = NO;
    
    self.centerLb.textColor = COLOR_STYLE_2;
    self.centerLb.font = FONT_SIZE(20);
    self.centerLb.textAlignment = NSTextAlignmentCenter;
    
    [self.topRightBtn setTitleColor:COLOR_STYLE_6 forState:UIControlStateNormal];
    self.topRightBtn.titleLabel.font = FONT_SIZE(14);
    [self.topRightBtn setImage:ImageNamed(@"icon_btn_select_0") forState:UIControlStateNormal];
    [self.topRightBtn setImage:ImageNamed(@"icon_btn_select_1") forState:UIControlStateSelected];
    
    WeakSelf(self);
    [RACObserve(self, cellModel.topRightBtnTitle) subscribeNext:^(NSString *topRightBtnTitle) {
        
        if (topRightBtnTitle.length) {
            weakself.topRightBtn.hidden = NO;
        } else {
            weakself.topRightBtn.hidden = YES;
        }
    }];
    
    [RACObserve(self, cellModel.displayValue) subscribeNext:^(NSString *displayValue) {
        
        if (!displayValue.length) return ;
        
        // 判断刻度尺的显示
        if ([displayValue isEqualToString:@"true"]) {
            self.topRightBtn.selected = YES;
            self.indicator.hidden = NO;
            self.centerLb.hidden = NO;
            self.rulerView.hidden = NO;
        } else {
            
            self.topRightBtn.selected = NO;
            self.indicator.hidden = YES;
            self.centerLb.hidden = YES;
            self.rulerView.hidden = YES;
        }
    }];
    
    [RACObserve(self, cellModel.centerRightLbTitle) subscribeNext:^(NSString *centerRightLbTitle) {
        
        if (centerRightLbTitle.length) {
            
            // array[最大值,最小值,平均值,当前值]
            NSArray *array = [centerRightLbTitle componentsSeparatedByString:@","];
            
            NSAssert(array.count == 4, @"***** 数据格式错误，请按照 @'最大值,最小值,平均值,当前值' 输入\n");
            
            [weakself.rulerView rulerViewWithMaxValue:[array[0] floatValue] minValue:[array[1] floatValue] average:[array[2] floatValue] currentValue:[array[3] floatValue] smallMode:YES];
            
        }
    }];
    
    
}

- (UIView *)rulerView
{
    if (!_rulerView) {
        _rulerView = [[RulerView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 58)];
        _rulerView.backgroundColor = COLOR_STYLE_15;
        JYViewBorder(_rulerView, 4, 1, COLOR_STYLE_7);
        
        _rulerView.rulerDeletate = self;
        
        [self.contentView addSubview:_rulerView];
        
    }
    return _rulerView;
}

- (UIView *)indicator
{
    if (!_indicator)
    {
        _indicator = [[UIView alloc] init];

        _indicator.backgroundColor = COLOR_STYLE_2;
        _indicator.layer.cornerRadius = 1.5f;
        
        [self.contentView addSubview:_indicator];
        
        [self.contentView bringSubviewToFront:_indicator];
    }
    return _indicator;
}

- (void)updateCellFrame
{
    WeakSelf(self);
    
    [self.topLeftLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    
    [self.centerLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(weakself.mas_centerX);
        make.top.mas_equalTo(40);
    }];
    
    
    
    
    [self.topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.topRightBtn buttonLayoutStyle:JYButtonLayoutStyleRight imageTitleSpace:8];
    
    
    [self.rulerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(weakself.topLeftLb.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(58);
    }];
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.topLeftLb.mas_bottom).offset(17);
        make.centerX.mas_equalTo(weakself.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(3, 66));
    }];
    
}

- (void)rulerView:(CGFloat)rulerViewValue
{
    self.centerLb.text = [NSString stringWithFormat:@"%.f",rulerViewValue];
    self.cellModel.value = self.centerLb.text;
}



@end
