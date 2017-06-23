//
//  DateUtils.h
//  CYSDemo
//
//  Created by Paul on 2017/5/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DATE_STYLE_yyyyMMddHHmmssSSS = @"yyyy-MM-dd HH:mm:ss.SSS";
static NSString *const DATE_STYLE_yyyyMMdd = @"yyyy-MM-dd";
static NSString *const DATE_STYLE_HHmm = @"HH:mm";
static NSString *const DATE_STYLE_yyyyMMddEEE = @"yyyy-MM-dd EEE";
static NSString *const DATE_STYLE_yyyyMMddHHmmss = @"yyyy-MM-dd-HH-mm-ss";
static NSString *const DATE_STYLE_yyyyMMddHHmmss_file = @"yyyyMMddHHmmss";
static NSString *const DATE_STYLE_yyyyMMddHHmmEEE = @"yyyy-MM-dd HH:mm EEE";
static NSString *const DATE_STYLE_yyyyMMddHHmm = @"yyyy-MM-dd HH:mm";
static NSString *const DATE_STYLE_MMddHHmm = @"MM月dd日 HH:mm";
static NSString *const DATE_STYLE_yyyyMMddHHmm_cn = @"yyyy年MM月dd日 HH:mm";

@interface DateUtils : NSObject


+ (NSString *)currentDateStringWithFormatterString:(NSString *)formatterString;

+ (NSDate *)dateForDateString:(NSString *)dateString withFormatterString:(NSString *)formatterString;

+ (NSString *)startDateStringForDateString:(NSString *)dateString;

+ (NSString *)endDateStringForDateString:(NSString *)dateString;

+ (NSString *)dateStringForDate:(NSDate *)date withFormatterString:(NSString *)formatterString;

+(NSDate *)dateWithDateString:(NSString *)dateString;

// 时间戳转换
+ (NSString *)transferTimeWithStampTime:(NSString *)stampTime;




@end
