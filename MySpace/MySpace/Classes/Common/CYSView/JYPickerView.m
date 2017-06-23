//
//  JYPickerView.m
//  CYSDemo
//
//  Created by Paul on 2017/5/16.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYPickerView.h"

@interface JYPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *ageDataArray;

@property (nonatomic, strong) UIView *darkView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, copy) NSString *selectValue;

@end

@implementation JYPickerView

- (instancetype)initPickerViewWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        self.backgroundColor = HexRGB(0x999999);
        
        
        [self setupSubview];
    }
    
    
    return self;
}

+ (instancetype)sharedPickerView
{
    static JYPickerView *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[JYPickerView alloc] init];
    });
    return helper;
    
}

- (void)setupSubview
{
    [self darkView];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = HexRGBAlpha(0xFFFAFA,0.5);
    self.backView.frame = CGRectMake(0, CGRectGetHeight(self.darkView.frame) - 250, SCREEN_WIDTH, 250);
    
    [self.darkView addSubview:self.backView];
    
    
    // 取消 确定工具条
    [self setupToolBar];
    
    self.selectValue = @"";
    [self pickerView];
    
    
    if (self.currentValue.length) {
        NSUInteger index = [self.ageDataArray indexOfObject:self.currentValue];
        [self.pickerView selectRow:index inComponent:0 animated:NO];
        self.selectValue = self.currentValue;
    }
    else
    {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        self.selectValue = self.ageDataArray[0];
    }
    
}

- (void)setupToolBar
{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.tag = 101;
    [cancelBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:HexRGB(0xFD9627) forState:UIControlStateNormal];
    confirmBtn.backgroundColor = [UIColor whiteColor];
    confirmBtn.tag = 102;
    [confirmBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:confirmBtn];
    
    WeakSelf(self);
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakself.backView.mas_bottom);
        make.left.mas_equalTo(weakself.backView.mas_left);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2 - 0.5, 45));
    }];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakself.backView.mas_bottom);
        make.right.mas_equalTo(weakself.backView.mas_right);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2 - 0.5, 45));
    }];
    
}


- (void)buttonClicked:(UIButton *)button
{
    if (button.tag == 101)
    {
        // 取消
        
        
    }
    else if (button.tag == 102)
    {
        // 确定
        if (self.delegate && [self.delegate respondsToSelector:@selector(jy_pickerView:didSelectRowValue:inComponentValue:)]) {

            [self.delegate jy_pickerView:self.pickerView didSelectRowValue:self.selectValue inComponentValue:nil];
        }
        
    }
    
    [self removePickView];
}

- (void)show
{
    [self setupSubview];
}

- (void)hide
{
    
}

- (void)removePickView
{
    [_pickerView removeFromSuperview];
    [_backView removeFromSuperview];
    [_darkView removeFromSuperview];
    
    [self setPickerView:nil];
    [self setBackView:nil];
    [self setDarkView:nil];
}



- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 204)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        _pickerView.backgroundColor = [UIColor whiteColor];
       
        _pickerView.showsSelectionIndicator = YES;
        
        
        [self.backView addSubview:_pickerView];
    }
    
    
    return _pickerView;
}

- (UIView *)darkView
{
    if (!_darkView) {
        _darkView = [[UIView alloc] init];
        
        UIView *view = [[UIApplication sharedApplication].windows lastObject];
        _darkView.bounds = view.bounds;
        [view addSubview:_darkView];
        _darkView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];;
        _darkView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickView)];
        [_darkView addGestureRecognizer:recognizer];
    }
    return _darkView;
}

// 年龄数据源
- (NSMutableArray *)ageDataArray
{
    if (!_ageDataArray) {
        _ageDataArray = [NSMutableArray array];
        for (NSInteger i = 1; i <= 150; i++) {
            [_ageDataArray addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        
    }
    return _ageDataArray;
}


#pragma mark - DataSource Delegate

//设置分组数

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 设置各分组的行数

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.ageDataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.ageDataArray[row];
}



#pragma mark - Delgate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectValue = _ageDataArray[row];
    
}

//// 设置分组的宽
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    
//}
//
//设置单元格的高

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}



@end
