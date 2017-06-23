//
//  HttpRequestManager.h
//  CYSDemo
//
//  Created by Paul on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequestManager : NSObject

/**
 *  GET请求
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void(^)(id response, BOOL success))success failure:(void(^)(NSError *error))failure;

/**
 *  POST请求
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void(^)(id response, BOOL success))success failure:(void(^)(NSError *error))failure;

/**
 *  POST请求 上传数据
 */
+ (void)POST:(NSString *)URLString
          parameters:(id)parameters
        constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
             success:(void (^)(id response, BOOL success))success
             failure:(void (^)(NSError *error))failure;

+ (void)cancelAllRequests;



@end
