//
//  DetailViewController.m
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setCallFriend:(CFriend *)newCallFriend {
    if (_callFriend != newCallFriend) {
        _callFriend = newCallFriend;
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.callFriend) {
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AnswerAction:(id)sender {
}

- (IBAction)HangupAction:(id)sender {
}
@end
