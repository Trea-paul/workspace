//
//  DateUtils.m
//  CYSDemo
//
//  Created by Paul on 2017/5/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "DateUtils.h"
#import "NSDate+MJ.h"

@implementation DateUtils

+ (NSString *)currentDateStringWithFormatterString:(NSString *)formatterString
{
    NSDate* today = [NSDate date];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
//    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:[[LanguagesManager sharedInstance] currentLanguage]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = formatterString;
    NSString* dateString = [dateFormatter stringFromDate:today];
    return dateString;
}

+ (NSString *)transferTimeWithStampTime:(NSString *)stampTime
{
    NSString *str= [stampTime copy];//时间戳
    
//    NSString *str = @"1497838453";
    
    NSTimeInterval time = [str doubleValue]; //因为时差问题要加8小时 == 28800 sec  ??
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // 今天、明天、月日
    if ([detaildate isToday]) {
        
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"今天%@",DATE_STYLE_HHmm]];
    } else if ([detaildate isTomorrow]){
        
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"明天%@",DATE_STYLE_HHmm]];
    } else {
        
        [dateFormatter setDateFormat:DATE_STYLE_MMddHHmm];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

+ (NSDate *)dateForDateString:(NSString *)dateString withFormatterString:(NSString *)formatterString
{
    if (!dateString || !dateString.length)
    {
        return nil;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = formatterString;
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)startDateStringForDateString:(NSString *)dateString
{
    if (!dateString || !dateString.length)
    {
        return nil;
    }
    
    NSString *startDateString = nil;
    NSRange range = [dateString rangeOfString:@"~"];
    if (range.location != NSNotFound && range.location > 0)
    {
        startDateString = [dateString substringToIndex:range.location];
    }
//    return [StringUtility absoluteString:startDateString];
    
    return startDateString;
}

+ (NSString *)endDateStringForDateString:(NSString *)dateString
{
    if (!dateString || !dateString.length)
    {
        return nil;
    }
    
    NSString *endDateString = nil;
    NSRange range = [dateString rangeOfString:@"~"];
    if (range.location != NSNotFound && range.location < dateString.length - 2)
    {
        endDateString = [dateString substringFromIndex:range.location + 1];
        NSRange numberStartRange = [endDateString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
        if (numberStartRange.location != NSNotFound)
        {
            endDateString = [endDateString substringFromIndex:numberStartRange.location];
        }
        else
        {
            endDateString = nil;
        }
    }
    return endDateString;
}

+ (NSString *)dateStringForDate:(NSDate *)date withFormatterString:(NSString *)formatterString
{
    if (!date)
    {
        return nil;
    }
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = formatterString;
    return [dateFormatter stringFromDate:date];
}

/**
 *  会根据时间字符串来推断时间风格，仅适用于yyyy-MM-dd +- HH:mm:ss.SSS风格时间字符串
 *
 *  @param dateString <#dateString description#>
 *
 *  @return <#return value description#>
 */
+(NSDate *)dateWithDateString:(NSString *)dateString
{
    NSMutableString *dateFormaterString = [NSMutableString stringWithString:@"yyyy-MM-dd"];
    if ([dateString containsString:@":"])
    {
        if ([dateString containsString:@"."])
        {
            [dateFormaterString appendString:@" "];
            [dateFormaterString appendString:@"HH:mm:ss.SSS"];
        }else
        {
            [dateFormaterString appendString:@" "];
            [dateFormaterString appendString:@"HH:mm"];
        }
    }
    
    return [self dateForDateString:dateString withFormatterString:dateFormaterString];
}




@end
