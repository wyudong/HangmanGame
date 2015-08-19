//
//  WelcomeViewController
//  HangmanGame
//
//  Created by wyudong on 15/8/18.
//  Copyright (c) 2015年 wyudong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "FUIButton+GameButton.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet FUIButton *startGameButton;
@property (weak, nonatomic) IBOutlet FUIButton *continueGameButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromHexCode:@"FFF8F2"];
    
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

@end
