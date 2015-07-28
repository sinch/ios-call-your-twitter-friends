//
//  AppDelegate.m
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <Social/Social.h>
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "CFriend.h"

@interface AppDelegate () <SINServiceDelegate, SINCallClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    id config = [SinchService configWithApplicationKey:@"application-key"
                                     applicationSecret:@"application-secret"
                                       environmentHost:@"sandbox.sinch.com"];
    
    id<SINService> sinch = [SinchService serviceWithConfig:config];
    sinch.delegate = self;
    sinch.callClient.delegate = self;
    
    void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
        [sinch logInUserWithId:userId];
    };
    
    self.sinch = sinch;
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UserDidLoginNotification"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) { onUserDidLogin(note.userInfo[@"userId"]); }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    UIViewController *top = self.window.rootViewController;
    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/lookup.json?"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", [call remoteUserId]], @"screen_name", nil]];
    [twitterInfoRequest setAccount:self.twitterAccount];
    [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([urlResponse statusCode] == 429) {
                NSLog(@"Rate limit reached");
                return;
            }
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                return;
            }
            if (responseData) {
                NSError *error = nil;
                NSDictionary *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                
                CFriend *callingFriend = [[CFriend alloc] init];
                [callingFriend setUserID:[[TWData valueForKey:@"id"] objectAtIndex:0]];
                [callingFriend setName:[[TWData valueForKey:@"name"] objectAtIndex:0]];
                [callingFriend setUsername:[call remoteUserId]];
                [callingFriend setPicUrl:[[TWData valueForKey:@"profile_image_url"] objectAtIndex:0]];
                
                DetailViewController *controller = [top.storyboard instantiateViewControllerWithIdentifier:@"callScreen"];
                [controller setCallFriend:callingFriend];
                [controller setCall:call];
                [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
            }
        });
    }];
}


@end
