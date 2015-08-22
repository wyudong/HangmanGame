//
//  HMGameManager.m
//  HangmanGame
//
//  Created by wyudong on 15/8/22.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "HMGameManager.h"

@implementation HMGameManager

+ (HMGameManager *)sharedInstance
{
    static HMGameManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

@end
