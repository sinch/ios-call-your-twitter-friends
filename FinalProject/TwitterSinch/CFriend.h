//
//  CFriend.h
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFriend : NSObject

@property NSString *name;
@property NSString *username;
@property NSString *userID;
@property NSString *picUrl;

- (id)initCFriendWithName:(NSString *)name Username:(NSString *)username UserID:(NSString *)userID PicUrl:(NSString *)picUrl;

@end
