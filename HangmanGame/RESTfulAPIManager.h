//
//  RESTfulAPIManager.h
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTfulAPIManager : NSObject

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) NSString *word;
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
