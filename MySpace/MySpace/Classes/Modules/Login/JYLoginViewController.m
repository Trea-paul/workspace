//
//  JYLoginViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYLoginViewController.h"
#import "JYEditUserViewController.h"
#import "DataInputTextField.h"

@interface JYLoginViewController ()<DataInputTextFieldDelegate>


@property (nonatomic, strong) DataInputTextField *phoneNum;
@property (nonatomic, strong) DataInputTextField *verifyCode;

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation JYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"手机快速登录";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
    
    
    
    [self setupUI];
    
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)leftBarButtonItemClick:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setupUI
{
    WeakSelf(self);
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Login_logo"]];
    [self.view addSubview:logoView];
    
    self.phoneNum = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"Border" mode:DataInputTFViewModeNormal WithBlock:^(DataInputTextField *textField) {
        
        textField.returnKeyType = UIReturnKeyContinue;
        textField.placeholder = @"请输入手机号码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        textField.tag = 100;
        
    }];
    
    self.phoneNum.text = @"13560435818";
    
    self.verifyCode = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"Border" mode:DataInputTFViewModeCountdown WithBlock:^(DataInputTextField *textField) {
        
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入验证码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeNever;
        
        textField.tag = 101;
    }];
    
    
    
    
    // *** 设置尺寸约束
    
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(40 + 64);
        make.size.mas_equalTo(CGSizeMake(94, 94));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
    }];
    
    [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(logoView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    
    [self.verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.phoneNum.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];

    self.verifyCode.dataDelegate = self;
    self.loginBtn.enabled = YES;
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.verifyCode.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
//        JYEditUserViewController *userVC = [[JYEditUserViewController alloc] init];
//        userVC.isNewUser = @NO;
//        [weakself.navigationController pushViewController:userVC animated:YES];
        
        
    }];
    
    
    [self setupRAC];
    
}

- (UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateDisabled];
        [_loginBtn setBackgroundImage:[InterfaceUtils createImageWithColor:HexRGB(0xFD9627)]forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[InterfaceUtils createImageWithColor:HexRGB(0xFEDFBE)]forState:UIControlStateDisabled];
        
        _loginBtn.layer.cornerRadius = 22.5;
        _loginBtn.clipsToBounds = YES;
        
        [_loginBtn addTarget:self action:@selector(didClickedLoginButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_loginBtn];
        
    }
    
    return _loginBtn;
}

- (void)setupRAC
{
    WeakSelf(self);
    
    // 手机号限制输入11位
    [[self.phoneNum rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof DataInputTextField *textField) {
        
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        
//        if (textField.text.length == 11) {
//            if (!weakself.verifyCode.isCounting.boolValue) {
//                weakself.verifyCode.countdownBtn.enabled = YES;
//            }
//        }
//        else
//        {
//            weakself.verifyCode.countdownBtn.enabled = NO;
//        }
        
        [weakself updateLoginBtnStatus];
        
    }];
    
    // 验证码最多输入6位
    [[self.verifyCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof DataInputTextField *textField) {
        
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
        
        [weakself updateLoginBtnStatus];
        
    }];
    
    
}


- (void)updateLoginBtnStatus
{
    if (self.phoneNum.text.length == 11 && self.verifyCode.text.length == 4 )
    {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
    
    
    
    
}

#pragma mark - ***** Do Login *************

// 点击登录
- (void)didClickedLoginButton
{
    // 再次判断手机号合法性
    BOOL phoneValid = [self isValidPhoneNum:self.phoneNum.text];
    if (phoneValid) {
        
        WeakSelf(self);
        [HttpRequestManager GET:@"hmapi/protected/patient/login" parameters:@{@"msisdn" : self.phoneNum.text , @"code" : self.verifyCode.text} success:^(id responseObject, BOOL success) {
            
            if (success) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                
                if (result) {
                    
                    NSUserDefaults *userDefault = kUserDefault;
                    [userDefault setValue:@"true" forKey:@"isLogin"];
                    [userDefault setValue:[result valueForKey:@"token"] forKey:@"token"];
                    [userDefault synchronize];
                    
                    // 是否为新用户
                    if ([[result valueForKey:@"is_new"] integerValue] == 0) {
                        
                        // 发送通知，重新请求个人资料
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"requestDataMine" object:nil];
                        
//                        if (weakself.delegateSignal) {
//                            [weakself.delegateSignal sendNext:@"refresh"];
//                        }
                        [weakself dismissViewControllerAnimated:YES completion:nil];
                        
                        
                    } else {
                        
                        JYEditUserViewController *userVC = [[JYEditUserViewController alloc] init];
                        userVC.isNewUser = @YES;
                        [weakself.navigationController pushViewController:userVC animated:YES];
                    }
                    
                    
                }
            }
            else
            {
                [[HUDHepler sharedHelper] showMessage:@"验证码错误，请重新输入"];
                
            }
            
            
        } failure:^(NSError *error) {
            
            
        }];
        
        
        
        
        
    }
    else
    {
        [[HUDHepler sharedHelper] showMessage:@"请输入正确的手机号"];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self viewResignFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self viewResignFirstResponder];
}

- (void)viewResignFirstResponder
{
    [self.phoneNum resignFirstResponder];
    [self.verifyCode resignFirstResponder];
}


- (BOOL)isValidPhoneNum:(NSString *)phoneNum
{
    // 正则检查手机号的合法性
    
    BOOL isValid = [StringUtils isValidMobilePhoneNum:phoneNum];
    
    return isValid;
    
}



/**
 获取验证码
 */
- (void)dataTextField:(DataInputTextField *)textField didSelectButton:(UIButton *)button
{
    
    // 判断手机号
    BOOL isValid = [StringUtils isValidMobilePhoneNum:self.phoneNum.text];
    
    if (isValid)
    {
        WeakSelf(self);
        
        
        [HttpRequestManager GET:@"hmapi/protected/msisdn/code" parameters:@{@"msisdn" : self.phoneNum.text} success:^(id responseObject, BOOL success) {
            
            if (success) {
                
                [[HUDHepler sharedHelper] showMessage:@"验证码已发送，请留意手机信息"];
                
            }
            
            
        } failure:^(NSError *error) {
            
            DLog(@"%@", error);
            
        }];
        
        
        [InterfaceUtils startCountdownWithTimeout:15 counting:^(NSInteger timeout, BOOL *stop) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakself.verifyCode.countdownBtn.enabled = NO;
                NSString * title = [NSString stringWithFormat:@"%ld秒后重新获取",timeout];
                
                [weakself.verifyCode.countdownBtn setTitle:title forState:UIControlStateDisabled];
                
                
            });
            
        } completion:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakself.phoneNum.text.length == 11) {
                    weakself.verifyCode.countdownBtn.enabled = YES;
                }
                [weakself.verifyCode.countdownBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                [weakself.verifyCode.countdownBtn setTitle:@"重新获取" forState:UIControlStateDisabled];
                
            });
            
        }];
    }
    else
    {
        [[HUDHepler sharedHelper] showMessage:@"请输入正确的手机号"];
    }
    
}

-(void)dealloc
{
    DLog(@"登录完成");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
