//
//  StringUtils.h
//  CYSDemo
//
//  Created by Paul on 2017/5/15.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject


/**
 手机号是否合法

 @param phoneNum 手机号
 */
+ (BOOL)isValidMobilePhoneNum:(NSString *)phoneNum;


// 字符串尺寸

// 分割字符串（、）
+ (NSArray *)separatedString:(NSString *)string byComponent:(NSString *)component;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font;

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize;


@end
