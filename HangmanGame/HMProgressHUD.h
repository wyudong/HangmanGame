//
//  HMProgressHUD.h
//  HangmanGame
//
//  Created by wyudong on 15/8/20.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface HMProgressHUD : MBProgressHUD

+ (void)showProgressHUDWithMessage:(NSString *)message view:(UIView *)view;
+ (void)hideProgressHUD:(UIView *)view;

@end
