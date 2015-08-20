//
//  HMProgressHUD.m
//  HangmanGame
//
//  Created by wyudong on 15/8/20.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "HMProgressHUD.h"
#import "FlatUIKit.h"

@implementation HMProgressHUD

+ (void)showProgressHUDWithMessage:(NSString *)message view:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = message;
    hud.labelFont = [UIFont boldFlatFontOfSize:16];
    hud.labelColor = [UIColor cloudsColor];
}

+ (void)hideProgressHUD:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
