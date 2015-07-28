//
//  AppDelegate.h
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Sinch/Sinch.h>
#import <SinchService/SinchService.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<SINService> sinch;
@property (strong, nonatomic) ACAccount *twitterAccount;

@end

