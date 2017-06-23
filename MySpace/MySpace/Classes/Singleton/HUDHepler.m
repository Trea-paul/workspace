//
//  HUDHepler.m
//  CYSDemo
//
//  Created by Paul on 2017/5/10.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "HUDHepler.h"
#import "MBProgressHUD.h"


#define kDelayTimeInterval 1.5f

@implementation HUDHepler

+ (instancetype)sharedHelper
{
    static HUDHepler *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[HUDHepler alloc] init];
    });
    
    return helper;
}

#pragma mark - Message

- (void)showMessage:(NSString *)message
{
    [self showMessage:message inView:nil];
}

- (void)showMessage:(NSString *)message
             inView:(UIView *)view
{
    [self showMessage:message detailMessage:nil inView:view];
}

- (void)showMessage:(NSString *)message
      detailMessage:(NSString *)detailMessage
{
    [self showMessage:message detailMessage:detailMessage inView:nil];
}

- (void)showMessage:(NSString *)message
      detailMessage:(NSString *)detailMessage
             inView:(UIView *)view
{
    MBProgressHUD *hud = [self setupMessage:message detailMessage:detailMessage inView:view];
    
    [self hideHUDAfterDelay:kDelayTimeInterval withHUD:hud];
    
}

- (void)showMessage:(NSString *)message
      detailMessage:(NSString *)detailMessage
             inView:(UIView *)view
       customizeHUD:(void(^)(MBProgressHUD *progressHUD))progressHUD
{
    MBProgressHUD *hud = [self setupMessage:message detailMessage:detailMessage inView:view];
    
    progressHUD(hud);
    
    [self hideHUDAfterDelay:kDelayTimeInterval withHUD:hud];
}

- (MBProgressHUD *)setupMessage:(NSString *)message detailMessage:(NSString *)detailMessage inView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.label.text = message;
    
    if (detailMessage && detailMessage.length) {
        hud.detailsLabel.text = detailMessage;
    }
    
    // 模式
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

#pragma mark - Loading

- (void)showLoading
{
    [self showLoading:nil inView:nil];
}

- (void)showLoading:(NSString *)loading
             inView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    if (loading && loading.length) {
        hud.label.text = loading;
    }
    
    // 模式
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoom;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    ;
}

#pragma mark - Error

- (void)showError
{
    
}

- (void)showError:(NSString *)error
           inView:(UIView *)view
{
    
}

#pragma mark - Success

- (void)showSuccess
{
    
}

- (void)showSuccess:(NSString *)success
             inView:(UIView *)view
{
    
}

#pragma mark - hide

- (void)hideHUD
{
    [self hideHUDInView:nil];
}

- (void)hideHUDInView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    
}

- (void)hideHUDInView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
    
}

- (void)hideHUDAfterDelay:(NSTimeInterval)delay withHUD:(MBProgressHUD *)HUD
{
    [HUD hideAnimated:YES afterDelay:delay];

}

@end
