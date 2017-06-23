//
//  DataInputTextField.h
//  CYSDemo
//
//  Created by Paul on 2017/5/12.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 输入框样式
 */
typedef NS_ENUM(NSInteger, DataInputTFViewMode) {
    DataInputTFViewModeNormal,                   // 普通样式
    DataInputTFViewModeCountdown,                // 倒计时
    DataInputTFViewModeGender,                   // 性别
    DataInputTFViewModeMark,                      // 描述
    DataInputTFViewModeSelect                     // 选择
};

@class DataInputTextField;

@protocol DataInputTextFieldDelegate <NSObject>

- (void)dataTextField:(DataInputTextField *)textField didSelectButton:(UIButton *)button;

@end



@interface DataInputTextField : UITextField


//@property (nonatomic, copy) NSString *imageName;
//@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy) NSString *textFieldValue;

@property (nonatomic, copy) NSString *fieldKey;

// 获取验证码与倒计时
@property (nonatomic, strong) UIButton *countdownBtn;

@property (nonatomic, strong) NSNumber *isCounting;

// 选择控件
@property (nonatomic, strong) NSString *title;      // 标题
@property (nonatomic, strong) NSString *tipsTitle;   // 选择提示
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel  *valueLabel;

@property (nonatomic, strong) UIViewController *controller;

/**
 初始化一个输入控件

 @param imageName 图片名
 @param placeHolder 输入提示框
 @return self
 */
- (instancetype)initDataInputTextFieldWithImageName:(NSString *)imageName placeHolder:(NSString *)placeHolder;


/**
 初始化一个输入控件，利用Block返回做定制化

 @param block Block定制化
 @param style 风格  Border 矩形圆角  Normal 矩形无边框 BottomLine 矩形下划线
 */
- (instancetype)initDataInputTextFieldInView:(UIView *)view style:(NSString *)style mode:(DataInputTFViewMode)viewMode WithBlock:(void(^)(DataInputTextField *textField))block;



@property (nonatomic, weak) id<DataInputTextFieldDelegate> dataDelegate;



@end
