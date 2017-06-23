//
//  StringUtils.m
//  CYSDemo
//
//  Created by Paul on 2017/5/15.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (BOOL)isValidMobilePhoneNum:(NSString *)phoneNum
{
    /**
     * 手机号码
     * 通用：^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    
    NSString *MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString *CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestCU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestCT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestMobile evaluateWithObject:phoneNum]
         || [regextestCM evaluateWithObject:phoneNum]
         || [regextestCU evaluateWithObject:phoneNum]
         || [regextestCT evaluateWithObject:phoneNum]))
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}


+ (NSArray *)separatedString:(NSString *)string byComponent:(NSString *)component
{
    NSArray *array = [string componentsSeparatedByString:component];
    return array;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:font}
                             context:nil].size;
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font limitSize:(CGSize)limitSize
{
    return [string boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName:font}
                                context:nil].size;
}



@end
