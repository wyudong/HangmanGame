//
//  HMHeader.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "HMHeader.h"

@implementation HMHeader

NSString *const kSessionId = @"sessionId";
NSString *const kMessage = @"message";
NSString *const kData = @"data";
NSString *const kNumberOfWordsToGuess = @"numberOfWordsToGuess";
NSString *const kNumberOfGuessAllowedForEachWord = @"numberOfGuessAllowedForEachWord";
NSString *const kWord = @"word";
NSString *const kTotalWordCount = @"totalWordCount";
NSString *const kWrongGuessCountOfCurrentWord = @"wrongGuessCountOfCurrentWord";
NSString *const kCorrectWordCount = @"correctWordCount";
NSString *const kTotalWrongGuessCount = @"totalWrongGuessCount";
NSString *const kScore = @"score";
NSInteger const kGetWord = 1;
NSInteger const kGuessWord = 2;

@end
