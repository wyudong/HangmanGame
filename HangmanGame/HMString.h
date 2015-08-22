//
//  HMString.h
//  HangmanGame
//
//  Created by wyudong on 15/8/21.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMString : NSString

@property (readonly) BOOL isAllUncovered;

- (instancetype)initWithNSString:(NSString *)aString;
- (NSString *)convertToDisplayingFormat;

@end
