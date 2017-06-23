//
//  JYBaseViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYBaseViewController.h"
#import "JYLoginViewController.h"
#import "JYNavigationViewController.h"

@interface JYBaseViewController ()

@end

@implementation JYBaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.
//        NSString *name = @"back";[UIImage imageNamed:@"back"]
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_STYLE_1;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    if (self.navigationController.viewControllers.count > 1) {
        self.leftButtonItem = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
        self.navigationItem.leftBarButtonItem = self.leftButtonItem;
        
        // 手势右滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.statusView.hidden = YES;
    
    
}

- (void)leftItemClick
{
    [self back];
}

- (UIView *)statusView
{
    if (!_statusView) {
        // 悬停改变状态栏颜色
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        _statusView.backgroundColor = JYRandomColor;
        [self.view addSubview:_statusView];
        
    }
    return _statusView;
}

- (CGFloat)navigationHeight
{
//    CGFloat height = self.navigationController.view.frame.size.height;
    
    return 64;
}

- (void)doLoginProcess
{
    
    JYLoginViewController *loginVC = [[JYLoginViewController alloc] init];
    
    JYNavigationViewController *naviVC = [[JYNavigationViewController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:naviVC animated:YES completion:^{
        
    }];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
