//
//  HMGuessViewController.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "HMGuessViewController.h"
#import "HMHeader.h"
#import "RESTfulAPIManager.h"
#import "FUIButton+HMButton.h"
#import "FUITextField+HMTextField.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface HMGuessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *guessingWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordMarginLabel;
@property (nonatomic, strong) NSString *guessingWord;

@end

@implementation HMGuessViewController

- (void)setGuessingWord:(NSString *)guessingWord
{
    _guessingWord = guessingWord;
    self.guessingWordLabel.text = self.guessingWord;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FFF8F2"];
    self.wordMarginLabel.layer.zPosition = -1.0;
    self.wordMarginLabel.backgroundColor = [UIColor whiteColor];
    self.wordMarginLabel.clipsToBounds = YES;
    self.wordMarginLabel.layer.cornerRadius = 6.0f;
    
    [self giveMeAWord];
}

- (void)giveMeAWord
{
    // Show connecting progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Your fisrt word is...";
    hud.labelFont = [UIFont boldFlatFontOfSize:16];
    hud.labelColor = [UIColor cloudsColor];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId];
    NSLog(@"sessionId: %@", sessionId);
    [[RESTfulAPIManager sharedInstance] requestWordWithSessionId:sessionId
                                               completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [hud hide:YES];
            self.guessingWord = [RESTfulAPIManager sharedInstance].word;
            self.guessingWordLabel.backgroundColor = [UIColor whiteColor];
            NSLog(@"word: %@", self.guessingWord);
        } else {
#warning request word error
        }
    }];
}

@end
