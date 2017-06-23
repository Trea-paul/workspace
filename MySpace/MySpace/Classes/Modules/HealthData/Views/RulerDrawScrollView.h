//
//  RulerDrawScrollView.h
//  CYSDemo
//
//  Created by Paul on 2017/6/19.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDistanceLeftAndRight 0.f // 标尺左右距离
#define kDistanceMargin 5.f // 每隔刻度实际长度8个点
#define kDistanceTopAndBottom 0.f // 标尺上下距离

@interface RulerDrawScrollView : UIScrollView

@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;

@property (nonatomic, assign) CGFloat rulerAverage;

@property (nonatomic, assign) CGFloat rulerHeight;

@property (nonatomic, assign) CGFloat rulerWidth;

@property (nonatomic, assign) CGFloat rulerValue;

@property (nonatomic, assign) BOOL mode;

- (void)drawRulerScrollView;


@end
