//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

static MBProgressHUD *g_pGlobalWaiting;
@interface MBProgressHUD (HM)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;


+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
+ (void)show:(NSString *)text view:(UIView *)view;
//zwqbgn
+ (void)showWaiting:(NSString*)message toView:(UIView*)pView;
+ (void)setWaitingTxt:(NSString*)pTxt;
+ (void)setWaitingDetailTxt:(NSString*)pTxt;
+ (void)closeWaiting;
//zwqend
@end
