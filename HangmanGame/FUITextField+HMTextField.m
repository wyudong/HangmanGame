//
//  FUITextField+HMTextField.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "FUITextField+HMTextField.h"

@implementation FUITextField (HMTextField)

- (void)drawTextField
{
    self.font = [UIFont flatFontOfSize:16];
    self.backgroundColor = [UIColor clearColor];
    self.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.textFieldColor = [UIColor whiteColor];
    self.borderColor = [UIColor turquoiseColor];
    self.borderWidth = 2.0f;
    self.cornerRadius = 3.0f;
}

@end
