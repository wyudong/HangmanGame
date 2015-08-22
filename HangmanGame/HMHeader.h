//
//  HMHeader.h
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHeader : NSObject

extern NSString *const kSessionId;
extern NSString *const kPlayerId;
extern NSString *const kMessage;
extern NSString *const kData;
extern NSString *const kNumberOfWordsToGuess;
extern NSString *const kNumberOfGuessAllowedForEachWord;
extern NSString *const kWord;
extern NSString *const kTotalWordCount;
extern NSString *const kWrongGuessCountOfCurrentWord;
extern NSString *const kCorrectWordCount;
extern NSString *const kTotalWrongGuessCount;
extern NSString *const kScore;
extern NSInteger const kGetWord;
extern NSInteger const kGuessWord;

@end
