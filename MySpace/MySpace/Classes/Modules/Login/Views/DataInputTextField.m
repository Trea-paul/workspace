//
//  DataInputTextField.m
//  CYSDemo
//
//  Created by Paul on 2017/5/12.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "DataInputTextField.h"
#import "JYPickerView.h"

@interface DataInputTextField ()<UITextFieldDelegate,JYPickerViewDelegate>

@property (nonatomic, strong) NSNumber *canBecomeEditing;

@property (nonatomic, strong) JYPickerView *pickerView;

@property (nonatomic, copy) NSString *style;

@property (nonatomic, copy) NSString *genderValue;

@end

@implementation DataInputTextField

- (instancetype)initDataInputTextFieldWithImageName:(NSString *)imageName placeHolder:(NSString *)placeHolder
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initDataInputTextFieldInView:(UIView *)view style:(NSString *)style mode:(DataInputTFViewMode)viewMode WithBlock:(void(^)(DataInputTextField *textField))block
{
    self = [super init];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.borderStyle = UITextBorderStyleNone;
        self.backgroundColor = [UIColor clearColor];
//        self.returnKeyType = UIReturnKeyDone;
        
        if ([style isEqualToString:@"Border"]) {
            self.layer.cornerRadius = 22.5;
            self.layer.borderColor = COLOR_STYLE_7.CGColor;
            self.layer.borderWidth = 0.5;
        }
//        else
//        {
//            
//        }
        
        self.style = style;
        
        self.delegate = self;
        
        if (block) {
            block(self);
        }
        
        [view addSubview:self];
        
        
        [self setupSubViewWithMode:viewMode];
        
        
        
        
        
    }
    
    return self;
}

- (void)setupSubViewWithMode:(DataInputTFViewMode)viewMode
{
    switch (viewMode) {
        case DataInputTFViewModeNormal:
            
            [self setupViewModeNormal];
            
            break;
        case DataInputTFViewModeCountdown:
            
            [self setupViewModeCountDown];
            
            break;
        case DataInputTFViewModeGender:
            
            [self setupViewModeGender];
            
            break;
        case DataInputTFViewModeMark:
            
            [self setupViewModeMark];
            
            break;
        case DataInputTFViewModeSelect:
            
            [self setupViewModeSelect];
            
            break;
            
        default:
            [self setupViewModeNormal];
            break;
    }
    
    
    
}

- (void)setupViewModeNormal
{
    
    
    
}

- (void)setupViewModeCountDown
{
    self.countdownBtn.enabled = YES;
    self.isCounting = @NO;
    [self.countdownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        
    }];
}


- (void)setupViewModeGender
{
    
}

- (void)setupViewModeMark
{
    
}

// 选择
- (void)setupViewModeSelect
{
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.text = self.title;

    [self addSubview:titleLb];
    
    self.text = self.title;
    
    self.canBecomeEditing = @NO;
//    self.enabled = NO;
    
//    UILabel *valueLabel = [[UILabel alloc] init];
//    valueLabel.text = self.title;
//    [self addSubview:valueLabel];
    
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 40));
        
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        
    }];
    
    [self.selectBtn buttonLayoutStyle:JYButtonLayoutStyleRight imageTitleSpace:10];

    
}



- (UIButton *)countdownBtn
{
    if (!_countdownBtn) {
        _countdownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _countdownBtn.titleLabel.font = FONT_SIZE(15);
        _countdownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_countdownBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [_countdownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countdownBtn setTitleColor:COLOR_STYLE_2 forState:UIControlStateNormal];
        [_countdownBtn setTitleColor:COLOR_STYLE_4 forState:UIControlStateDisabled];
        
        [_countdownBtn addTarget:self action:@selector(countdownClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_countdownBtn];
        
    }
    
    return _countdownBtn;
}


- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _selectBtn.titleLabel.font = FONT_SIZE(15);
        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:COLOR_STYLE_4 forState:UIControlStateNormal];
        [_selectBtn setTitleColor:COLOR_STYLE_6 forState:UIControlStateHighlighted];
        
        [_selectBtn setImage:[UIImage imageNamed:@"cell_more"] forState:UIControlStateNormal];
        
        [_selectBtn addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_selectBtn];
        
    }
    
    return _selectBtn;
}


- (JYPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[JYPickerView alloc] init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}



- (void)countdownClicked:(UIButton *)button
{
    if (self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(dataTextField:didSelectButton:)]) {
        [self.dataDelegate dataTextField:self didSelectButton:button];
    }
    
//    self.countdownBtn.enabled = NO;
//    [self.countdownBtn setTitle:@"60秒后重新获取" forState:UIControlStateDisabled];
//
//    self.isCounting = @YES;
//    
//    // 倒计时结束后判断手机位数是否依然为11位
//    
//    [self startCountdown];
    
}


// 选择
- (void)selectClicked:(UIButton *)selectButton;
{
    if ([self.title isEqualToString:@"性别"])
    {
        [self selectGenderValue];
        
    }
    else if ([self.title isEqualToString:@"年龄"])
    {
        [self.pickerView show];
    }
    
    if (self.dataDelegate && [self.dataDelegate respondsToSelector:@selector(dataTextField:didSelectButton:)]) {
        [self.dataDelegate dataTextField:self didSelectButton:selectButton];
    }
    
}

- (void)selectGenderValue
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.genderValue = @"男";
        [self.selectBtn setTitle:@"男" forState:UIControlStateNormal];
        [self.selectBtn buttonLayoutStyle:JYButtonLayoutStyleRight imageTitleSpace:10];
        self.textFieldValue = @"男";
    }];
    
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.genderValue = @"女";
        [self.selectBtn setTitle:@"女" forState:UIControlStateNormal];
        [self.selectBtn buttonLayoutStyle:JYButtonLayoutStyleRight imageTitleSpace:10];
        self.textFieldValue = @"女";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertView addAction:maleAction];
    [alertView addAction:femaleAction];
    [alertView addAction:cancelAction];
    
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.controller presentViewController:alertView animated:YES completion:nil];
    });
}

- (void)startCountdown
{
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block int timeout = 16;
    
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
    __weak typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互，背景颜色还原，title还原
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            //MRC下需要释放，这里不需要
            //            dispatch_realse(timer);
            
            //button上的相关设置
            //注意: button是属于UI，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.countdownBtn.enabled = YES;
                [weakSelf.countdownBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                
                
            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.countdownBtn.enabled = NO;
                NSString * title = [NSString stringWithFormat:@"%d秒后重新获取",timeout];
                
                [weakSelf.countdownBtn setTitle:title forState:UIControlStateDisabled];
            });
        }
    });
    
    dispatch_resume(timer);

    
    
    
}



- (void)jy_pickerView:(UIPickerView *)pickerView didSelectRowValue:(NSString *)rowValue inComponentValue:(NSString *)componentValue
{
    DLog(@"rowValue%@", rowValue);
    
    [self.selectBtn setTitle:rowValue forState:UIControlStateNormal];
    [self.selectBtn buttonLayoutStyle:JYButtonLayoutStyleRight imageTitleSpace:10];
    
    self.textFieldValue = rowValue;
    
    
    
    
    
}

- (void)drawRect:(CGRect)rect
{
    if ([self.style isEqualToString:@"BottomLine"])
    {
        // 绘制下划线
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [[UIColor redColor] set];//设置下划线颜色 这里是红色 可以自定义
//        
//        CGFloat y = CGRectGetHeight(self.frame);
//        CGContextMoveToPoint(context, 0, y);
//        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), y);
//        
//        //设置线的宽度
//        CGContextSetLineWidth(context, 1);
//        //渲染 显示到self上
//        CGContextStrokePath(context);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, COLOR_STYLE_7.CGColor);
        CGContextFillRect(context, CGRectMake(20, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 40, 1));
        
        
    }
    else
    {
        [super drawRect:rect];
    }
}




//- (CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    CGRect iconRect = [super leftViewRectForBounds:bounds];
//    iconRect.origin.x += 10; //右边偏15
//    return iconRect;
//}

// UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 20, 0);
    
}

// 控制Editing状态文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 20, 0);
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.canBecomeEditing && !self.canBecomeEditing.boolValue) {
        return NO;
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    DLog(@"--%@", textField.text);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFieldValue = textField.text;
    DLog(@"%@",self.textFieldValue);
}





- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
