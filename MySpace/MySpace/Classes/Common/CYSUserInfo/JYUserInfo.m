//
//  JYUserInfo.m
//  CYSDemo
//
//  Created by Paul on 2017/6/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "JYUserInfo.h"

@implementation JYUserInfo

+ (instancetype)sharedUserInfo
{
    JYUserInfo *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (userInfo) {
        return userInfo;
    } else {
        return nil;
    }
    
}

- (NSMutableArray *)service_pack
{
    if (!_service_pack) {
        _service_pack = [NSMutableArray array];
    }
    return _service_pack;
}



@end

@implementation JYPatientInfo



@end

@implementation JYServicePack



@end
