//
//  RESTfulAPIManager.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "RESTfulAPIManager.h"
#import "HMHeader.h"

#define URL_HOST @"https://strikingly-hangman.herokuapp.com/game/on"

@implementation RESTfulAPIManager

+ (RESTfulAPIManager *)sharedInstance
{
    static RESTfulAPIManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark Request

- (void)resetUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:kSessionId];
    [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:kPlayerId];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kTotalWordCount];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kNumberOfWordsToGuess];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kNumberOfGuessAllowedForEachWord];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kWrongGuessCountOfCurrentWord];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kScore];
    [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:kWord];
}

- (void)startGameWithPlayerId:(NSString *)idString
            completionHandler:(void (^)(NSString *, NSError *))handler
{
    [self resetUserDefaults];
    
    // URL
    NSString *urlString = URL_HOST;
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Headers
    NSString *type = @"application/json";
    NSString *method = @"POST";
    
    // Request body
    NSString *action = @"startGame";
    NSError *bodyError = nil;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:idString, @"playerId", action, @"action", nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&bodyError];
    NSString *requestString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"request body: %@", requestString);
    
    //Request init
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Request header setup
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    //Request option setup
    [request setHTTPMethod:method];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *parseError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"json: %@", jsonDictionary);
           
            if ([jsonDictionary isKindOfClass:[NSDictionary class]]) {
                self.message = [jsonDictionary objectForKey:kMessage];
                self.sessionId = [jsonDictionary objectForKey:kSessionId];
                NSDictionary *dataDictionary = [jsonDictionary objectForKey:kData];
                self.numberOfWordsToGuess = [[dataDictionary objectForKey:kNumberOfWordsToGuess] integerValue];
                self.numberOfGuessAllowedForEachWord = [[dataDictionary objectForKey:kNumberOfGuessAllowedForEachWord] integerValue];

                if (handler) {
                    handler(self.message, NULL);
                }
            } else if (handler) {
                handler(nil, parseError);
            }
        } else {
            if (handler) {
                handler(nil, connectionError);
            }
        }
    }];
}

- (void)requestWordWithSessionId:(NSString *)sessionId
               completionHandler:(void (^)(BOOL, NSError *))handler
{
    // URL
    NSString *urlString = URL_HOST;
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Headers
    NSString *type = @"application/json";
    NSString *method = @"POST";
    
    // Request body
    NSString *action = @"nextWord";
    NSError *bodyError = nil;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:sessionId, @"sessionId", action, @"action", nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&bodyError];
    NSString *requestString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"request body: %@", requestString);
    
    //Request init
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Request header setup
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    //Request option setup
    [request setHTTPMethod:method];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *parseError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"json: %@", jsonDictionary);
            
            if ([jsonDictionary isKindOfClass:[NSDictionary class]]) {
                self.sessionId = [jsonDictionary objectForKey:kSessionId];
                NSDictionary *dataDictionary = [jsonDictionary objectForKey:kData];
                self.word = [dataDictionary objectForKey:kWord];
                self.totalWordCount = [[dataDictionary objectForKey:kTotalWordCount] integerValue];
                self.wrongGuessCountOfCurrentWord = [[dataDictionary objectForKey:kWrongGuessCountOfCurrentWord] integerValue];
        
                if (handler) {
                    if ([self.sessionId isEqualToString:sessionId]) {
                        handler(YES, NULL);
                    } else {
                        handler(NO, NULL);
                    }
                }
            } else if (handler) {
                handler(NO, parseError);
            }
        } else {
            if (handler) {
                handler(NO, connectionError);
            }
        }
    }];
}

- (void)guessWordWithSessionId:(NSString *)sessionId
                guessingLetter:(NSString *)letter
             completionHandler:(void (^)(BOOL, NSError *))handler
{
    // URL
    NSString *urlString = URL_HOST;
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Headers
    NSString *type = @"application/json";
    NSString *method = @"POST";
    
    // Request body
    NSString *action = @"guessWord";
    NSError *bodyError = nil;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:sessionId, @"sessionId", action, @"action", letter, @"guess", nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&bodyError];
    NSString *requestString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"request body: %@", requestString);
    
    //Request init
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Request header setup
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    //Request option setup
    [request setHTTPMethod:method];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *parseError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"json: %@", jsonDictionary);
            
            if ([jsonDictionary isKindOfClass:[NSDictionary class]]) {
                self.sessionId = [jsonDictionary objectForKey:kSessionId];
                NSDictionary *dataDictionary = [jsonDictionary objectForKey:kData];
                self.word = [dataDictionary objectForKey:kWord];
                self.totalWordCount = [[dataDictionary objectForKey:kTotalWordCount] integerValue];
                self.wrongGuessCountOfCurrentWord = [[dataDictionary objectForKey:kWrongGuessCountOfCurrentWord] integerValue];
 
                if (handler) {
                    if ([self.sessionId isEqualToString:sessionId]) {
                        handler(YES, NULL);
                    } else {
                        handler(NO, NULL);
                    }
                }
            } else if (handler) {
                handler(NO, parseError);
            }
        } else {
            if (handler) {
                handler(NO, connectionError);
            }
        }
    }];
}

- (void)getResultWithSessionId:(NSString *)sessionId
             completionHandler:(void (^)(BOOL, NSError *))handler
{
    // URL
    NSString *urlString = URL_HOST;
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Headers
    NSString *type = @"application/json";
    NSString *method = @"POST";
    
    // Request body
    NSString *action = @"getResult";
    NSError *bodyError = nil;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:sessionId, @"sessionId", action, @"action", nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&bodyError];
    NSString *requestString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"request body: %@", requestString);
    
    //Request init
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //Request header setup
    [request setValue:type forHTTPHeaderField:@"Content-Type"];
    
    //Request option setup
    [request setHTTPMethod:method];
    [request setHTTPBody:body];
    [request setTimeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSError *parseError;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"json: %@", jsonDictionary);
            
            if ([jsonDictionary isKindOfClass:[NSDictionary class]]) {
                self.sessionId = [jsonDictionary objectForKey:kSessionId];
                NSDictionary *dataDictionary = [jsonDictionary objectForKey:kData];
                self.totalWordCount = [[dataDictionary objectForKey:kTotalWordCount] integerValue];
                self.correctWordCount = [[dataDictionary objectForKey:kCorrectWordCount] integerValue];
                self.totalWrongGuessCount = [[dataDictionary objectForKey:kTotalWrongGuessCount] integerValue];
                self.score = [[dataDictionary objectForKey:kScore] integerValue];
 
                if (handler) {
                    if ([self.sessionId isEqualToString:sessionId]) {
                        handler(YES, NULL);
                    } else {
                        handler(NO, NULL);
                    }
                }
            } else if (handler) {
                handler(NO, parseError);
            }
        } else {
            if (handler) {
                handler(NO, connectionError);
            }
        }
    }];    
}

@end
