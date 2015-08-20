//
//  FUIButton+HMButton.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "FUIButton+HMButton.h"

@implementation FUIButton (HMButton)

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

- (void)drawButtonWithTypeKeyboard
{
    self.buttonColor = [UIColor silverColor];
    self.shadowColor = [UIColor concreteColor];
    self.shadowHeight = 3.0f;
    self.cornerRadius = 6.0f;
    self.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    
    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)highlightKeyboardButton:(BOOL)highlighted
{
    if (highlighted) {
        self.buttonColor = [UIColor belizeHoleColor];
        self.shadowColor = [UIColor midnightBlueColor];
    } else {
        self.buttonColor = [UIColor silverColor];
        self.shadowColor = [UIColor concreteColor];
    }
}

@end
