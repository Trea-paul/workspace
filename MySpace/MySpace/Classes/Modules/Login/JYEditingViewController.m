//
//  JYEditingViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/18.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYEditingViewController.h"
#import "DataInputTextField.h"
#import "JYTabBarViewController.h"

#define verifyCodeMax 4

@interface JYEditingViewController ()<UITextFieldDelegate,DataInputTextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextField *fieldTF;

@property (nonatomic, strong) UIView *oldView;

@property (nonatomic, strong) DataInputTextField *phoneNum;
@property (nonatomic, strong) DataInputTextField *verifyCode;

@property (nonatomic, strong) UIButton *finishBtn;

@property (nonatomic, strong) NSString *phoneNumber;

@end

@implementation JYEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    if ([self.viewType isEqualToString:@"FIELD"])
    {
        if (self.cellModel.topLeftLbTitle.length)
        {
            self.title = self.cellModel.topLeftLbTitle;
        }
        else
        {
            self.title = @"编辑";
        }
        
        self.view.backgroundColor = HexRGB(0xF5F5F5);
        
        // 修改姓名 及普通字段
        [self changeFieldValue];
    }
    else
    {
        // 修改手机号
        self.title = @"修改手机号";
        
        self.view.backgroundColor = COLOR_STYLE_1;
        
        [self changePhoneNumber];
    }
}

#pragma mark - Setup UI

- (void)changePhoneNumber
{
    // 新手机号、验证码
    self.phoneNum = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"BottomLine" mode:DataInputTFViewModeNormal WithBlock:^(DataInputTextField *textField) {
        
        textField.returnKeyType = UIReturnKeyContinue;
        textField.placeholder = @"请输入手机号码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        textField.tag = 100;
        
    }];
    
    self.phoneNum.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.phoneNum];
    
    
    self.verifyCode = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"BottomLine" mode:DataInputTFViewModeCountdown WithBlock:^(DataInputTextField *textField) {
        
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入验证码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearButtonMode = UITextFieldViewModeNever;
        
        textField.tag = 101;
    }];
    
    self.verifyCode.dataDelegate = self;
    self.verifyCode.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.verifyCode];
    
    self.finishBtn.enabled = NO;
    
    if (self.isFinished && self.isFinished.boolValue)
    {
        // 显示完成布局
        [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [self.finishBtn setTitle:@"完成" forState:UIControlStateDisabled];
        
        [self.phoneNum becomeFirstResponder];
        
        WeakSelf(self);
        [self.phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(64 + 20);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
            
        }];
        
        
        [self.verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakself.phoneNum.mas_bottom);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        }];
        
        [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakself.verifyCode.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(weakself.view.mas_centerX);
            
        }];
        
        
        // RAC
        
        [[self.phoneNum rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof DataInputTextField *textField) {
            
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
            
            if (textField.text.length == 11) {
                if (!weakself.verifyCode.isCounting.boolValue) {
                    weakself.verifyCode.countdownBtn.enabled = YES;
                }
                
                self.phoneNumber = textField.text;
            }
            else
            {
                weakself.verifyCode.countdownBtn.enabled = NO;
            }
            
            [weakself updateLoginBtnStatus];
            
        }];
        
        // 验证码最多输入4位
        [[self.verifyCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof DataInputTextField *textField) {
            
            if (textField.text.length > verifyCodeMax) {
                textField.text = [textField.text substringToIndex:verifyCodeMax];
            }
            
            [weakself updateLoginBtnStatus];
            
        }];
        
        
    }
    else
    {
        // 显示下一步布局
        [self.finishBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.finishBtn setTitle:@"下一步" forState:UIControlStateDisabled];
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
        self.phoneNumber = self.cellModel.value;
        self.phoneNum.hidden = YES;
        
        [self setupOldPhoneView];
        
        self.verifyCode.countdownBtn.enabled = YES;
        
        WeakSelf(self);
        [self.verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakself.oldView.mas_bottom);
//            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            //        make.size.mas_equalTo(CGSizeMake(327, 45));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
            
        }];
        
        [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(weakself.verifyCode.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(45);
            
        }];
        
        // 验证码最多输入4位
        [[self.verifyCode rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof DataInputTextField *textField) {
            
            if (textField.text.length == verifyCodeMax)
            {
                weakself.finishBtn.enabled = YES;
            }
            else
            {
                weakself.finishBtn.enabled = NO;
            }
            
            if (textField.text.length > verifyCodeMax) {
                textField.text = [textField.text substringToIndex:verifyCodeMax];
            }
            
            
        }];
        
        
    }
    
}

- (void)updateLoginBtnStatus
{
    if (self.phoneNum.text.length == 11 && self.verifyCode.text.length == 4 )
    {
        self.finishBtn.enabled = YES;
    } else {
        self.finishBtn.enabled = NO;
    }
    
}


- (void)changeFieldValue
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // TextField
    self.fieldTF.text = self.cellModel.value;
    
    [self.fieldTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(64 + 20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
        
    }];
    
    [self.fieldTF becomeFirstResponder];
    
}

- (void)setupOldPhoneView
{
    self.oldView = [[UIView alloc] init];
    self.oldView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.oldView];
    
    UILabel *phoneTitle = [[UILabel alloc] init];
    phoneTitle.text = @"旧手机";
    phoneTitle.font = FONT_SIZE(17);
    phoneTitle.textColor = COLOR_STYLE_6;
    phoneTitle.textAlignment = NSTextAlignmentLeft;
    [self.oldView addSubview:phoneTitle];
    
    UILabel *phone = [[UILabel alloc] init];
    phone.text = self.phoneNumber;
    phone.font = FONT_SIZE(15);
    phone.textColor = COLOR_STYLE_6;
    phone.textAlignment = NSTextAlignmentRight;
    [self.oldView addSubview:phone];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = COLOR_STYLE_7;
    [self.oldView addSubview:bottomLine];
    
    WeakSelf(self);
    [self.oldView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(64 + 20);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
    }];
    
    [phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 45));
        
    }];
    
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(280, 45));
        
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(weakself.oldView.mas_bottom);
        make.height.mas_equalTo(1);
        
    }];
    
    
    
}


- (UITextField *)fieldTF
{
    if (!_fieldTF) {
        _fieldTF = [[UITextField alloc] init];
        _fieldTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _fieldTF.leftViewMode = UITextFieldViewModeAlways;
        _fieldTF.returnKeyType = UIReturnKeyDone;
        _fieldTF.delegate = self;
        _fieldTF.backgroundColor = [UIColor whiteColor];
        _fieldTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 45)];
        
        [self.view addSubview:_fieldTF];
        
    }
    
    return _fieldTF;
}

- (UIButton *)finishBtn
{
    if (!_finishBtn)
    {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitle:@"完成" forState:UIControlStateDisabled];
        [_finishBtn setBackgroundImage:[InterfaceUtils createImageWithColor:HexRGB(0xFD9627)]forState:UIControlStateNormal];
        [_finishBtn setBackgroundImage:[InterfaceUtils createImageWithColor:HexRGB(0xFEDFBE)]forState:UIControlStateDisabled];
        
        _finishBtn.layer.cornerRadius = 23;
        _finishBtn.clipsToBounds = YES;
        
        [_finishBtn addTarget:self action:@selector(didClickedFinishButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_finishBtn];
        
    }
    
    return _finishBtn;
}

#pragma mark - Action

- (void)rightItemClick
{
    // 上传
    if ([self.cellModel.topLeftLbTitle isEqualToString:@"姓名"])
    {
        NSDictionary *dict = @{@"name" : self.fieldTF.text};
        
        // 名字修改
        [[HUDHepler sharedHelper] showLoading];
        [HttpRequestManager POST:@"hmapi/private/patient/" parameters:@{@"patient_info": dict} success:^(id responseObject, BOOL success) {
            
            [[HUDHepler sharedHelper] hideHUD];
            
            if (success) {
                
                self.cellModel.value = self.fieldTF.text;
                AppDelegate *delegate = kAppDelegate;
                delegate.userInfo.patient_info.name = self.fieldTF.text;
                
                if (self.delegateSignal) {
                    
                    [self.delegateSignal sendNext:@"refresh"];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } failure:^(NSError *error) {
            
            [[HUDHepler sharedHelper] hideHUD];
            
        }];
        
        
        
        
        
    }
    
    
}


/**
 下一步 、 完成
 */
- (void)didClickedFinishButton
{
    if (self.isFinished && self.isFinished.boolValue) {
        [self requestChangeToNewPhone];
    } else {
        [self requestVerifyCodeValue];
    }
    
}

/**
 手机获取验证码
 */
- (void)dataTextField:(DataInputTextField *)textField didSelectButton:(UIButton *)button
{
    // 判断手机号
    BOOL isValid = [StringUtils isValidMobilePhoneNum:self.phoneNumber];
    
    if (isValid)
    {
        WeakSelf(self);
        
        [HttpRequestManager GET:@"hmapi/protected/msisdn/code" parameters:@{@"msisdn" : self.phoneNumber} success:^(id responseObject, BOOL success) {
            
            if (success) {
                
                [[HUDHepler sharedHelper] showMessage:@"验证码已发送，请留意手机信息"];
                
            }
        } failure:^(NSError *error) {
            
            DLog(@"%@", error);
            
            [[HUDHepler sharedHelper] showMessage:@"无法连接到服务器"];
        }];
        
        
        [InterfaceUtils startCountdownWithTimeout:15 counting:^(NSInteger timeout, BOOL *stop) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakself.verifyCode.countdownBtn.enabled = NO;
                NSString * title = [NSString stringWithFormat:@"%ld秒后重新获取",timeout];
                
                [weakself.verifyCode.countdownBtn setTitle:title forState:UIControlStateDisabled];
                
                
            });
            
        } completion:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakself.isFinished.boolValue) {
                    if (weakself.phoneNum.text.length == 11) {
                        weakself.verifyCode.countdownBtn.enabled = YES;
                    }
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

/**
 验证旧手机验证码
 */
- (void)requestVerifyCodeValue
{
    NSString *phoneNum = self.phoneNumber;
    
    WeakSelf(self);
    [HttpRequestManager GET:@"hmapi/protected/msisdn/code_verif" parameters:@{@"msisdn" : phoneNum , @"code" : self.verifyCode.text} success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            JYEditingViewController *editVC = [[JYEditingViewController alloc] init];
            editVC.isFinished = @YES;
            editVC.cellModel = self.cellModel;
            [weakself.navigationController pushViewController:editVC animated:YES];
            
        }
        else
        {
            [[HUDHepler sharedHelper] showMessage:@"验证码错误，请重新输入"];
            
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
    
    
}


/**
 验证新手机
 */
- (void)requestChangeToNewPhone
{
    // 判断手机号
    NSString *phoneNum = self.phoneNum.text;
    NSString *code = self.verifyCode.text;
    
    // 再次判断手机号合法性
    BOOL isValid = [StringUtils isValidMobilePhoneNum:phoneNum];
    if (!isValid) {
        
        [[HUDHepler sharedHelper] showMessage:@"请输入正确的手机号"];
        return;
    }
    
    WeakSelf(self);
    
    [HttpRequestManager POST:@"hmapi/private/patient/msisdn" parameters:@{@"new_msisdn" : phoneNum, @"code" : code} success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            // 修改数据源
            weakself.cellModel.value = phoneNum;
            
            NSDictionary *result = (NSDictionary *)responseObject;
            if (result) {
                
                // 更新Token
                [kUserDefault setValue:[result objectForKey:@"token"] forKey:@"token"];
                
                // 利用Token需要重新请求个人数据
                JYTabBarViewController *tabbarVC =  (JYTabBarViewController *)self.tabBarController;
                [tabbarVC requestDataMine];
            }
            
            [[HUDHepler sharedHelper] showMessage:@"修改手机号成功"];
            [weakself back];
            
        }
        
    } failure:^(NSError *error) {
        
        DLog(@"%@", error);
        
        [[HUDHepler sharedHelper] showMessage:@"无法连接到服务器"];
    }];
}


#pragma mark - 手势、返回
- (void)back
{
    if (self.isFinished && self.isFinished.boolValue)
    {
        // 需要回退两级 回到编辑资料界面
        NSInteger index=[[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

// 禁止右滑手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.isFinished && self.isFinished.boolValue)
    {
        // 在完成界面禁止右滑返回手势
        return NO;
    }
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.isFinished = nil;
}

-(void)dealloc
{
    DLog(@"EditingView Dealloc");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.fieldTF resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [self.verifyCode resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
