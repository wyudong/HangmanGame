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
#import "HMGameManager.h"
#import "HMString.h"
#import "FUIButton+HMButton.h"
#import "FUITextField+HMTextField.h"
#import "FUIAlertView+HMAlertView.h"
#import "HMProgressHUD.h"
#import "HMWelcomeViewController.h"

@interface HMGuessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *guessingWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordMarginLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWordCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *chanceRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(FUIButton) NSArray *keyboardButtons;
@property (strong, nonatomic) NSString *guessingWord;   // from server
@property (strong, nonatomic) NSString *letterReadyForGuess;
@property (nonatomic) NSUInteger totalWordCount;
@property (nonatomic) NSUInteger correctWordCount;
@property (nonatomic) NSUInteger chanceRemaining;
@property (nonatomic) NSInteger score;
@property BOOL didGetAWord;
@property BOOL didGetScore;
@property NSInteger buttonToMeltIndex;

@end

@implementation HMGuessViewController

#pragma mark Initialize

- (void)setGuessingWord:(NSString *)guessingWord
{
    _guessingWord = guessingWord;
    HMString *word = [[HMString alloc] initWithNSString:self.guessingWord];
    NSString *displayingWord = [word convertToDisplayingFormat];
    self.guessingWordLabel.text = displayingWord;
}

- (void)setTotalWordCount:(NSUInteger)totalWordCount
{
    _totalWordCount = totalWordCount;
    self.totalWordCountLabel.text = [NSString stringWithFormat:@"#WORD  %ld/%ld" ,(unsigned long)self.totalWordCount, (unsigned long)[[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfWordsToGuess]];
}

- (void)setChanceRemaining:(NSUInteger)chanceRemaining
{
    _chanceRemaining = chanceRemaining;
    self.chanceRemainingLabel.text = [NSString stringWithFormat:@"#CHANCE  %ld", (unsigned long)self.chanceRemaining];
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"#SCORE  %ld", (long)self.score];
}

- (NSInteger)calculateChanceRemaining
{
    NSUInteger numberOfGuessAllowedForEachWord = [[NSUserDefaults standardUserDefaults] integerForKey:kNumberOfGuessAllowedForEachWord];
    NSUInteger wrongGuessCountOfCurrentWord = [[NSUserDefaults standardUserDefaults] integerForKey:kWrongGuessCountOfCurrentWord];

    return numberOfGuessAllowedForEachWord - wrongGuessCountOfCurrentWord;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FFF8F2"];
    
    // Labels
    self.totalWordCountLabel.font = [UIFont flatFontOfSize:16];
    self.totalWordCountLabel.textColor = [UIColor turquoiseColor];
    self.chanceRemainingLabel.font = [UIFont flatFontOfSize:16];
    self.chanceRemainingLabel.textColor = [UIColor turquoiseColor];
    self.scoreLabel.font = [UIFont flatFontOfSize:16];
    self.scoreLabel.textColor = [UIColor turquoiseColor];
    self.guessingWordLabel.font = [UIFont boldFlatFontOfSize:24];
    self.guessingWordLabel.textColor = [UIColor midnightBlueColor];
    self.guessingWordLabel.backgroundColor = [UIColor cloudsColor];
    
    // Margin around guessing word
    self.wordMarginLabel.layer.zPosition = -1.0;
    self.wordMarginLabel.backgroundColor = [UIColor cloudsColor];
    self.wordMarginLabel.clipsToBounds = YES;
    self.wordMarginLabel.layer.cornerRadius = 6.0f;
    
    // Draw keyboard
    self.buttonToMeltIndex = -1;
    for (FUIButton *button in self.keyboardButtons) {
        [button drawButtonWithTypeKeyboard];
    }

    // Load data from disk
    [self loadGuessingStatsAndScore];
    
    // Start fresh game
    if ([HMGameManager sharedInstance].isContinued == NO) {
        [self getWordAndScore];
    }
}

# pragma mark Get ready for guessing

- (void)getWordAndScore
{
    [self showGetReadyProgress];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId];
    
    // Two queues for requesting word and score
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("hangmangame.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    [[RESTfulAPIManager sharedInstance] requestWordWithSessionId:sessionId
                                               completionHandler:^(BOOL success, NSError *error) {
        self.didGetAWord = success ? YES : NO;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [[RESTfulAPIManager sharedInstance] getResultWithSessionId:sessionId
                                             completionHandler:^(BOOL success, NSError *error) {
        self.didGetScore = success ? YES : NO;
        dispatch_group_leave(group);
    }];
    
    // Get notification when requests completed
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HMProgressHUD hideProgressHUD:self.view];
            
            if (self.didGetAWord) {
                [self saveWord];
                [self saveWrongGuessCountOfCurrentWord];
                [self saveTotalWordCount];
                [self updateDisplayingWord];
                [self updateGuessingStats];
                
                if (self.didGetScore) {
                    [self updateScore];
                    [self saveScore];
                }
            } else {
                [self showGetWordAgainAlertWithTitle:@"Oops..." message:@"There occurs an error when receiving a word. Would you like to "];
            }
        });
    });
}

- (void)showGetReadyProgress
{
    NSUInteger round = [[NSUserDefaults standardUserDefaults] integerForKey:kTotalWordCount];
    
    if ([self calculateChanceRemaining] == 0) {
        [HMProgressHUD showProgressHUDWithMessage:@"Try harder next time!" view:self.view];
    } else if (round == 0) {
        [HMProgressHUD showProgressHUDWithMessage:@"Your first word is..." view:self.view];
    } else {
        [HMProgressHUD showProgressHUDWithMessage:@"Next word is..." view:self.view];
    }
}

- (void)showGetWordAgainAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"quit game"
                                                otherButtonTitles:@"try again", nil];
    
    alertView.tag = kGetWord;
    [alertView drawAlertView];
    [alertView show];
}

#pragma mark Keyboard actions

- (IBAction)touchKeyboardButton:(id)sender
{
    NSUInteger index = [self.keyboardButtons indexOfObject:sender];
    FUIButton *buttonToFreeze = (FUIButton *)sender;
    NSString *chosenLetter = buttonToFreeze.titleLabel.text;
    
    // Submit chosen letter
    if ([chosenLetter isEqualToString:@"√"] && self.letterReadyForGuess) {
        [self freezeButton:buttonToFreeze];
        [self meltButton:[self.keyboardButtons objectAtIndex:self.buttonToMeltIndex]];
        [self guess:self.letterReadyForGuess];
        self.buttonToMeltIndex = index;
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
            [self saveWord];
            [self saveWrongGuessCountOfCurrentWord];
            [self saveTotalWordCount];
            [self updateDisplayingWord];
            [self updateGuessingStats];
        
            HMString *word = [[HMString alloc] initWithNSString:self.guessingWord];
            
            if ([word isAllUncovered]) {        // Achieve the correct answer
                [self animateWordLabel:self.guessingWordLabel];
                [self getWordAndScore];
            } else if ([self calculateChanceRemaining] == 0) {      // Run out of chance
                [self getWordAndScore];
            }
            [self animateWordLabel:self.guessingWordLabel];
        } else {
            [self showGuessWordAgainAlertWithTitle:@"Oops..." message:@"There occurs an error when guessing the word. Would you like to "];
        }
    }];
}

- (void)showGuessWordAgainAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"quit game"
                                                otherButtonTitles:@"guess again", nil];
    
    alertView.tag = kGuessWord;
    [alertView drawAlertView];
    [alertView show];
}

#pragma mark Game stats

- (void)loadGuessingStatsAndScore
{
    self.totalWordCount = [[NSUserDefaults standardUserDefaults] integerForKey:kTotalWordCount];
    self.chanceRemaining = [self calculateChanceRemaining];
    self.score = [[NSUserDefaults standardUserDefaults] integerForKey:kScore];
    
    NSString *savedWord = [[NSUserDefaults standardUserDefaults] objectForKey:kWord];
    HMString *word = [[HMString alloc] initWithNSString:savedWord];
    NSString *displayingWord = [word convertToDisplayingFormat];
    self.guessingWordLabel.text = displayingWord;
}

- (void)updateDisplayingWord
{
    self.guessingWord = [RESTfulAPIManager sharedInstance].word;
}

- (void)updateGuessingStats
{
    self.totalWordCount = [RESTfulAPIManager sharedInstance].totalWordCount;
    self.chanceRemaining = [self calculateChanceRemaining];
}

- (void)updateScore
{
    self.score = [RESTfulAPIManager sharedInstance].score;
}

#pragma mark Quit game

- (void)submitResult
{
    [HMProgressHUD showProgressHUDWithMessage:@"Connecting..." view:self.view];
    
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionId];
    [[RESTfulAPIManager sharedInstance]submitResultWithSessionId:sessionId completionHandler:^(BOOL success, NSError *error) {
        [HMProgressHUD hideProgressHUD:self.view];
        
        self.totalWordCount = [RESTfulAPIManager sharedInstance].totalWordCount;
        self.correctWordCount = [RESTfulAPIManager sharedInstance].correctWordCount;
        self.score = [RESTfulAPIManager sharedInstance].score;
        
        if (success) {
            NSString *message = [NSString stringWithFormat:@"You guessed %ld out of %ld words correctly. The final score is %ld.", self.correctWordCount, self.totalWordCount, self.score];
            [self showSubmitSuccessAlertWithTitle:@"High five!" message:message];
        } else {
            [self showSubmitResultFailAlertWithTitle:@"Oops..." message:@"There occurs an error when submitting the result. Please try again later."];
        }
    }];

}

- (IBAction)touchPowerOffButton:(id)sender
{
    NSLog(@"click power off");
    
    [self showQuitGameAlertWithTitle:@"Yo" message:@"Are you going to"];
}

- (void)showQuitGameAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"just test this button"
                                                otherButtonTitles:@"submit result", @"restart game", nil];
    
    alertView.tag = kQuitGame;
    [alertView drawAlertView];
    [alertView show];
}

- (void)showSubmitSuccessAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"High five"
                                                otherButtonTitles:nil];
    
    alertView.tag = kSubmitSuccess;
    [alertView drawAlertView];
    [alertView show];
}

- (void)showSubmitResultFailAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    
    [alertView drawAlertView];
    [alertView show];
}

#pragma mark Alert view buttons

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kGetWord) {
        if (buttonIndex == 0) {
            NSLog(@"click quit");
            [self quitToMenu];
        } else if (buttonIndex == 1) {
            NSLog(@"click try agin");
            [self getWordAndScore];
        }
    } else if (alertView.tag == kGuessWord) {
        if (buttonIndex == 0) {
            NSLog(@"click quit");
            [self quitToMenu];
        }
    } else if (alertView.tag == kQuitGame) {
        if (buttonIndex == 1) {
            NSLog(@"click submit result");
            [self submitResult];
        } else if (buttonIndex == 2) {
            NSLog(@"click restart");
            [self resetPlayerId];
            [self quitToMenu];
        }
    } else if (alertView.tag == kSubmitSuccess) {
        if (buttonIndex == 0) {
            NSLog(@"high five");
            [self resetPlayerId];
            [self quitToMenu];
        }
    }
}

- (void)quitToMenu
{
    HMWelcomeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HMWelcomeViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)resetPlayerId
{
    [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:kPlayerId];
}

#pragma mark Animation

- (void)animateWordLabel:(UILabel *)label
{
    CGFloat offset = 20.0;
    CGFloat duration = 1.0;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setDuration:duration];
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:20];
    int infinitySec = 10;
    while (offset > 0.01) {
        [keys addObject:[NSValue valueWithCGPoint:CGPointMake(label.center.x - offset, label.center.y)]];
        offset /= 2.0;
        [keys addObject:[NSValue valueWithCGPoint:CGPointMake(label.center.x + offset, label.center.y)]];
        offset /= 2.0;
        infinitySec--;
        if (infinitySec <= 0) {
            break;
        }
    }
    
    animation.values = keys;
    [label.layer addAnimation:animation forKey:@"position"];
}

#pragma mark Save data to disk

- (void)saveTotalWordCount
{
    [[NSUserDefaults standardUserDefaults] setInteger:[RESTfulAPIManager sharedInstance].totalWordCount forKey:kTotalWordCount];
}

- (void)saveWrongGuessCountOfCurrentWord
{
    [[NSUserDefaults standardUserDefaults] setInteger:[RESTfulAPIManager sharedInstance].wrongGuessCountOfCurrentWord forKey:kWrongGuessCountOfCurrentWord];
    NSLog(@"wrong guess: %lu", [[NSUserDefaults standardUserDefaults] integerForKey:kWrongGuessCountOfCurrentWord]);
}

- (void)saveScore
{
    [[NSUserDefaults standardUserDefaults] setInteger:[RESTfulAPIManager sharedInstance].score forKey:kScore];
}

- (void)saveWord
{
    [[NSUserDefaults standardUserDefaults] setObject:[RESTfulAPIManager sharedInstance].word forKey:kWord];
}

#pragma mark UI

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
