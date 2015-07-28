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

- (void)setCall:(id<SINCall>)call {
    _call = call;
    _call.delegate = self;
}

#pragma mark - Managing the detail item

- (void)setCallFriend:(CFriend *)newCallFriend {
    if (_callFriend != newCallFriend) {
        _callFriend = newCallFriend;
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.callFriend) {
        self.NameLabel.text = self.callFriend.name;
        self.UsernameLabel.text = [NSString stringWithFormat:@"@%@", self.callFriend.username];
        [self displayPictureForUrl:self.callFriend.picUrl];
        
        if ([self.call direction] == SINCallDirectionIncoming) {
            self.AnswerButton.hidden = NO;
            self.StatusLabel.text = @"";
        } else {
            self.AnswerButton.hidden = YES;
            self.StatusLabel.text = @"calling...";
        }
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
    [self.call answer];
}

- (IBAction)HangupAction:(id)sender {
    [self.call hangup];
}

- (void)callDidEstablish:(id<SINCall>)call {
    self.AnswerButton.hidden = YES;
    [self.HangupButton setTitle:@"Hangup" forState:UIControlStateNormal];
    self.StatusLabel.text = @"";
}

- (void)callDidEnd:(id<SINCall>)call {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) displayPictureForUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:imageData];
    CGSize size = img.size;
    CGRect rectFrame = CGRectMake(self.view.frame.size.width/2 - size.width * 0.75, 90, size.width * 1.5, size.height * 1.5);
    UIImageView* imgv = [[UIImageView alloc] initWithImage:img];
    imgv.frame = rectFrame;
    
    // make picture into circle
    imgv.layer.cornerRadius = size.width/2;
    imgv.layer.masksToBounds = YES;
    
    [self.view addSubview:imgv];
}

@end
