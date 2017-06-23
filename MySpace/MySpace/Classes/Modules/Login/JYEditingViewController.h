//
//  JYEditingViewController.h
//  CYSDemo
//
//  Created by Paul on 2017/5/18.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYEditingViewController : JYBaseViewController

@property (nonatomic, strong) JYTableViewListCellModel *cellModel;

// 目前有FIELD：普通字段修改， (默认)PHONE：手机号码修改
@property (nonatomic, copy) NSString *viewType;

// 修改手机号时，显示下一步布局还是完成布局
@property (nonatomic, strong) NSNumber *isFinished;

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
