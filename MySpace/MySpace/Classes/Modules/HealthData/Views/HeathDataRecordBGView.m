//
//  HeathDataRecordBGView.m
//  CYSDemo
//
//  Created by Paul on 2017/6/8.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "HeathDataRecordBGView.h"

@implementation HeathDataRecordBGView


- (void)drawRect:(CGRect)rect
{
    
//    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGFloat arrowHeight = 15.0;
//    CGFloat arrowWidth = 13.0;
//    CGPoint arrowPoint = CGPointMake(rect.origin.x+rect.size.width/2.0f,rect.origin.y);
//    CGMutablePathRef arrowPath = CGPathCreateMutable();
//    CGPathMoveToPoint(arrowPath, NULL, arrowPoint.x, arrowPoint.y);
//    CGPathAddLineToPoint(arrowPath, NULL, arrowPoint.x, arrowPoint.y+arrowHeight);
//    CGPathAddLineToPoint(arrowPath, NULL, rect.origin.x, rect.origin.y+arrowHeight);
//    CGPathAddLineToPoint(arrowPath, NULL, rect.origin.x, rect.origin.y+rect.size.height);
//    CGPathAddLineToPoint(arrowPath, NULL, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
//    
//    CGPathAddLineToPoint(arrowPath, NULL, rect.origin.x+rect.size.width, rect.origin.y+arrowHeight);
//    CGPathAddLineToPoint(arrowPath, NULL, arrowPoint.x+arrowWidth, rect.origin.y+arrowHeight);
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
//    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - 20);
//    CGPoint midPoint = CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height);
//    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - 20);
//    CGPathMoveToPoint(arcPath, NULL, startPoint.x, startPoint.y);
////    CGPathAddLineToPoint(arcPath, NULL, endPoint.x, endPoint.y);
//    
//    CGPathAddCurveToPoint(arcPath, NULL, startPoint.x, startPoint.y, midPoint.x, midPoint.y, endPoint.x, endPoint.y);
    
    CGPathAddArc(arcPath, NULL, rect.origin.x + rect.size.width * 0.5, -300, rect.size.height + 300, 0, 2 * M_PI, YES);
    
    CGPathCloseSubpath(arcPath); //封口
    CGContextAddPath(ctx, arcPath);
    
    
    
    [COLOR_STYLE_1 setFill];
    CGContextDrawPath(ctx,kCGPathFill);
    CGContextClip(ctx);
    CGPathRelease(arcPath);
    
    
    
    
}

@end
