//
//  JYNavigationViewController.m
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYNavigationViewController.h"

#define Hex(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

@implementation JYNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    NSDictionary *attributes = @{NSForegroundColorAttributeName: Hex(0x333333),NSFontAttributeName: [UIFont systemFontOfSize:18]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    [[UINavigationBar appearance] setTintColor:Hex(0x333333)];
    
    UIImage *img = [[UIImage imageNamed:@"btn_back_n"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:img forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}





@end
