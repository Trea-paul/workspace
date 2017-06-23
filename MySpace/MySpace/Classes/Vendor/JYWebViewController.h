//
//  JYWebViewController.h
//  CYSDemo
//
//  Created by Paul on 2017/5/11.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYWebViewController : JYBaseViewController

@property (nonatomic, copy) NSString *requestUrl;
/** 是否显示Nav */
@property (nonatomic,assign) BOOL isNavHidden;


@end
