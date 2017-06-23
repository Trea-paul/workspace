//
//  JYPickerView.h
//  CYSDemo
//
//  Created by Paul on 2017/5/16.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JYPickerViewDelegate <NSObject>

//- (void)jy_pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)jy_pickerView:(UIPickerView *)pickerView didSelectRowValue:(NSString *)rowValue inComponentValue:(NSString *)componentValue;

@end

@interface JYPickerView : UIView

+ (instancetype)sharedPickerView;

- (instancetype)initPickerViewWithType:(NSString *)type;

@property (nonatomic, copy) NSString *currentValue;

- (void)show;

- (void)hide;

@property (nonatomic, weak) id<JYPickerViewDelegate>delegate;

@end
