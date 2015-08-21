//
//  HMWelcomeViewController
//  HangmanGame
//
//  Created by wyudong on 15/8/18.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "HMWelcomeViewController.h"
#import "HMHeader.h"
#import "RESTfulAPIManager.h"
#import "FUIButton+HMButton.h"
#import "FUITextField+HMTextField.h"
#import "FUIAlertView+HMAlertView.h"
#import "HMProgressHUD.h"
#import "HMGuessViewController.h"

@interface HMWelcomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet FUITextField *playerIdTextFiled;
@property (weak, nonatomic) IBOutlet FUIButton *startGameButton;
@property (weak, nonatomic) IBOutlet FUIButton *continueGameButton;

@end

@implementation HMWelcomeViewController

#pragma mark Initialize

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FFF8F2"];
    
    self.gameTitle.font = [UIFont flatFontOfSize:24];
    self.gameTitle.textColor = [UIColor midnightBlueColor];
    
    [self.playerIdTextFiled drawTextField];
    self.playerIdTextFiled.delegate = self;
    
    [self.startGameButton drawButtonWithTypeMenu];
    [self.startGameButton addTarget:self action:@selector(touchStartGameButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.continueGameButton drawButtonWithTypeMenu];
    [self.continueGameButton addTarget:self action:@selector(touchContinueGameButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Start game

- (void)touchStartGameButton:(UIButton *)sender
{
    NSLog(@"click new game");
    
    [self dismissKeyboard];
    [self startGame];
}

- (void)startGame
{
    // Show connecting progress
    [HMProgressHUD showProgressHUDWithMessage:@"Connecting..." view:self.view];
    
    // Do HTTP request
    [[RESTfulAPIManager sharedInstance] startGameWithPlayerId:self.playerIdTextFiled.text
                                            completionHandler:^(NSString *message, NSError *error) {
        [HMProgressHUD hideProgressHUD:self.view];
                                                
        // Show alert
        if ([message isEqualToString:@"THE GAME IS ON"]) {
            // Save current session id
            NSLog(@"sessionId: %@", [RESTfulAPIManager sharedInstance].sessionId);
            [[NSUserDefaults standardUserDefaults] setObject:[RESTfulAPIManager sharedInstance].sessionId forKey:kSessionId];
            
            // Show next scene
            HMGuessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HMGuessViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        } else if ([message isEqualToString:@"Missing player id"]) {
            [self showStartGameAlertWithTitle:@"Oops!" message:@"Please fill your ID first."];
        } else if ([message isEqualToString:@"Player does not exist"]){
            [self showStartGameAlertWithTitle:@"Oops!" message:@"Please check your ID and try again."];
        } else {
            [self showStartGameAlertWithTitle:@"Oops..." message:@"There occurs an error when starting the game. Please check your connection and try again later."];
        }
    }];
}

- (void)showStartGameAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    
    [alertView drawAlertView];
    [alertView show];
}

#pragma mark Continue game

- (void)touchContinueGameButton:(UIButton *)sender
{
    NSLog(@"click continue game");

    [self dismissKeyboard];
    [self continueGame];
}

- (void)continueGame
{
    
}

#pragma mark Hide keyboard

- (void)dismissKeyboard
{
    [self.playerIdTextFiled resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
