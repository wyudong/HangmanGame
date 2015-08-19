//
//  WelcomeViewController
//  HangmanGame
//
//  Created by wyudong on 15/8/18.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "WelcomeViewController.h"
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
    NSLog(@"new game");
}

- (void)clickContinueGameButton:(UIButton *)sender
{
    NSLog(@"continue game");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
