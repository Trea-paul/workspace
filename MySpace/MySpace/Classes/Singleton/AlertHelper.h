//
//  AlertHelper.h
//  CYSDemo
//
//  Created by Paul on 2017/5/17.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 弹出框业务
 */
typedef NS_ENUM(NSInteger, ActionSheetType) {
    ActionSheetTypeGender,                   // 选择性别，男 女
    ActionSheetTypePhoto                // 照片相关
//    ActionSheetType,                   // 性别
//    ActionSheetType,                      // 描述
//    ActionSheetType                     // 选择
};

@protocol AlertHelperDelegate <NSObject>

- (void)alertViewdidFinishPickingMediaWithImage:(UIImage *)image tempPath:(NSString *)path;

@end


@interface AlertHelper : NSObject



+ (instancetype)sharedAlertHelper;

@property (nonatomic, weak) id<AlertHelperDelegate>delegate;

// 使用Block返回接收事件 以及选择事件

/**
 Alert 弹出框

 @param type <#type description#>
 @param controller alertController
 @param alertActions 返回接收
 */
- (void)alertActionSheetWithType:(ActionSheetType)type
                     inController:(UIViewController *)controller
                     alertActions:(void(^)(UIAlertController *alertController))alertActions;

- (void)alertActionWithType:(UIAlertControllerStyle)type
                      title:(NSString *)title
                    message:(NSString *)message
                    inController:(UIViewController *)controller
                    alertActions:(void(^)(UIAlertController *alertController))alertActions;


@end
