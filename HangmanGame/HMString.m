//
//  HMString.m
//  HangmanGame
//
//  Created by wyudong on 15/8/21.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "HMString.h"

@interface HMString ()

@property (strong, nonatomic) NSString *stringContent;

@end

@implementation HMString

- (BOOL)isAllUncovered
{
    for (NSUInteger index = 0; index < self.stringContent.length; index++) {
        unichar aCharacter = [self.stringContent characterAtIndex:index];
        NSString *aString = [NSString stringWithCharacters:&aCharacter length:1];
        
        if ([aString isEqualToString:@"*"]) {
            return NO;
        }
    }
    return YES;
}

- (instancetype)initWithNSString:(NSString *)aString
{
    self.stringContent = aString;
    return self;
}

- (NSString *)convertToDisplayingFormat
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    for (NSUInteger index = 0; index < self.stringContent.length; index++) {
        unichar aCharacter = [self.stringContent characterAtIndex:index];
        NSString *aString = [NSString stringWithCharacters:&aCharacter length:1];
        
        if ([aString isEqualToString:@"*"]) {
            [mutableString appendFormat:@"%@ ", @"_"];
        } else {
            [mutableString appendFormat:@"%@ ", aString];
        }
    }
    NSRange aRange = NSMakeRange(mutableString.length - 1, 1);
    [mutableString deleteCharactersInRange:aRange];
    NSString *convertedString = [NSString stringWithString:mutableString];
    
    return convertedString;
}

@end
