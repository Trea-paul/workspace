//
//  VIPServiceListView.h
//  CYSDemo
//
//  Created by Paul on 2017/6/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPServiceListView : UIImageView

@property (nonatomic, copy) NSString *serviceTitle;

@property (nonatomic, copy) NSString *remain;
@property (nonatomic, strong) UILabel *remainLb;  // 剩余

@property (nonatomic, strong) NSNumber *isLogin;

@property (nonatomic, strong) NSNumber *showRenew;

@property (nonatomic, strong) UIButton *renewBtn;  // 续费 获取点击事件

- (void)updateDataViewWithIsLogin:(BOOL)isLogin;

//- (void)updateDataView;

@end
