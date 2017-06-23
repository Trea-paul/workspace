//
//  DateTimePickerView.h
//  CYSDemo
//
//  Created by Paul on 2017/6/21.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTableViewCellModel.h"

@interface DateTimePickerView : UIView

@property (nonatomic, strong) JYTableViewCellModel *cellModel;

@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, copy) NSString *pickerTitle;

+ (instancetype)sharedDateTimePickerView;

- (void)show;

- (void)dismiss;

@end
