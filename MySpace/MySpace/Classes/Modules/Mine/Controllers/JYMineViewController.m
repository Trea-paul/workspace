//
//  JYMineViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYMineViewController.h"
#import "JYEditUserViewController.h"
#import "JYLoginViewController.h"


#import "EditUserInfoTableListCell.h"
#import "OneImgTableListCell.h"



@interface JYMineViewController ()<JYTableViewControllerDelegate>

@property (nonatomic, strong) JYTableViewController *tableViewController;
@property (nonatomic, strong) JYTableViewModel *viewModel;


@end

@implementation JYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_STYLE_1;
    
    self.title = @"我的";
    
    [self setupUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setupUI
{
    
    self.tableViewController.view.frame = CGRectMake(0, self.navigationHeight, SCREEN_WIDTH, SCREENH_HEIGHT);
    
    
    [self updateTableView];
    
    WeakSelf(self);
    // 监听个人资料的改变，该通知会自动释放
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UserInfoUpdated" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        DLog(@"个人资料有更新");
        
        [weakself updateTableView];
    }];
    
}

- (JYTableViewController *)tableViewController
{
    if (!_tableViewController) {
        _tableViewController = [[JYTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _tableViewController.view.userInteractionEnabled = YES;
        _tableViewController.delegate = self;
        _tableViewController.automaticallyAdjustsScrollViewInsets = NO;
        
        _tableViewController.tableView.backgroundView.backgroundColor = HexRGB(0xFFFFF0);
        [self addChildViewController:_tableViewController];
        [self.view addSubview:_tableViewController.view];
    }
    return _tableViewController;
}


- (void)updateTableView
{
    self.viewModel = [[JYTableViewModel alloc] initWithStyle:UITableViewStylePlain sectionModelsBlock:^(NSMutableArray *sectionModels) {
       
        JYTableViewSectionModel *sectionModel = [[JYTableViewSectionModel alloc] initWithCellModelsBlock:^(NSMutableArray *cellModels) {
            
            AppDelegate *delegate = kAppDelegate;
            JYPatientInfo *patientInfo = delegate.userInfo.patient_info;
            JYTableViewListCellModel *infoCellModel = [JYTableViewListCellModel new];
            infoCellModel.cellClass = [EditUserInfoTableListCell class];
            infoCellModel.topLeftLbTitle = [NSString stringWithFormat:@"您好，%@", patientInfo.name ? patientInfo.name : @""];
            infoCellModel.centerLeftLbTitle = @"欢迎使用橙医生服务";
            infoCellModel.bottomLeftBtnTitle = @"编辑个人资料";
            infoCellModel.centerBtnTitle = @"一键登录";
            infoCellModel.topRightLbTitle = patientInfo.avatar;      // 头像
            infoCellModel.bottomLeftLbTitle = @"剩余99个月";
           
            // 是否登录
            infoCellModel.centerRightLbTitle = [[kUserDefault valueForKey:@"isLogin" ] isEqualToString:@"true"] ? @"true" : @"false";
            
            [cellModels addObject:infoCellModel];
            
            JYTableViewListCellModel *aboutCellModel = [self setCellModelWithTitle:@"关于我们" desc:@"关于橙医生私人医生服务" imageName:@"icon_set_about"];
            JYTableViewListCellModel *agreementCellModel = [self setCellModelWithTitle:@"用户协议" desc:@"使用服务前请使用服务前请使用服务前请使用服务前请仔细阅读" imageName:@"icon_set_pro"];
            JYTableViewListCellModel *callCellModel = [self setCellModelWithTitle:@"客户热线" desc:@"400-800-9000" imageName:@"icon_set_call"];
            
            [cellModels addObject:aboutCellModel];
            [cellModels addObject:agreementCellModel];
            [cellModels addObject:callCellModel];
        }];
        
        [sectionModels addObject:sectionModel];
        
        
    }];
    
    self.tableViewController.viewModel = self.viewModel;
    
}

- (JYTableViewListCellModel *)setCellModelWithTitle:(NSString *)title desc:(NSString *)desc imageName:(NSString *)imageName
{
    JYTableViewListCellModel *cellModel = [JYTableViewListCellModel new];
    
    cellModel.cellClass = [OneImgTwoLbNextTableListCell class];
    cellModel.topLeftLbTitle = imageName;
    cellModel.centerLeftLbTitle = title;
    cellModel.centerLbTitle = desc;
    
    return cellModel;
}


#pragma mark - JYTableView Delegate
- (void)tableViewModel:(JYTableViewModel *)tableViewModel didSelectCellModel:(JYTableViewListCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    if ([cellModel.cellClass isSubclassOfClass:[OneImgTwoLbNextTableListCell class]]) {
        
        if ([cellModel.centerLeftLbTitle isEqualToString:@"关于我们"])
        {
            // 关于我们
            
        }
        else if ([cellModel.centerLeftLbTitle isEqualToString:@"用户协议"])
        {
            // 用户协议
            
        }
        else if ([cellModel.centerLeftLbTitle isEqualToString:@"客户热线"])
        {
            // 客户热线
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"是否拨打电话" message:cellModel.centerLbTitle preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *telString = [NSString stringWithFormat:@"tel://%@", cellModel.value];
                NSURL *telURL = [NSURL URLWithString:telString];
                [[UIApplication sharedApplication] openURL:telURL];
            }];
            
            [alertView addAction:cancel];
            [alertView addAction:confirm];
            
            WeakSelf(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself presentViewController:alertView animated:YES completion:nil];
            });
        }
        
        
    }
    
    
    
    
}

- (void)tableViewModel:(JYTableViewModel *)tableViewModel didTouchUpInsideButton:(UIButton *)button cellModel:(JYTableViewListCellModel *)cellModel atIndexPath:(NSIndexPath *)indexPath
{
    if ([cellModel.cellClass isSubclassOfClass:[EditUserInfoTableListCell class]]) {
        
        if (button.tag == 101) {
            // 编辑个人资料
            JYEditUserViewController *editUser = [[JYEditUserViewController alloc] init];
            editUser.hidesBottomBarWhenPushed = YES;
            editUser.isNewUser = @NO;
            
            editUser.delegateSignal = [RACSubject subject];
            [editUser.delegateSignal subscribeNext:^(NSString *needRefresh) {
               
                WeakSelf(self);
                if ([needRefresh isEqualToString:@"refresh"]) {
                    [weakself updateTableView];
                }
                
            }];
            
            
            [self.navigationController pushViewController:editUser animated:YES];
            
            
            
        }
        else if (button.tag == 102) {
            // 一键登录
//            [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"isLogin"];
            
//            [self updateTableView];
            
//            [self doLoginProcess];
            
            JYLoginViewController *loginVC = [[JYLoginViewController alloc] init];
            
//            loginVC.delegateSignal = [RACSubject subject];
//            WeakSelf(self);
//            [loginVC.delegateSignal subscribeNext:^(NSString *refresh) {
//               
//                if ([refresh isEqualToString:@"refresh"]) {
//                    [weakself updateTableView];
//                }
//            }];
            
            JYNavigationViewController *naviVC = [[JYNavigationViewController alloc] initWithRootViewController:loginVC];
            
            [self.tabBarController presentViewController:naviVC animated:YES completion:^{
                
            }];
            
        }
        else if (button.tag == 103) {
            // 续费
            
            DLog(@"续费");
        }
        
        
        
    }
    
    
}

-(void)dealloc
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
