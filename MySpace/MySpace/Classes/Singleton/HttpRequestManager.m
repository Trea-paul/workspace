//
//  HttpRequestManager.m
//  CYSDemo
//
//  Created by Paul on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "HttpRequestManager.h"


#include <sys/types.h>
#include <sys/sysctl.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include "JYBase64.h"
#import "MJExtension.h"

@interface AFHTTPSessionManager (Shared)
// 设置为单例
+ (instancetype)sharedManager;

@end

@implementation AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager
{
    static AFHTTPSessionManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [AFHTTPSessionManager manager];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return _instance;
}
@end

@implementation HttpRequestManager

// GET请求
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id, bool))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = URLString;
    if (!urlStr.length) return;
    
    // 加载本地文件时，格式为local://test.json
    if ([urlStr hasPrefix:@"local://"])
    {
        NSData *data = nil;
        NSString *localPath = [[NSBundle mainBundle] pathForResource:[urlStr substringFromIndex:6] ofType:nil];
        data = [[NSData alloc] initWithContentsOfFile:localPath];
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(responseObject, YES);
        
        return;
    }
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@", k_baseUrl, urlStr];
    
//    NSString *encodeUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *requestUrl = [NSURL URLWithString:encodeUrl];
    
    // 配置请求头
    NSMutableDictionary *headerDict = [self configHttpWithURL:URLString headerType:@"GET"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];

    
    [headerDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        
    }];

    
    // https证书设置
    /*
     AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
     policy.allowInvalidCertificates = YES;
     manager.securityPolicy  = policy;
     */
    
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"response: %@", responseObject);
        
        [self parseResponseObject:responseObject block:^(id response, BOOL result) {
            
            
            // success
            if (success) {
                success(response, result);
            }
            
            
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // failure
        if (failure) {
            [[HUDHepler sharedHelper] showMessage:@"无法连接到服务器，请稍后重试"];
            failure(error);
        }
    }];
}

// POST请求
+ (void)POST:(NSString *)URLString parameters:(id)parameters
     success:(void (^)(id, BOOL success))success
     failure:(void (^)(NSError *))failure {
    
    NSString *urlStr = URLString;
    if (!urlStr.length) return;
    
    // 加载本地文件时，格式为local://test.json
    if ([urlStr hasPrefix:@"local://"])
    {
        NSData *data = nil;
        NSString *localPath = [[NSBundle mainBundle] pathForResource:[urlStr substringFromIndex:6] ofType:nil];
        data = [[NSData alloc] initWithContentsOfFile:localPath];
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(responseObject, YES);
        
        return;
    }
    
    DLog(@"参数 %@",parameters);
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@", k_baseUrl, urlStr];
    
    // 配置请求头
    NSMutableDictionary *headerDict = [self configHttpWithURL:URLString headerType:@"POST"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [headerDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];

    }];
    
    //  https证书设置
    /*
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    policy.allowInvalidCertificates = YES;
    manager.securityPolicy  = policy;
    */
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        DLog(@"response: %@", responseObject);
        [self parseResponseObject:responseObject block:^(id response, BOOL result) {

            // success
            if (success) {
                success(response, result);
            }
            
        }];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            [[HUDHepler sharedHelper] showMessage:@"无法连接到服务器，请稍后重试"];
            failure(error);
        }
    }];
}

// POST请求 上传数据
+ (void)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id, BOOL success))success failure:(void (^)(NSError *))failure
{
    NSString *urlStr = URLString;
    if (!urlStr.length) return;
    
    // 加载本地文件时，格式为local://test.json
    if ([urlStr hasPrefix:@"local://"])
    {
        NSData *data = nil;
        NSString *localPath = [[NSBundle mainBundle] pathForResource:[urlStr substringFromIndex:6] ofType:nil];
        data = [[NSData alloc] initWithContentsOfFile:localPath];
        
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(responseObject, YES);
        
        return;
    }
    
    NSString *url;
    
    url = [NSString stringWithFormat:@"%@%@", k_baseUrl, urlStr];
    
    // 配置请求头
    NSMutableDictionary *headerDict = [self configHttpWithURL:URLString headerType:@"POST"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [headerDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        
    }];
    
    //  https证书设置
    /*
     AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
     policy.allowInvalidCertificates = YES;
     manager.securityPolicy  = policy;
     */
    
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         DLog(@"response: %@", responseObject);
        
        [self parseResponseObject:responseObject block:^(id response, BOOL result) {
            
            if (success) {
                success(response, result);
            }
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            [[HUDHepler sharedHelper] showMessage:@"无法连接到服务器，请稍后重试"];
            failure(error);
        }
    }];
    
    
}


// 配置HTTP
+ (NSMutableDictionary *)configHttpWithURL:(NSString *)URLStr headerType:(NSString *)headerType
{
//    NSString *url;
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    
    
    SystemInfoUtils *systemInfo = [[SystemInfoUtils alloc] init];
    NSString *userAgent = [NSString stringWithFormat:@"%@ %@ %@ %@",[systemInfo devicePlatform], [systemInfo IOSVersion], [systemInfo carrierName], [systemInfo netWorkType]];
    
    if ([kUserDefault objectForKey:@"token"] != nil && [URLStr rangeOfString:@"protected"].location == NSNotFound)
    {
        // Token 表示已登录状态
//        NSString *ContentDispositionstr = [NSString stringWithFormat:@"form-data;name=%@", @"\"user-info\""];
        NSString *ContentDispositionstr = @"form-data;name=\"user-info\"";
        NSString *token = [NSString stringWithFormat:@"CYSTOKEN %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"token"]];
        NSMutableDictionary *headerDic= [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"application/json; charset=UTF-8", @"Content-Type",
                                         ContentDispositionstr, @"Content-Disposition",
                                         @"8bit"   , @"Content-Transfer-Encoding",
                                         token     , @"Authorization",
                                         userAgent , @"User-Agent",
                                         @"gzip"   , @"Accept-Encoding",
                                         nil];
        
        header = headerDic;
        
    }
    else if([URLStr rangeOfString:@"protected"].location != NSNotFound)
    {
        // 私密接口需要Base64加密
        NSString *subhstr = URLStr;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE','dd' 'MMM' 'yyyy HH':'mm':'ss z"];
        
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *hmacString = [NSString stringWithFormat:@"%@:/%@:%@", headerType, subhstr, datestr];
        
        NSString *auth =  [NSString stringWithFormat:@"CYSHMAC ios3_3:%@",
                           [self hmacsMD5:hmacString key:@"393fccd4d8de3868b73f0630edf65f2e"]];
        
        NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          datestr  , @"Date",
                                          auth     , @"Authorization",
                                          userAgent, @"User-Agent",
                                          @"gzip"  , @"Accept-Encoding", nil];
        
        header = headerDic;
    }
    
    return header;
}


+ (NSString *)hmacsMD5:(NSString *)text key:(NSString *)secret {
    
    secret=@"393fccd4d8de3868b73f0630edf65f2e";
    
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgMD5, [secretData bytes], [secretData length], [clearTextData bytes],[clearTextData length], result);
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, CC_MD5_DIGEST_LENGTH, base64Result, &theResultLength,YES);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    return base64EncodedResult;
}

// 解析返回数据
+ (void)parseResponseObject:(id)responseObject block:(void(^)(id response, BOOL result))block
{
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *responseValue = responseObject;
        
        if ([[responseValue valueForKey:@"code"] integerValue] == 2000) {
            
            if (block) {
                block([responseValue valueForKey:@"result"], YES);
            }
            
        }
        else
        {
            DLog(@"请求错误 code %@ desc %@", [responseValue valueForKey:@"code"], [responseValue valueForKey:@"desc"]);
            NSString *error = [NSString stringWithFormat:@"请求错误 code %@ desc %@", [responseValue valueForKey:@"code"], [responseValue valueForKey:@"desc"]];
            
            [[HUDHepler sharedHelper] showMessage:error];
            if (block) {
                block(nil, NO);
            }
        }
    }
    else
    {
        if (block) {
            block(nil,NO);
        }
    }

}


+ (void)cancelAllRequests
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    [manager.operationQueue cancelAllOperations];
}

@end
