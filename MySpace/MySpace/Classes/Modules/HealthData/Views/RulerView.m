//
//  RulerView.m
//  CYSDemo
//
//  Created by Paul on 2017/6/19.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "RulerView.h"
#import "RulerDrawScrollView.h"

@interface RulerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) RulerDrawScrollView *rulerScrollView;


@end

@implementation RulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.rulerScrollView = [self rulerScrollView];
        self.rulerScrollView.rulerHeight = frame.size.height - 10;
        self.rulerScrollView.rulerWidth = frame.size.width;
    }
    return self;
}

- (void)rulerViewWithMaxValue:(CGFloat)maxValue
                  minValue:(CGFloat)minValue
                   average:(CGFloat)average
              currentValue:(CGFloat)currentValue
                 smallMode:(BOOL)mode
{
    NSAssert(self.rulerScrollView != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
    NSAssert(currentValue <= maxValue && currentValue >= minValue, @"***** currentValue 需大于最小值minValue且小于最大值maxValue \n");
    self.rulerScrollView.maxValue = maxValue;
    self.rulerScrollView.minValue = minValue;
    self.rulerScrollView.rulerAverage = average;
    self.rulerScrollView.rulerValue = currentValue;
    self.rulerScrollView.mode = mode;
    self.rulerScrollView.frame = CGRectMake(20, 2, self.rulerScrollView.rulerWidth, self.rulerScrollView.rulerHeight);
    [self.rulerScrollView drawRulerScrollView];
    
    [self drawIndicator];
    
    
    
    
}

- (RulerDrawScrollView *)rulerScrollView
{
    if (!_rulerScrollView) {
        _rulerScrollView = [[RulerDrawScrollView alloc] init];
        _rulerScrollView.showsHorizontalScrollIndicator = NO;
        _rulerScrollView.delegate = self;
        [self addSubview:_rulerScrollView];
    }
    return _rulerScrollView;
}


/**
 绘图指示器
 */
- (void)drawIndicator
{
    // 渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor];
    
    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.5f]];
    
    gradient.startPoint = CGPointMake(0, .5);
    gradient.endPoint = CGPointMake(1, .5);
    
    [self.layer addSublayer:gradient];
    
    // 橙色指示器
//    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
//    shapeLayerLine.strokeColor = COLOR_STYLE_2.CGColor;
//    shapeLayerLine.fillColor = COLOR_STYLE_2.CGColor;
//    shapeLayerLine.lineWidth = 3.f;
//    shapeLayerLine.lineCap = kCALineCapSquare;
//    
//    //    NSUInteger ruleHeight = 20; // 文字高度
//    CGMutablePathRef pathLine = CGPathCreateMutable();
//    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height + 2);
//    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, - 2);
//    
////    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 - SHEIGHT / 2, DISTANCETOPANDBOTTOM);
////    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 + SHEIGHT / 2, DISTANCETOPANDBOTTOM);
////    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, DISTANCETOPANDBOTTOM + SHEIGHT);
//    
//    shapeLayerLine.path = pathLine;
//    [self.layer addSublayer:shapeLayerLine];
    
    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(RulerDrawScrollView *)scrollView {
    
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2;
    CGFloat ruleValue = (offSetX / kDistanceMargin) * scrollView.rulerAverage;
    if (ruleValue < scrollView.minValue) {
        ruleValue = scrollView.minValue;
//        return;
    } else if (ruleValue > scrollView.maxValue) {
        ruleValue = scrollView.maxValue;
//        return;
    }
    
    if (self.rulerDeletate) {
        if (!scrollView.mode) {
            scrollView.rulerValue = ruleValue;
        }
        scrollView.mode = NO;
        [self.rulerDeletate rulerView:scrollView.rulerValue];
    }
}







//- (void)scrollViewDidEndDecelerating:(RulerDrawScrollView *)scrollView {
//    [self animationRebound:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(RulerDrawScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self animationRebound:scrollView];
//}

- (void)animationRebound:(RulerDrawScrollView *)scrollView {
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2;
    CGFloat oX = (offSetX / kDistanceMargin) * scrollView.rulerAverage;
#ifdef DEBUG
    NSLog(@"ago*****************ago:oX:%f",oX);
#endif
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
#ifdef DEBUG
    NSLog(@"after*****************after:oX:%.1f",oX);
#endif
    CGFloat offX = (oX / scrollView.rulerAverage) * kDistanceMargin - self.frame.size.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(CGFloat)number {
    NSString *value = [NSString stringWithFormat:@"%f",number];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}




@end
