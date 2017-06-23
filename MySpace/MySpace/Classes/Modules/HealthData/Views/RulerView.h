//
//  RulerView.h
//  CYSDemo
//
//  Created by Paul on 2017/6/19.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RulerDrawScrollView;
@protocol RulerViewDelegate <NSObject>

- (void)rulerView:(CGFloat)rulerViewValue;

@end

@interface RulerView : UIView


@property (nonatomic, weak) id<RulerViewDelegate>rulerDeletate;

//@property (nonatomic, assign) CGFloat rulerViewValue;


/**
 初始化刻度尺

 @param maxValue 最大值
 @param minValue 最小值
 @param average 平均值
 @param currentValue 当前值
 */
- (void)rulerViewWithMaxValue:(CGFloat)maxValue
                  minValue:(CGFloat)minValue
                   average:(CGFloat)average
              currentValue:(CGFloat)currentValue
                 smallMode:(BOOL)mode;

@end
