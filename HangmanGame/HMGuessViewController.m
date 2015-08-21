//
//  HMGuessViewController.m
//  HangmanGame
//
//  Created by wyudong on 15/8/19.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HMGuessViewController.h"
#import "HMHeader.h"
#import "RESTfulAPIManager.h"
#import "FUIButton+HMButton.h"
#import "FUITextField+HMTextField.h"
#import "FUIAlertView+HMAlertView.h"
#import "HMProgressHUD.h"

@interface HMGuessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *guessingWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordMarginLabel;
@property (strong, nonatomic) IBOutletCollection(FUIButton) NSArray *keyboardButtons;
@property (strong, nonatomic) NSString *guessingWord;
@property NSInteger totalWordCount;
@property NSInteger buttonToMeltIndex;

@end

@implementation HMGuessViewController

#pragma mark Initialize

- (void)setGuessingWord:(NSString *)guessingWord
{
    _guessingWord = guessingWord;
    self.guessingWordLabel.text = self.guessingWord;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FFF8F2"];
    
    //
    self.wordMarginLabel.layer.zPosition = -1.0;
    self.wordMarginLabel.backgroundColor = [UIColor whiteColor];
    self.wordMarginLabel.clipsToBounds = YES;
    self.wordMarginLabel.layer.cornerRadius = 6.0f;
    
    // Draw keyboard
    self.buttonToMeltIndex = -1;
    for (FUIButton *button in self.keyboardButtons) {
        [button drawButtonWithTypeKeyboard];
    }
    
    [self giveMeAWord];
}

# pragma mark Get word

- (void)giveMeAWord
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kTotalWordCount] == 0) {
        [HMProgressHUD showProgressHUDWithMessage:@"Your first word is..." view:self.view];
    } else {
        [HMProgressHUD showProgressHUDWithMessage:@"Next word is..." view:self.view];
    }
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId];
    NSLog(@"sessionId: %@", sessionId);
    [[RESTfulAPIManager sharedInstance] requestWordWithSessionId:sessionId
                                               completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [HMProgressHUD hideProgressHUD:self.view];
            
            self.guessingWord = [RESTfulAPIManager sharedInstance].word;
            self.guessingWordLabel.backgroundColor = [UIColor whiteColor];
            NSLog(@"word: %@", self.guessingWord);
            
            self.totalWordCount = [RESTfulAPIManager sharedInstance].totalWordCount;
            [[NSUserDefaults standardUserDefaults] setInteger:self.totalWordCount forKey:kTotalWordCount];
        } else {
            // Try to request the word again
            
        }
    }];
}

#pragma mark Guess word

- (IBAction)touchKeyboardButton:(id)sender
{
    NSUInteger index = [self.keyboardButtons indexOfObject:sender];
    NSLog(@"chosen button index: %lu", index);
    
    FUIButton *buttonToFreeze = (FUIButton *)sender;
    
    if (self.buttonToMeltIndex >= 0) {
        [self meltButton:[self.keyboardButtons objectAtIndex:self.buttonToMeltIndex]];
    }
    
    [self freezeButton:buttonToFreeze];
    self.buttonToMeltIndex = index;
    NSLog(@"touch: %@", buttonToFreeze.titleLabel.text);
}

- (void)freezeButton:(FUIButton *)button
{
    [button highlightKeyboardButton:YES];
}

- (void)meltButton:(FUIButton *)button
{
    [button highlightKeyboardButton:NO];
}

@end
