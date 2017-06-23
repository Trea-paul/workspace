//
//  InterfaceUtils.h
//  CYSDemo
//
//  Created by Paul on 2017/5/15.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceUtils : NSObject


+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColorValue:(NSUInteger)colorValue;

// 一个计时器

/**
 初始化一个倒计时器

 * 方法调用后，timeout会先自动-1，所以如果从15秒开始倒计时timeout应该写16
 @param timeout 时间
 @param counting 正在倒计时，每次倒计时都会调用Block
 @param completion 倒计时结束
 */
+ (void)startCountdownWithTimeout:(NSInteger)timeout
                         counting:(void(^)(NSInteger timeout, BOOL *stop))counting
                       completion:(void (^)(void))completion;





@end
