//
//  WelcomeViewController
//  HangmanGame
//
//  Created by wyudong on 15/8/18.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "RESTfulAPIManager.h"
#import "FUIButton+GameButton.h"
#import "FUITextField+GameTextField.h"

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

    [[RESTfulAPIManager sharedInstance] startGameWithPlayerId:self.playerIdTextFiled.text
                                            completionHandler:^(NSString *message, NSError *error) {
         if ([message isEqualToString:@"THE GAME IS ON"]) {
             NSLog(@"sessionId: %@", [RESTfulAPIManager sharedInstance].sessionId);
         } else if ([message isEqualToString:@"Player does not exist"]){
             NSLog(@"Please check your ID and try again");
         } else {
             NSLog(@"There occurs an error when starting the game. Please Try again later.");
         }
     }];
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
    return NO;
}

@end
