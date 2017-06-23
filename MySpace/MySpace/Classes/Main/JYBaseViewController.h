//
//  JYBaseViewController.h
//  CYSDemo
//
//  Created by Paul on 2017/5/2.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBaseViewController : UIViewController

// 状态栏
@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, assign, readonly) CGFloat navigationHeight;

@property (nonatomic, strong) UIBarButtonItem *leftButtonItem;


- (void)doLoginProcess;

- (void)back;

@end
