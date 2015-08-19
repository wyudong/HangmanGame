//
//  FUIButton+GameButton.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "FUIButton+GameButton.h"

@implementation FUIButton (GameButton)

- (void)drawButtonWithTypeMenu
{
    self.buttonColor = [UIColor turquoiseColor];
    self.shadowColor = [UIColor greenSeaColor];
    self.shadowHeight = 3.0f;
    self.cornerRadius = 6.0f;
    self.titleLabel.font = [UIFont boldFlatFontOfSize:16];

    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

@end
