//
//  JYSubTitleScrollView.m
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYSubTitleScrollView.h"

@interface JYSubTitleScrollView ()

@property (nonatomic, strong) NSMutableArray *titleButtonArray;
@property (nonatomic, assign) CGFloat scrollWidth;

@property (nonatomic, assign) NSInteger lastClickTag;

@property (nonatomic, strong) UIView *moveLine;

@end

@implementation JYSubTitleScrollView
{
    NSArray *_titleArray;
}

- (instancetype)initWithSubTitles:(NSArray *)subTitle
{
    self = [super init];
    if (self)
    {
        _titleArray = subTitle;
        
        self.scrollWidth = 250;
        
        self.scrollsToTop = NO;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        
        if (_titleArray.count == 1) {
            self.moveLine.hidden = YES;
        } else {
            self.moveLine.hidden = NO;
        }
        
        [self setupSubTitles];

    }
    
    return self;
}

- (instancetype)initWithSubTitles:(NSArray *)subTitle scrollWidth:(CGFloat)width
{
    if (!subTitle) {
        return nil;
    }
    self = [self initWithSubTitles:subTitle];
    
    self.scrollWidth = width;
    
    return self;
}

- (void)setupSubTitles
{
    self.titleButtonArray = [NSMutableArray array];
    // 添加所有的标题
//    CGFloat labelW = _titleWidth;
//    CGFloat labelH = self.titleHeight;
    
    CGFloat btnW = 0;
    CGFloat btnH = 35;

    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (int i = 0; i < _titleArray.count; i++) {
        
        CategoryButton *button;
        // 判断titleArray的元素是字典还是字符串
        if ([_titleArray[i] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = _titleArray[i];
            button = [self setupButtonWithTitle:[dict valueForKey:@"name"] titleId:[dict valueForKey:@"sickCategoryId"]];
            
        } else if ([_titleArray[i] isKindOfClass:[NSString class]]){
            
            button = [self setupButtonWithTitle:_titleArray[i] titleId:nil];
        }
        
        
        button.tag = i;
        
        CGSize titleSize = [button.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, btnH) options:NSStringDrawingUsesLineFragmentOrigin
         attributes:@{NSFontAttributeName:button.titleLabel.font}
         context:nil].size;
        
        btnW = titleSize.width + 10;
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        btnX = btnX + btnW + 5;
        
        if (i == 0) {
            
            button.selected = YES;
            
            self.moveLine.frame = CGRectMake(button.mj_x + button.mj_w / 2, button.mj_h - 3, 20, 3);
            self.moveLine.center = CGPointMake(CGRectGetMidX(button.frame), CGRectGetMidY(self.moveLine.frame));
        }
        
        // 保存到数组
        
        [self addSubview:button];
        
        [self.titleButtonArray addObject:button];
    }
    
    // 设置标题滚动视图的内容范围

    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(self.titleButtonArray.count * (btnW + 5) + 5, 0);
}

- (UIView *)moveLine
{
    if (!_moveLine) {
        _moveLine = [[UIView alloc] init];
        _moveLine.backgroundColor = COLOR_STYLE_2;
        
        _moveLine.bounds = CGRectMake(0, 0, 20, 3);
        _moveLine.layer.cornerRadius = 1.0f;
        
        [self addSubview:_moveLine];
    }
    return _moveLine;
}

- (CategoryButton *)setupButtonWithTitle:(NSString *)title titleId:(NSString *)titleId
{
    CategoryButton *button = [CategoryButton buttonWithType:UIButtonTypeCustom];
    
    button.value = title;
    button.categoryId = titleId;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:COLOR_STYLE_13 forState:UIControlStateNormal];
    [button setTitleColor:COLOR_STYLE_6 forState:UIControlStateSelected];
    
    button.titleLabel.font = FONT_SIZE(16);
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonClick:(CategoryButton *)button
{
    if (button.tag == self.lastClickTag) {
        return;
    }
    self.lastClickTag = button.tag;
    
    button.selected = YES;
    DLog(@"当前点击标题 %@", button.titleLabel.text);
    
    for (UIButton *btn in self.titleButtonArray) {
        
        if (btn.tag != button.tag) {
            btn.selected = NO;
        }
    }
    
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(didTouchUpInsideSubTitle:categoryId:)]) {
        [self.clickDelegate didTouchUpInsideSubTitle:button.value categoryId:button.categoryId];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.moveLine.center = CGPointMake(CGRectGetMidX(button.frame), CGRectGetMidY(self.moveLine.frame));
    }];
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = button.center.x - self.scrollWidth * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.contentSize.width - self.scrollWidth;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}


@end
