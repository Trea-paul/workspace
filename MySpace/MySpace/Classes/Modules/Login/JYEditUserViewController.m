//
//  JYEditUserViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/15.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYEditUserViewController.h"
#import "JYEditingViewController.h"

#import "DataInputTextField.h"
#import "JYPickerView.h"

@interface JYEditUserViewController ()<DataInputTextFieldDelegate,JYTableViewControllerDelegate,AlertHelperDelegate,JYPickerViewDelegate>

@property (nonatomic, strong) UIImageView *iconView;              // 头像
@property (nonatomic, strong) UIImageView *cameraIcon;            // 相机图标
@property (nonatomic, strong) DataInputTextField *nameTF;         // 姓名
@property (nonatomic, strong) DataInputTextField *genderTF;       // 性别
@property (nonatomic, strong) DataInputTextField *ageTF;          // 年龄

@property (nonatomic, strong) UIButton *finishBtn;    // 完成

@property (nonatomic, strong) UIButton *logoutBtn;    // 退出登录

@property (nonatomic, strong) NSMutableArray *textFieldArray;   // TextField集合，方便上传数据

@property (nonatomic, strong) JYTableViewController *tableViewController;
@property (nonatomic, strong) JYTableViewModel *viewModel;

@property (nonatomic, strong) JYTableViewListCellModel *ageCellModel;



@end

@implementation JYEditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textFieldArray = [NSMutableArray array];
    
    
    
    if (self.isNewUser.boolValue)
    {
        self.title = @"资料填写";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : COLOR_STYLE_2} forState:UIControlStateNormal];
    }
    else
    {
        self.title = @"编辑个人资料";
    }
    
    
    [self setupUI];
    
}

//- (void)leftBarButtonItemClick:(UIBarButtonItem *)item
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)back
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

// 分为第一次界面和普通界面

- (void)setupUI
{
    self.iconView = [[UIImageView alloc] init];
    JYViewBorder(self.iconView, 45, 1, COLOR_STYLE_11);
    
    self.iconView.userInteractionEnabled = YES;
    self.iconView.clipsToBounds = YES;
    
    AppDelegate *delegate = kAppDelegate;
    JYPatientInfo *patientInfo = delegate.userInfo.patient_info;
    
    
    [self.view addSubview:self.iconView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClick:)];
    [self.iconView addGestureRecognizer:tap];
    
    self.cameraIcon = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_Login_camera")];
    
    [self.view addSubview:self.cameraIcon];
    
    
    if (self.isNewUser && self.isNewUser.boolValue)
    {
        [self setupTextField];
    }
    else
    {
        [self setupTableView];
    }
    
    
    WeakSelf(self);
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(64+40);
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    [self.cameraIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(weakself.iconView.mas_bottom);
        make.right.mas_equalTo(weakself.iconView.mas_right);
        make.size.mas_equalTo(CGSizeMake(28, 28));
        //        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    if (self.isNewUser && self.isNewUser.boolValue)
    {
        [self layoutTextField];
    }
    else
    {
        [self layoutTableView];
    }
    
    
    
    
    
}

- (void)setupTableView
{
    self.viewModel = [[JYTableViewModel alloc] initWithStyle:UITableViewStylePlain sectionModelsBlock:^(NSMutableArray *sectionModels) {
       
        JYTableViewSectionModel *sectionModel = [[JYTableViewSectionModel alloc] initWithCellModelsBlock:^(NSMutableArray *cellModels) {
            
            AppDelegate *delegate = kAppDelegate;
            JYPatientInfo *patientInfo = delegate.userInfo.patient_info;
           
            JYTableViewListCellModel *name = [self cellModelWithTitle:@"姓名" value:patientInfo.name];
            JYTableViewListCellModel *phone = [self cellModelWithTitle:@"手机号" value:patientInfo.phone_number];
            JYTableViewListCellModel *gender = [self cellModelWithTitle:@"性别" value:patientInfo.gender];
            JYTableViewListCellModel *age = [self cellModelWithTitle:@"年龄" value:patientInfo.age];
            
            self.ageCellModel = age;
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:patientInfo.avatar] placeholderImage:ImageNamed(@"icon_Login_head")];
            
            [cellModels addObjectsFromArray:@[name,phone,gender,age]];
        }];
        
        [sectionModels addObject:sectionModel];
    }];
    self.tableViewController.viewModel = self.viewModel;
}

- (void)setupTextField
{
    self.nameTF = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"Border" mode:DataInputTFViewModeNormal WithBlock:^(DataInputTextField *textField) {
        
        textField.placeholder = @"姓名";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    self.nameTF.fieldKey = @"name";
    
    [self.nameTF becomeFirstResponder];
    
    WeakSelf(self);
    
    self.genderTF = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"Border" mode:DataInputTFViewModeSelect WithBlock:^(DataInputTextField *textField) {
        
        textField.title = @"性别";
        textField.controller = weakself;
    }];
    
    self.genderTF.fieldKey = @"gender";
    self.genderTF.dataDelegate = self;
    
    self.ageTF = [[DataInputTextField alloc] initDataInputTextFieldInView:self.view style:@"Border" mode:DataInputTFViewModeSelect WithBlock:^(DataInputTextField *textField) {
        
        
        [textField resignFirstResponder];
        
        textField.title = @"年龄";
    }];
    
    self.ageTF.fieldKey = @"age";
    self.ageTF.dataDelegate = self;
    
    
    [self.textFieldArray addObject:self.nameTF];
    [self.textFieldArray addObject:self.genderTF];
    [self.textFieldArray addObject:self.ageTF];
}

- (JYTableViewListCellModel *)cellModelWithTitle:(NSString *)title value:(NSString *)value
{
    JYTableViewListCellModel *cellModel = [JYTableViewListCellModel new];
    
    cellModel.cellClass = [TwoLbNextImgTableViewCell class];
    
    cellModel.topLeftLbTitle = title;
    
    cellModel.value = value;
    
    if ([title isEqualToString:@"性别"]) {
        cellModel.value = [value integerValue] == 0 ? @"男" : @"女";
    }
    
    return cellModel;
}


- (JYTableViewController *)tableViewController
{
    if (!_tableViewController) {
        _tableViewController = [[JYTableViewController alloc] initWithStyle:UITableViewStylePlain];

        _tableViewController.delegate = self;
        _tableViewController.automaticallyAdjustsScrollViewInsets = NO;
        _tableViewController.tableView.scrollEnabled = NO;
        _tableViewController.tableView.backgroundView.backgroundColor = HexRGB(0xFFFFF0);
        
        _tableViewController.tableView.tableFooterView = [[UIView alloc] init];
        
        [self addChildViewController:_tableViewController];
        [self.view addSubview:_tableViewController.view];
        
    }
    return _tableViewController;
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
        
        _finishBtn.layer.cornerRadius = 22.5;
        _finishBtn.clipsToBounds = YES;
        
        [_finishBtn addTarget:self action:@selector(didClickedFinishButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_finishBtn];
        
    }
    
    return _finishBtn;
}

- (UIButton *)logoutBtn
{
    if (!_logoutBtn)
    {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        
        [_logoutBtn setTitleColor:HexRGB(0xFD9627) forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:HexRGB(0xD2691E) forState:UIControlStateHighlighted];
        _logoutBtn.titleLabel.font = FONT_SIZE(17);
        
        WeakSelf(self);
        [[_logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            // 退出登录
            
            [kUserDefault setValue:@"false" forKey:@"isLogin"];
            
            [weakself.delegateSignal sendNext:@"refresh"];
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [self.view addSubview:_logoutBtn];
        
    }
    
    return _logoutBtn;
}

- (void)layoutTableView
{
    WeakSelf(self);
    
    [self.tableViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.iconView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 300));
        
        
    }];
    
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(weakself.view.mas_bottom).offset(-100);
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    
}

- (void)layoutTextField
{
    WeakSelf(self);
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.iconView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    [self.genderTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.nameTF.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    [self.ageTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.genderTF.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weakself.ageTF.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(327, 45));
        make.centerX.mas_equalTo(weakself.view.mas_centerX);
        
    }];
    
}



#pragma mark - Action
// 跳过
- (void)rightItemClick
{
    // 发送通知，重新请求个人资料
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestDataMine" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 完成
- (void)didClickedFinishButton
{
    // 检查必填项 （姓名、性别、年龄）
    NSString *validity = @"";
    for (DataInputTextField *textField in self.textFieldArray) {
        
        if ([textField.fieldKey isEqualToString:@"name"])
        {
            if (!textField.textFieldValue || !textField.textFieldValue.length) {
                validity = [validity stringByAppendingString:@"姓名 "];
            }
        }
        else if ([textField.fieldKey isEqualToString:@"gender"])
        {
            if (!textField.textFieldValue || !textField.textFieldValue.length) {
                validity = [validity stringByAppendingString:@"性别 "];
            }
        }
        else
        {
            if (!textField.textFieldValue || !textField.textFieldValue.length) {
                validity = [validity stringByAppendingString:@"年龄"];
            }
        }
        
    }
    
    if (validity.length) {
        
        validity = [NSString stringWithFormat:@"请输入%@",validity];
        
        [[HUDHepler sharedHelper] showMessage:validity];
        
        [[AlertHelper sharedAlertHelper] alertActionWithType:UIAlertControllerStyleAlert title:nil message:validity inController:self alertActions:^(UIAlertController *alertController) {
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:confirm];
        }];
        
        return;
    }
    
    NSMutableDictionary *uploadDict = [NSMutableDictionary dictionary];
    
    for (DataInputTextField *textField in self.textFieldArray) {
        
        DLog(@"完成： %@ -- %@", textField.fieldKey, textField.textFieldValue);
        
        if ([textField.fieldKey isEqualToString:@"gender"])
        {
            NSString *gender = [textField.textFieldValue isEqualToString:@"男"] ? @"0" : @"1";
            [uploadDict setValue:gender forKey:textField.fieldKey];
        }
        else
        {
            [uploadDict setValue:textField.textFieldValue forKey:textField.fieldKey];
        }
        
    }
    
    [HttpRequestManager POST:@"hmapi/private/patient/" parameters:@{@"patient_info" : uploadDict} success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            // 发送通知，重新请求个人资料
            [[NSNotificationCenter defaultCenter] postNotificationName:@"requestDataMine" object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [[HUDHepler sharedHelper] showMessage:@"资料更新失败"];
            
        }
        
        
        
        
    } failure:^(NSError *error) {
        
        DLog(@"%@", error);
        
    }];
    
    
    
    
    
    
    
}


// 点击事件
- (void)dataTextField:(DataInputTextField *)textField didSelectButton:(UIButton *)button
{
    NSString *titileTF = textField.title;
    
    if (!titileTF.length) return;
    
    if ([titileTF isEqualToString:@"性别"])
    {
        DLog(@"性别%@",textField.text);
        
    }
    else if ([titileTF isEqualToString:@"年龄"])
    {
        DLog(@"年龄%@",textField.text);
    }
    
    
    [self.nameTF resignFirstResponder];
    
    
}

- (void)tableViewModel:(JYTableViewModel *)tableViewModel didSelectCellModel:(JYTableViewListCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    if ([cellModel.topLeftLbTitle isEqualToString:@"姓名"])
    {
        JYEditingViewController *editVC = [[JYEditingViewController alloc] init];
        editVC.cellModel = cellModel;
        editVC.viewType = @"FIELD";
        
        WeakSelf(self);
        editVC.delegateSignal = [RACSubject subject];
        [editVC.delegateSignal subscribeNext:^(NSString *signal) {
            
            if ([signal isEqualToString:@"refresh"]) {
                
                if (weakself.delegateSignal) {
                    [weakself.delegateSignal sendNext:@"refresh"];
                }
            }
            
        }];
        
        [self.navigationController pushViewController:editVC animated:YES];
    }
    else if ([cellModel.topLeftLbTitle isEqualToString:@"手机号"])
    {
        JYEditingViewController *editVC = [[JYEditingViewController alloc] init];
        editVC.cellModel = cellModel;
        editVC.viewType = @"PHONE";
        [self.navigationController pushViewController:editVC animated:YES];
        
    }
    else if ([cellModel.topLeftLbTitle isEqualToString:@"性别"])
    {
        [self alertGenderSelectionWithCellModel:cellModel];
    }
    else if ([cellModel.topLeftLbTitle isEqualToString:@"年龄"])
    {
        [self alertAgeSelectionWithCellModel:cellModel];
    }
    
    
}

/**
 更新个人资料

 @param field 字段名
 @param value 值
 */
- (void)updatePatientInfoWithField:(NSString *)field value:(NSString *)value
{
    NSDictionary *dict = @{field : value};
    
    // 性别、年龄 修改
    [[HUDHepler sharedHelper] showLoading:nil inView:self.view];
    [HttpRequestManager POST:@"hmapi/private/patient/" parameters:@{@"patient_info": dict} success:^(id responseObject, BOOL success) {
        
        [[HUDHepler sharedHelper] hideHUDInView:self.view];
        
        if (success) {
            
            AppDelegate *delegate = kAppDelegate;
            
            if ([field isEqualToString:@"gender"]) {
                
                delegate.userInfo.patient_info.gender = value;
                
            } else if ([field isEqualToString:@"age"]) {
                
                delegate.userInfo.patient_info.age = value;
            }
        }
        
    } failure:^(NSError *error) {
        
        [[HUDHepler sharedHelper] hideHUD];
        
    }];
    
    
    
    
}


- (void)iconViewClick:(UIGestureRecognizer *)recognizer
{
    [[AlertHelper sharedAlertHelper] alertActionSheetWithType:ActionSheetTypePhoto inController:self alertActions:^(UIAlertController *alertController) {
        
    }];
    
    [AlertHelper sharedAlertHelper].delegate = self;
    
}

- (void)alertViewdidFinishPickingMediaWithImage:(UIImage *)image tempPath:(NSString *)path
{
    WeakSelf(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [HttpRequestManager POST:@"hmapi/private/patient/avatar" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSURL * fileURL = [[NSURL alloc] initFileURLWithPath:path];
            [formData appendPartWithFileURL:fileURL name:@"file" error:nil];
            
        } success:^(id responseObject, BOOL success) {
            
            
            if (success) {
                DLog(@"头像上传成功");
                
                NSDictionary *result = (NSDictionary *)responseObject;
                NSString *imageUrl = [result valueForKey:@"resource_url"];
                [weakself.iconView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
                
                // 更新模型
                AppDelegate *delegate = kAppDelegate;
                delegate.userInfo.patient_info.avatar = imageUrl;
                
                if (self.delegateSignal) {
                    [self.delegateSignal sendNext:@"refresh"];
                }
                
            }
            else
            {
                [[HUDHepler sharedHelper] showMessage:@"头像上传失败"];
            }
            
            
        } failure:^(NSError *error) {
            
            
            DLog(@"头像上传失败");
        }];
        
        
        
        
        
    });
    
    
    
    
}

- (void)alertGenderSelectionWithCellModel:(JYTableViewListCellModel *)cellModel;
{
    [[AlertHelper sharedAlertHelper] alertActionSheetWithType:ActionSheetTypeGender inController:self alertActions:^(UIAlertController *alertController) {
    
        UIAlertAction *male = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cellModel.value = @"男";
            
            [self updatePatientInfoWithField:@"gender" value:@"0"];
            
        }];
        
        UIAlertAction *female = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cellModel.value = @"女";
            
            [self updatePatientInfoWithField:@"gender" value:@"1"];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:male];
        [alertController addAction:female];
        [alertController addAction:cancel];
        
    }];
    
    
}

- (void)alertAgeSelectionWithCellModel:(JYTableViewListCellModel *)cellModel
{
    JYPickerView *pickerView = [JYPickerView sharedPickerView];
    pickerView.delegate = self;
    pickerView.currentValue = cellModel.value;
    [pickerView show];
}

- (void)jy_pickerView:(UIPickerView *)pickerView didSelectRowValue:(NSString *)rowValue inComponentValue:(NSString *)componentValue
{
    self.ageCellModel.value = rowValue;
    
    [self updatePatientInfoWithField:@"age" value:rowValue];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameTF resignFirstResponder];
}


-(void)dealloc
{
    DLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
