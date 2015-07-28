//
//  DetailViewController.h
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFriend.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CFriend *callFriend;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *AnswerButton;
@property (weak, nonatomic) IBOutlet UIButton *HangupButton;

- (IBAction)AnswerAction:(id)sender;
- (IBAction)HangupAction:(id)sender;

@end

