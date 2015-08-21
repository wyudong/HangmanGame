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
#import "HMWelcomeViewController.h"

@interface HMGuessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *guessingWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordMarginLabel;
@property (strong, nonatomic) IBOutletCollection(FUIButton) NSArray *keyboardButtons;
@property (strong, nonatomic) NSString *guessingWord;   // from the server
@property (strong, nonatomic) NSString *letterReadyForGuess;
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

- (NSInteger)remainingChance
{
    return [RESTfulAPIManager sharedInstance].numberOfGuessAllowedForEachWord - [RESTfulAPIManager sharedInstance].wrongGuessCountOfCurrentWord;
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

# pragma mark Get a word

- (void)giveMeAWord
{
    // Show connecting progress
    if ([self remainingChance] == 0) {
        [HMProgressHUD showProgressHUDWithMessage:@"Try harder next round" view:self.view];
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:kTotalWordCount] == 0) {
        [HMProgressHUD showProgressHUDWithMessage:@"Your first word is..." view:self.view];
    } else {
        [HMProgressHUD showProgressHUDWithMessage:@"Next word is..." view:self.view];
    }
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId];
    NSLog(@"sessionId: %@", sessionId);
    [[RESTfulAPIManager sharedInstance] requestWordWithSessionId:sessionId
                                               completionHandler:^(BOOL success, NSError *error) {
        [HMProgressHUD hideProgressHUD:self.view];
            
        if (success) {
            self.guessingWord = [RESTfulAPIManager sharedInstance].word;
            self.guessingWordLabel.backgroundColor = [UIColor whiteColor];
            NSLog(@"word: %@", self.guessingWord);
            
            self.totalWordCount = [RESTfulAPIManager sharedInstance].totalWordCount;
            [[NSUserDefaults standardUserDefaults] setInteger:self.totalWordCount forKey:kTotalWordCount];
        } else {
            // Try to request the word again
            [self showGiveMeAWordAlertWithTitle:@"Oops..." message:@"There occurs an error when receiving a word. Would you like to "];
        }
    }];
}

- (void)quitToMenu
{
    HMWelcomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HMWelcomeViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showGiveMeAWordAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"quit to the menu"
                                                otherButtonTitles:@"try again", nil];
    
    [alertView drawAlertView];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"click restart");
        [self quitToMenu];
    } else if (buttonIndex == 1) {
        NSLog(@"click try agin");
        [self giveMeAWord];
    }
}

#pragma mark Keyboard actions

- (IBAction)touchKeyboardButton:(id)sender
{
    NSUInteger index = [self.keyboardButtons indexOfObject:sender];
    
    FUIButton *buttonToFreeze = (FUIButton *)sender;
    NSString *chosenLetter = buttonToFreeze.titleLabel.text;
    
    // Submit chosen letter
    if ([chosenLetter isEqualToString:@"√"] && self.letterReadyForGuess) {
        [self meltButton:buttonToFreeze];
        [self meltButton:[self.keyboardButtons objectAtIndex:self.buttonToMeltIndex]];
        [self guess:self.letterReadyForGuess];
    } else {
        if (self.buttonToMeltIndex >= 0) {
            [self meltButton:[self.keyboardButtons objectAtIndex:self.buttonToMeltIndex]];
        }
        
        // Highlight current chosen letter button
        [self freezeButton:buttonToFreeze];
        self.buttonToMeltIndex = index;
        self.letterReadyForGuess = ([chosenLetter isEqualToString:@"√"]) ? nil : chosenLetter;
    }
    
    NSLog(@"touch: %@", chosenLetter);
}

- (void)freezeButton:(FUIButton *)button
{
    [button highlightKeyboardButton:YES];
}

- (void)meltButton:(FUIButton *)button
{
    [button highlightKeyboardButton:NO];
}

#pragma mark Make a guess

- (void)guess:(NSString *)letter
{
    NSLog(@"guess: %@", letter);
    
    // Clear chosen letter letter
    self.letterReadyForGuess = nil;
    
    [HMProgressHUD showProgressHUDWithMessage:@"Hmmm..." view:self.view];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId];
    [[RESTfulAPIManager sharedInstance]guessWordWithSessionId:sessionId
                                               guessingLetter:letter
                                            completionHandler:^(BOOL success, NSError *error) {
        [HMProgressHUD hideProgressHUD:self.view];
                                                
        if (success) {
            if ([self remainingChance] == 0) {
                [self giveMeAWord];
            }
            self.guessingWord = [RESTfulAPIManager sharedInstance].word;
        }
    }];
}

@end
