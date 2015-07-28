//
//  MasterViewController.m
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <Social/Social.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "CFriend.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getFriends];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    CFriend *object = self.objects[indexPath.row];
    cell.textLabel.text = object.name;
    [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", object.username];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (id<SINCallClient>)callClient {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] sinch] callClient];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"callScreen"];
    CFriend *callingFriend = self.objects[indexPath.row];
    [controller setCallFriend:callingFriend];
    id<SINCall> call = [self.callClient callUserWithId:[callingFriend username]];
    [controller setCall:call];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) getFriends {
    SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friends/ids.json?"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", self.twitterAccount.username], @"screen_name", @"-1", @"cursor", nil]];
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
                NSArray *friendList = [TWData valueForKey:@"ids"];
                [self fillTable:friendList];
            }
        });
    }];
}

- (void) fillTable:(NSArray *) friendList {
    for (NSString *friendID in friendList) {
        SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/lookup.json?"] parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", friendID], @"user_id", nil]];
        [twitterInfoRequest setAccount:self.twitterAccount];
        // Making the request
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
                    
                    CFriend *newFriend = [[CFriend alloc] init];
                    [newFriend setUserID:friendID];
                    [newFriend setName:[[TWData valueForKey:@"name"] objectAtIndex:0]];
                    [newFriend setUsername:[[TWData valueForKey:@"screen_name"] objectAtIndex:0]];
                    [newFriend setPicUrl:[[TWData valueForKey:@"profile_image_url"] objectAtIndex:0]];
                    
                    if (!self.objects) {
                        self.objects = [[NSMutableArray alloc] init];
                    }
                    [self.objects addObject:newFriend];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_objects.count-1 inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView reloadData];
                }
            });
        }];
    }
}


@end
