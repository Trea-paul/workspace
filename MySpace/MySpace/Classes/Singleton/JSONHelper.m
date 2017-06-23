//
//  JSONHelper.m
//  CYSDemo
//
//  Created by Paul on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JSONHelper.h"
#import "MJExtension.h"
#import "BaseModel.h"

@implementation JSONHelper

+ (instancetype)sharedHelper
{
    static JSONHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[JSONHelper alloc] init];
    });
    return helper;
}

- (void)parseJSONResponseData:(id)responseObject inModelClass:(BaseModel *)modelClass
{
    [modelClass mj_setKeyValues:responseObject];
    
}




@end
