//
//  JSONHelper.h
//  CYSDemo
//
//  Created by Paul on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//  处理数据转换

#import <Foundation/Foundation.h>

@class BaseModel;

@interface JSONHelper : NSObject

+ (instancetype)sharedHelper;


/**
 将返回的JSON数据转换成模型 使用MJExtension

 @param responseObject 返回数据
 @param modelClass 模型类
 */
- (void)parseJSONResponseData:(id)responseObject inModelClass:(BaseModel *)modelClass;

@end
