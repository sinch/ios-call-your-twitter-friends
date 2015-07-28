//
//  LoginViewController.m
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "LoginViewController.h"
#import "MasterViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMaster"]) {
        [[segue destinationViewController] setTwitterAccount:sender];
    }
}


- (IBAction)ContinueAction:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                if (accounts.count > 0)
                {
                    ACAccount *twitterAccount = [accounts objectAtIndex:0];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"
                                                                        object:nil
                                                                      userInfo:@{@"userId" : twitterAccount.username}];
                    
                    
                    AppDelegate *SharedAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [SharedAppDelegate setTwitterAccount:twitterAccount];
                    
                    [self performSegueWithIdentifier:@"showMaster" sender:twitterAccount];
                    
                }
                else {
                    NSLog(@"no accounts");
                }
            } else {
                NSLog(@"No access granted");
            }
            
        });
    }];
}
@end
