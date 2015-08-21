//
//  FUIAlertView+HMAlertView.m
//  HangmanGame
//
//  Created by wyudong on 15/8/21.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "FUIAlertView+HMAlertView.h"

@implementation FUIAlertView (HMAlertView)

- (void)drawAlertView
{
    self.titleLabel.textColor = [UIColor cloudsColor];
    self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    self.messageLabel.textColor = [UIColor cloudsColor];
    self.messageLabel.font = [UIFont flatFontOfSize:14];
    self.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    self.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    self.defaultButtonColor = [UIColor cloudsColor];
    self.defaultButtonShadowColor = [UIColor asbestosColor];
    self.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    self.defaultButtonTitleColor = [UIColor asbestosColor];
}

@end
