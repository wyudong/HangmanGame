//
//  HMGameManager.h
//  HangmanGame
//
//  Created by wyudong on 15/8/22.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGameManager : NSObject

+ (HMGameManager *)sharedInstance;

@property BOOL isContinued;

@end
