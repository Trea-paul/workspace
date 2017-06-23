//
//  HUDHepler.h
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//  一次只能显示一个HUD

#import <Foundation/Foundation.h>

@class MBProgressHUD;

@interface HUDHepler : NSObject

+ (instancetype)sharedHelper;


/**
 * 默认加载到KeyWindow
 * UIView 指定加载到哪个View
 */


- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message
             inView:(UIView *)view;

- (void)showMessage:(NSString *)message
      detailMessage:(NSString *)detailMessage;
- (void)showMessage:(NSString *)message
      detailMessage:(NSString *)detailMessage
             inView:(UIView *)view;

- (void)showLoading;
- (void)showLoading:(NSString *)loading
             inView:(UIView *)view;

- (void)showError;
- (void)showError:(NSString *)error
           inView:(UIView *)view;

- (void)showSuccess;
- (void)showSuccess:(NSString *)success
             inView:(UIView *)view;

- (void)hideHUD;
- (void)hideHUDInView:(UIView *)view;
- (void)hideHUDInView:(UIView *)view afterDelay:(NSTimeInterval)delay;
- (void)hideHUDAfterDelay:(NSTimeInterval)delay withHUD:(MBProgressHUD *)HUD;


/**
 展示消息，并提供block回调，用于MBProgressHUD的定制化

 @param message 消息
 @param detailMessage 子消息
 @param view 展示框
 @param progressHUD 当前HUD
 */
- (void)showMessage:(NSString *)message
      detailMessage:(NSString *)detailMessage
             inView:(UIView *)view
          customizeHUD:(void(^)(MBProgressHUD * progressHUD))progressHUD;



@end
