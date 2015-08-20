//
//  FUIButton+HMButton.h
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"

@interface FUIButton (HMButton)

- (void)drawButtonWithTypeMenu;
- (void)drawButtonWithTypeKeyboard;
- (void)highlightKeyboardButton:(BOOL)highlighted;

@end
