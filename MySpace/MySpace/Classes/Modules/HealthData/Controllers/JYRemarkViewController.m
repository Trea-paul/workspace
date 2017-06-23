//
//  JYRemarkViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/6/19.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYRemarkViewController.h"

@interface JYRemarkViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, strong) UILabel *todayMood;
@property (nonatomic, strong) UIView *moodView;
@property (nonatomic, strong) NSArray *moodArray;

@property (nonatomic, strong) UIButton *lastSelectButton;
@property (nonatomic, strong) UIImageView *selectedMark;

@property (nonatomic, copy) NSString *selectMoodName;

@end

@implementation JYRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备注";
    
    [self setupUI];
}

- (void)setupUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_STYLE_2} forState:UIControlStateNormal];
    
    if (self.cellModel.value.length) {
        self.textView.text = self.cellModel.value;
    }
    
    
    if (self.cellModel.displayValue.length) {
        
        NSString *dispalyValue = self.cellModel.displayValue;
        if ([dispalyValue hasPrefix:@"MOODIMAGE"]) {
            dispalyValue = [dispalyValue substringFromIndex:9];
            
            NSString *moodName = [[dispalyValue componentsSeparatedByString:@":"] firstObject];
            
            if (moodName.length) {
                self.selectMoodName = moodName;
            }
            
        }
        
        
        
    }
    
    [self setupSubviews];
    
}

- (void)setupSubviews
{
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20 + 64);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(180);
        
    }];
    
    [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(20 + 64);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(17);
    }];
    
    WeakSelf(self);
    [self.todayMood mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(weakself.placeHolder.mas_bottom).offset(170);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    
    
    [self.moodView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(weakself.todayMood.mas_bottom);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(200);
    }];
    
    
    [self setupMoodView];
    
    [[self.textView rac_textSignal] subscribeNext:^(NSString * _Nullable text) {
       
        if (text.length) {
            weakself.placeHolder.hidden = YES;
        } else {
            weakself.placeHolder.hidden = NO;
        }
        
    }];
    
    
}

- (void)setupMoodView
{
    // 创建一个空view 代表上一个view
    __block UIButton *lastButton = nil;
    int margin = 15;
    int num = 3;

    for (int i = 0; i < self.moodArray.count; i++) {
        
        UIButton *button = [self setupButtonWithTitle:self.moodArray[i]];
        button.tag = 100 + i;
        
        [self.moodView addSubview:button];
        
        if ([self.selectMoodName isEqualToString:self.moodArray[i]]) {
            [self moodButtonClick:button];
        }
        
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(45);
            
            if (lastButton) {

                make.width.equalTo(lastButton);
            } else {
                // 避免最后一列约束冲突
                if (i % num != 0) {
                    make.width.mas_equalTo((button.superview.frame.size.width - (num + 1) * margin) / 4);
                }
            }
            
            // 第一列 添加左侧与父视图左侧约束 不是第一列时 添加左侧与上个view左侧约束
            if (i % num == 0) {
                make.left.mas_equalTo(button.superview);
            } else {
                make.left.mas_equalTo(lastButton.mas_right).offset(margin);
            }
            // 判断是否是最后一列 给最后一列添加与父视图右边约束
            if (i % num == (num - 1)) {
                make.right.mas_equalTo(button.superview);
            }
            
            //  // 第一行添加顶部约束
            if (i / num == 0) {
                
                make.top.mas_equalTo(button.superview).offset(margin);
            } else {
                
                make.top.mas_equalTo(( i / num ) * (45 + margin) + margin);
            }
            
        }];
        
        [button buttonLayoutStyle:JYButtonLayoutStyleLeft imageTitleSpace:8];
        
        lastButton = button;
        
    }
}

- (UIButton *)setupButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_STYLE_14 forState:UIControlStateNormal];
    [button setTitleColor:COLOR_STYLE_2 forState:UIControlStateHighlighted];
    [button setTitleColor:COLOR_STYLE_2 forState:UIControlStateSelected];
    button.titleLabel.font = FONT_SIZE(15);
    
    [button setImage:ImageNamed(title) forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    
    [button addTarget:self action:@selector(moodButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    JYViewBorder(button, 0, 1, COLOR_STYLE_7);
    return button;
}


#pragma mark - Lazy Load
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = FONT_SIZE(15);
        _textView.textColor = COLOR_STYLE_5;
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeHolder
{
    if (!_placeHolder) {
        _placeHolder = [[UILabel alloc] init];
        _placeHolder.font = FONT_SIZE(15);
        _placeHolder.textColor = COLOR_STYLE_5;
        _placeHolder.text = @"记录今天的心情、天气、用药情况等信息";
        [self.view addSubview:_placeHolder];
    }
    return _placeHolder;
}

- (UILabel *)todayMood
{
    if (!_todayMood) {
        _todayMood = [[UILabel alloc] init];
        _todayMood.font = FONT_SIZE(16);
        _todayMood.textColor = COLOR_STYLE_6;
        _todayMood.text = @"今日心情";
        [self.view addSubview:_todayMood];
    }
    return _todayMood;
}

- (UIView *)moodView
{
    if (!_moodView) {
        _moodView = [[UIView alloc] init];
        [self.view addSubview:_moodView];
    }
    return _moodView;
}

- (UIImageView *)selectedMark
{
    if (!_selectedMark) {
        _selectedMark = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_cho")];
        _selectedMark.bounds = CGRectMake(0, 0, 16, 16);
    }
    return _selectedMark;
}

- (NSArray *)moodArray
{
    if (!_moodArray) {
        _moodArray = @[@"平静", @"愉悦", @"兴奋", @"低落", @"焦虑", @"忧伤", @"愤怒", @"懊恼"];
    }
    return _moodArray;
}



- (void)saveButtonClick
{
    NSString *moodImageName = @"";
    if (self.lastSelectButton && self.lastSelectButton.selected) {
        
        moodImageName = self.lastSelectButton.titleLabel.text;
    }
    self.cellModel.displayValue = [NSString stringWithFormat:@"MOODIMAGE%@:%@",moodImageName, self.textView.text];
    self.cellModel.value = self.textView.text;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)moodButtonClick:(UIButton *)button
{
    if (self.lastSelectButton.selected) {
        
        self.lastSelectButton.selected = NO;
        [self.selectedMark removeFromSuperview];
        JYViewBorder(self.lastSelectButton, 0, 1, COLOR_STYLE_7);
        
        if (self.lastSelectButton.tag == button.tag) return;
    }
    

    
    button.selected = YES;
    [button addSubview:self.selectedMark];
    self.selectedMark.frame = CGRectMake(0, 0, 16, 16);
    
    JYViewBorder(button, 0, 1, COLOR_STYLE_2);
    self.lastSelectButton = button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
