//
//  RESTfulAPIManager.h
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTfulAPIManager : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *word;
@property NSUInteger numberOfWordsToGuess;
@property NSUInteger numberOfGuessAllowedForEachWord;
@property NSUInteger totalWordCount;
@property NSUInteger wrongGuessCountOfCurrentWord;

+ (RESTfulAPIManager *)sharedInstance;
- (void)startGameWithPlayerId:(NSString *)idString
            completionHandler:(void (^)(NSString *message, NSError *error)) handler;
- (void)requestWordWithSessionId:(NSString *)sessionId
              completionHandler:(void (^)(BOOL success, NSError *error)) handler;

@end
