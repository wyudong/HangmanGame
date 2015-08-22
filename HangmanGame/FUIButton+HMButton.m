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
    self.buttonColor = [UIColor cloudsColor];
    self.shadowColor = [UIColor silverColor];
    self.shadowHeight = 3.0f;
    self.cornerRadius = 6.0f;
    self.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    
    [self setTitleColor:[UIColor wetAsphaltColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor wetAsphaltColor] forState:UIControlStateHighlighted];
}

- (void)highlightKeyboardButton:(BOOL)highlighted
{
    if (highlighted) {
        self.buttonColor = [UIColor wetAsphaltColor];
        self.shadowColor = [UIColor midnightBlueColor];
        [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    } else {
        self.buttonColor = [UIColor cloudsColor];
        self.shadowColor = [UIColor silverColor];
        [self setTitleColor:[UIColor wetAsphaltColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor wetAsphaltColor] forState:UIControlStateHighlighted];
    }
}

@end
