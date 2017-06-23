//
//  DateTimePickerView.m
//  CYSDemo
//
//  Created by Paul on 2017/6/21.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "DateTimePickerView.h"

@interface DateTimePickerView ()

@property (nonatomic, readwrite) UIView *accessoryView;
@property (nonatomic, strong) CAShapeLayer *pointerLayer;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation DateTimePickerView

+ (instancetype)sharedDateTimePickerView
{
    static DateTimePickerView *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DateTimePickerView alloc] init];
    });
    return helper;
    
}

- (void)setup
{
    AppDelegate *delegate = kAppDelegate;
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.maskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
    [delegate.window addSubview:self.maskView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMaskView:)];
    [self.maskView addGestureRecognizer:tap];
    
    self.frame = CGRectMake(0, SCREENH_HEIGHT - 250, SCREEN_WIDTH, 250);
    self.backgroundColor = COLOR_STYLE_1;
    [self.maskView addSubview:self];
    
    [self setupSubview];
    
    [self drawSeparateLine];
}

- (void)setupSubview
{
    self.datePicker.datePickerMode = self.datePickerMode;
    
    if (self.cellModel.value.length) {
        
        NSDate *date = [[NSDate alloc] init];
        
        NSString *dateString = self.cellModel.value;
        
        if (self.datePicker.datePickerMode == UIDatePickerModeTime)
        {
            date = [DateUtils dateForDateString:dateString withFormatterString:DATE_STYLE_HHmm];
        }
        else if (self.datePicker.datePickerMode == UIDatePickerModeDate)
        {
            date = [DateUtils dateForDateString:dateString withFormatterString:DATE_STYLE_yyyyMMdd];
        }
        else
        {
            date = [DateUtils dateForDateString:dateString withFormatterString:DATE_STYLE_yyyyMMddHHmm];
        }
        
        if (date) {
            [self.datePicker setDate:date animated:YES];
        }
    }
    
    
    self.titleLabel.text = self.pickerTitle;
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:COLOR_STYLE_6 forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = FONT_SIZE(16);
    [self addSubview:self.cancelButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:COLOR_STYLE_2 forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = FONT_SIZE(16);
    [self addSubview:self.confirmButton];
    
    
    WeakSelf(self);
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [weakself dismiss];
    }];
    
    [[self.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        weakself.cellModel.value = [DateUtils dateStringForDate:weakself.currentDate withFormatterString:DATE_STYLE_yyyyMMddHHmm];
        weakself.cellModel.displayValue = [DateUtils dateStringForDate:weakself.currentDate withFormatterString:DATE_STYLE_yyyyMMddHHmm_cn];
        [weakself dismiss];
    }];
    
    
}

- (void)drawSeparateLine
{
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = COLOR_STYLE_7.CGColor;
    shapeLayerLine.fillColor = COLOR_STYLE_7.CGColor;
    shapeLayerLine.lineWidth = 0.5f;
    shapeLayerLine.lineCap = kCALineCapSquare;

    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGPathMoveToPoint(pathLine, NULL, 0, 40);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width, 40);
    
    CGPathMoveToPoint(pathLine, NULL, 0, 210);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width, 210);
    
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, 210);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height);

    shapeLayerLine.path = pathLine;
    [self.layer addSublayer:shapeLayerLine];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT_SIZE(14);
        _titleLabel.textColor = COLOR_STYLE_6;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [_datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePicker];
    }
    return _datePicker;
}

- (void)show
{
    WeakSelf(self);
    
    [self setup];
    
    // 更新尺寸
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.titleLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(170);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 40));
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 40));
    }];
    
    
    
}

- (void)changeDate:(UIDatePicker *)changeDate
{
    self.currentDate = [changeDate date];
}

- (void)didClickMaskView:(UIGestureRecognizer *)recognizer
{
    [self dismiss];
}

- (void)dismiss
{
    [self.maskView removeFromSuperview];
    [self setMaskView:nil];
}

@end
