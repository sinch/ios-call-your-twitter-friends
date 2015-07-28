//
//  CFriend.m
//  TwitterSinch
//
//  Created by Ali Minty on 7/14/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import "CFriend.h"

@implementation CFriend

- (id)initCFriendWithName:(NSString *)name Username:(NSString *)username UserID:(NSString *)userID PicUrl:(NSString *)picUrl{
    self = [super init];
    if (self) {
        self.name = name;
        self.username = username;
        self.userID = userID;
        self.picUrl = picUrl;
    }
    return self;
}

@end
