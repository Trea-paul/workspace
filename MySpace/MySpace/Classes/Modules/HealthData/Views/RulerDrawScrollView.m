//
//  RulerDrawScrollView.m
//  CYSDemo
//
//  Created by Paul on 2017/6/19.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "RulerDrawScrollView.h"

@implementation RulerDrawScrollView

- (void)drawRulerScrollView
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1.f;
    shapeLayer.lineCap = kCALineCapRound;
    
    int count = (self.maxValue - self.minValue) / self.rulerAverage;
    
    for (int i = self.minValue; i <= self.maxValue; i++) {
        
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = COLOR_STYLE_5;
        rule.font = FONT_SIZE(12);
        rule.text = [NSString stringWithFormat:@"%.0f", i * self.rulerAverage];
        CGSize textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        if (i % 10 == 0) {
            // 10的倍数
            CGPathMoveToPoint(pathRef, NULL, kDistanceLeftAndRight + kDistanceMargin * i , self.rulerHeight - 24);
            CGPathAddLineToPoint(pathRef, NULL, kDistanceLeftAndRight + kDistanceMargin * i, self.rulerHeight);
            
            rule.frame = CGRectMake(kDistanceLeftAndRight + kDistanceMargin * i - textSize.width / 2, 8, 0, 0);
            [rule sizeToFit];
            [self addSubview:rule];
        }
        else if (i % 5 == 0) {
            // 5的倍数
            CGPathMoveToPoint(pathRef, NULL, kDistanceLeftAndRight + kDistanceMargin * i , self.rulerHeight);
            CGPathAddLineToPoint(pathRef, NULL, kDistanceLeftAndRight + kDistanceMargin * i, self.rulerHeight - 12);
        }
        else
        {
            //            CGPathMoveToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i , DISTANCETOPANDBOTTOM + 20);
            //            CGPathAddLineToPoint(pathRef, NULL, DISTANCELEFTANDRIGHT + DISTANCEVALUE * i, self.rulerHeight - DISTANCETOPANDBOTTOM - textSize.height - 20);
        }
    }
    
    shapeLayer.path = pathRef;
    
    [self.layer addSublayer:shapeLayer];
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);
    
    // 开启最小模式
//    if (self.mode) {
        UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2.f - kDistanceMargin * self.minValue, 0, self.rulerWidth / 2.f + kDistanceMargin * self.minValue);
        self.contentInset = edge;
    
        self.contentOffset = CGPointMake(kDistanceMargin * (self.rulerValue / self.rulerAverage) - self.rulerWidth + (self.rulerWidth / 2.f), 0);
//    }
//    else
//    {
//        self.contentOffset = CGPointMake(DISTANCEVALUE * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + DISTANCELEFTANDRIGHT, 0);
//    }
    
    self.contentSize = CGSizeMake(count * kDistanceMargin, self.rulerHeight);
}

@end
