//
//  JYUserInfo.h
//  CYSDemo
//
//  Created by Paul on 2017/6/9.
//  Copyright © 2017年 Paul. All rights reserved.
//  全局属性，放在NSUserDefaults中

#import <Foundation/Foundation.h>

@class JYPatientInfo, JYAuditable;

@interface JYUserInfo : NSObject

+ (instancetype)sharedUserInfo;

@property (nonatomic, copy) NSString *isLogin;

@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *msisdn;    // 注册手机号

@property (nonatomic, strong) JYPatientInfo *patient_info;


@property (nonatomic, strong) NSMutableArray *service_pack;

@end


/**
 患者资料
 */
@interface JYPatientInfo : NSObject

@property (nonatomic, copy) NSString *account_balance;   // 账户余额

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *avatar;       // 头像

@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSString *date_created;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *open_id;

@property (nonatomic, copy) NSString *phone_number;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *user_id;     


@end


/**
 服务包
 */
@interface JYServicePack : NSObject

@property (nonatomic, copy) NSString *active_date;   // 激活时间(服务开始时间)

@property (nonatomic, copy) NSString *code;          // 兑换码

@property (nonatomic, copy) NSString *user_id;       //

@property (nonatomic, copy) NSString *exchange_expired_date;          //  兑换过期时间

@property (nonatomic, copy) NSString *health_service_pack_def_id;     //

@property (nonatomic, copy) NSString *health_service_pack_def_name;   // 服务包名称

@property (nonatomic, copy) NSString *id;                 //

@property (nonatomic, copy) NSString *is_activated;       //

@property (nonatomic, copy) NSString *is_delivered;       //

@property (nonatomic, copy) NSString *master_patient_id;  //

@property (nonatomic, copy) NSString *modify_by;          // 修改人

@property (nonatomic, copy) NSString *period_of_validity; // 服务时长

@property (nonatomic, copy) NSString *price;              //

@property (nonatomic, copy) NSString *properties;         //

@property (nonatomic, copy) NSString *service_expired_date;   // 过期剩余

@property (nonatomic, strong) JYAuditable *auditable;



@end


/**
 服务包明细
 */
@interface JYAuditable : NSObject

@property (nonatomic, copy) NSString *created_by;         //

@property (nonatomic, copy) NSString *date_created;       //

@property (nonatomic, copy) NSString *date_updated;       //

@property (nonatomic, copy) NSString *updated_by;         //





@end
