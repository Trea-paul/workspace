//
//  JYNewsTableHeaderView.m
//  CYSDemo
//
//  Created by Paul on 2017/5/8.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYNewsTableHeaderView.h"
#import "JYSubTitleScrollView.h"

@interface JYNewsTableHeaderView ()<JYSJYSubTitleScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, copy) NSString *detailTitle;

@property (nonatomic, strong) UILabel *leftLabel;     // 健康咨讯
@property (nonatomic, strong) UIButton *moreButton;  // 更多

@property (nonatomic, strong) JYSubTitleScrollView *titleView;
@property (nonatomic, copy) NSString *lastClickTitle;  // 记录上一次点击

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JYNewsTableHeaderView

- (instancetype)initWithTitle:(NSString *)title reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = COLOR_STYLE_1;
        self.titleArray = @[title];
        self.leftLabel.hidden = YES;
        self.titleView.hidden = NO;
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = COLOR_STYLE_7;
        [self addSubview:self.lineView];
        
        UIImageView *indexPoint = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_index_point")];
        indexPoint.frame = CGRectMake(0, 0, 12, 12);
        [self addSubview:indexPoint];
    }
    
    
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = COLOR_STYLE_1;
        self.titleArray = titleArray;
        self.leftLabel.hidden = YES;
        self.titleView.hidden = NO;
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = COLOR_STYLE_7;
        [self addSubview:self.lineView];
        
        UIImageView *indexPoint = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_index_point")];
        indexPoint.frame = CGRectMake(0, 0, 12, 12);
        [self addSubview:indexPoint];
    }
    
    
    return self;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"健康资讯";
        _leftLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_leftLabel];
    }
    return _leftLabel;
}

- (JYSubTitleScrollView *)titleView
{
    if (!_titleView) {
        _titleView = [[JYSubTitleScrollView alloc] initWithSubTitles:self.titleArray scrollWidth:250.0f];
        _titleView.clickDelegate = self;
        [self.contentView addSubview:_titleView];
    }
    return _titleView;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"查看全部" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = FONT_SIZE(13);
        [_moreButton setTitleColor:COLOR_STYLE_4 forState:UIControlStateNormal];
        [_moreButton setTitleColor:COLOR_STYLE_10 forState:UIControlStateHighlighted];
        [_moreButton setImage:[UIImage imageNamed:@"cell_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton buttonLayoutStyle:JYButtonLayoutStyleRight imageTitleSpace:10.0f];
        [self.contentView addSubview:_moreButton];
    }
    return _moreButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    WeakSelf(self);
    
    if (self.showMoreButton && self.showMoreButton.boolValue) {
        self.moreButton.hidden = NO;
    } else {
        self.moreButton.hidden = YES;
    }
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
//        make.right.equalTo(weakself.moreButton.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(250, 35));
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakself.mas_bottom);
        make.height.mas_equalTo(1);
        
    }];
    
    
    
}

- (void)didClickMoreButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchUpInsideHeaderViewButton:buttonUrl:)]) {
        [self.delegate didTouchUpInsideHeaderViewButton:button buttonUrl:self.moreButtonUrl];
    }
}

- (void)didTouchUpInsideSubTitle:(NSString *)title categoryId:(NSString *)categoryId
{
    DLog(@"--->> %@",title);
    
    if ([self.lastClickTitle isEqualToString:title]) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchUpScrollViewSubTitle:titleId:)]) {
        
        self.lastClickTitle = title;
        [self.delegate didTouchUpScrollViewSubTitle:title titleId:categoryId];
    }
    
}


@end
