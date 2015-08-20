//
//  WelcomeViewController
//  HangmanGame
//
//  Created by wyudong on 15/8/18.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HangmanHeader.h"
#import "RESTfulAPIManager.h"
#import "FUIButton+GameButton.h"
#import "FUITextField+GameTextField.h"
#import "MBProgressHUD.h"
#import "GuessViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet FUITextField *playerIdTextFiled;
@property (weak, nonatomic) IBOutlet FUIButton *startGameButton;
@property (weak, nonatomic) IBOutlet FUIButton *continueGameButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FFF8F2"];
    
    self.gameTitle.font = [UIFont flatFontOfSize:24];
    self.gameTitle.textColor = [UIColor midnightBlueColor];
    
    [self.playerIdTextFiled drawTextField];
    self.playerIdTextFiled.delegate = self;
    
    [self.startGameButton drawButtonWithTypeMenu];
    [self.startGameButton addTarget:self action:@selector(clickStartGameButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.continueGameButton drawButtonWithTypeMenu];
    [self.continueGameButton addTarget:self action:@selector(clickContinueGameButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickStartGameButton:(UIButton *)sender
{
    NSLog(@"click new game");
    
    [self dismissKeyboard];
    
    // Show connecting progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Connecting...";
    hud.labelFont = [UIFont boldFlatFontOfSize:16];
    hud.labelColor = [UIColor cloudsColor];

    // Do HTTP request
    [[RESTfulAPIManager sharedInstance] startGameWithPlayerId:self.playerIdTextFiled.text
                                            completionHandler:^(NSString *message, NSError *error) {
        [hud hide:YES];
           
        // Show alert
        if ([message isEqualToString:@"THE GAME IS ON"]) {
            NSLog(@"sessionId: %@", [RESTfulAPIManager sharedInstance].sessionId);
            [[NSUserDefaults standardUserDefaults] setObject:[RESTfulAPIManager sharedInstance].sessionId forKey:kSessionId];
            GuessViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GuessViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        } else if ([message isEqualToString:@"Missing player id"]) {
            [self showStartGameAlertWithTitle:@"Oops!" message:@"Please fill your ID first."];
        } else if ([message isEqualToString:@"Player does not exist"]){
            [self showStartGameAlertWithTitle:@"Oops!" message:@"Please check your ID and try again."];
        } else {
            [self showStartGameAlertWithTitle:@"Oops!" message:@"There occurs an error when starting the game. Please Try again later."];
        }
    }];
}

- (void)showStartGameAlertWithTitle:(NSString *)title message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

- (void)clickContinueGameButton:(UIButton *)sender
{
    NSLog(@"click continue game");

    [self dismissKeyboard];
}

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
