//
//  JYTabBarViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYTabBarViewController.h"
#import "JYBaseViewController.h"
#import "JYNavigationViewController.h"
#import "JYHomeViewController.h"
#import "JYHealthDataViewController.h"
#import "JYDocServiceViewController.h"
#import "JYMineViewController.h"


@interface JYTabBarViewController ()

@end

@implementation JYTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCommonAppearence];
//    [self createCustomTabBar];
    
    [self addChildControllers];
    
    [self setupNotification];
     [self requestData];
}

- (void)setupCommonAppearence
{
    // 设置为不透明 NO 时屏幕尺寸自动减少Tabbar高度，YES时则包括tabbar高度
    [[UITabBar appearance] setTranslucent:NO];
    
    // 设置背景颜色
//    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    [UITabBar appearance].barTintColor = COLOR_STYLE_1;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_STYLE_3, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_STYLE_2, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
}

- (void)addChildControllers
{
    [self addChildViewControllerWithClassName:[JYHomeViewController description] imageName:@"home" title:@"首页"];
    [self addChildViewControllerWithClassName:[JYHealthDataViewController description] imageName:@"healthData" title:@"记录数据"];
    [self addChildViewControllerWithClassName:[JYDocServiceViewController description] imageName:@"privateDoc" title:@"私人医生"];
    [self addChildViewControllerWithClassName:[JYMineViewController description] imageName:@"mine" title:@"我的"];
}

- (void)createCustomTabBar
{
    
}

// 添加子控制器
- (void)addChildViewControllerWithClassName:(NSString *)className
                                  imageName:(NSString *)imageName
                                      title:(NSString *)title {
    
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    JYNavigationViewController *nav = [[JYNavigationViewController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imageName];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:[imageName stringByAppendingString:@"_press"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}


// 请求数据
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
   
    
    
    
}

- (void)setupNotification
{
    WeakSelf(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"requestDataMine" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
       
        [weakself requestDataMine];
    }];
    
}


- (void)requestData
{
    
    
    
    [self requestDataMine];
    
}


/**
 请求我的页面数据
 */
- (void)requestDataMine
{
    [HttpRequestManager GET:@"hmapi/private/patient/" parameters:nil success:^(id responseObject, BOOL success) {
        
        if (success) {
            
            NSDictionary *result = (NSDictionary *)responseObject;
            
            AppDelegate *delegate = kAppDelegate;
            
            JYUserInfo *userInfo = [[JYUserInfo alloc] init];
            
            [userInfo mj_setKeyValues:result];
            
            delegate.userInfo = userInfo;
            
            // 发出广播，个人资料更新
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdated" object:nil];
            
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
    
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
