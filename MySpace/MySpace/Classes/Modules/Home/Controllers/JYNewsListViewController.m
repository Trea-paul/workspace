//
//  JYNewsListViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYNewsListViewController.h"

@interface JYNewsListViewController ()

@end

@implementation JYNewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setupUI];
    
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.title = @"心脑白问";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
}

- (void)rightItemClick
{
    
    
    
    
    
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
