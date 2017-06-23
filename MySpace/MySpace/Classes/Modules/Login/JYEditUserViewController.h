//
//  JYEditUserViewController.h
//  CYSDemo
//
//  Created by Paul on 2017/5/15.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYEditUserViewController : JYBaseViewController

// 必填项
@property (nonatomic, strong) NSNumber *isNewUser;


@property (nonatomic, strong) RACSubject *delegateSignal;

@end
