//
//  NRUser.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRUser.h"

@implementation NRUser

- (id) initWithDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.userID = [dict safeObjectForKey: @"id"];
        self.firstName = [dict safeObjectForKey: @"first_name"];
        self.lastName = [dict safeObjectForKey: @"last_name"];
        self.username = [dict safeObjectForKey: @"username"];
        
        NSMutableString* sFullName = [NSMutableString string];
        if (self.firstName && ![self.firstName isKindOfClass: [NSNull class]]) {
            [sFullName appendString: self.firstName];
        }
        if (self.lastName && ![self.lastName isKindOfClass: [NSNull class]]) {
            [sFullName appendFormat: @" %@", self.lastName];
        }
        self.fullName = sFullName;
        if (self.username == nil || self.username.length == 0) {
            self.username = self.fullName;
        }
        
        self.phone = [dict safeObjectForKey: @"phone"];
        self.gender = [dict safeObjectForKey: @"gender"];
        self.age = [[dict safeObjectForKey: @"age"] integerValue];
        self.email = [dict safeObjectForKey: @"email"];
        self.avatarURL = [dict safeObjectForKey: @"avatar"];
        self.numberOfReviews = [[dict safeObjectForKey: @"userReivews"] integerValue];
        
        id dateObj = [dict safeObjectForKey: @"created"];
        if ([dateObj isKindOfClass: [NSDate class]]) {
            self.createdDate = dateObj;
        }
        else
        {
            self.createdDate = (id)[NSDate dateFromBackendFormat: dateObj];
        }
        
        self.followings = [dict safeObjectForKey: @"followings"];
        self.followers = [dict safeObjectForKey: @"followers"];
    }
    return self;
}

+ (NRUser*) userFromDictionary: (NSDictionary*) dict
{
    if ([dict isKindOfClass: [NSDictionary class]]) {
        return [[NRUser alloc] initWithDictionary: dict];
    }
    return nil;
}

+ (NSDictionary*) dictFromUser: (NRUser*) user
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setSafeObject: user.userID forKey: @"id"];
    [dict setSafeObject: user.firstName forKey: @"first_name"];
    [dict setSafeObject: user.lastName forKey: @"last_name"];
    [dict setSafeObject: user.username forKey: @"username"];
    [dict setSafeObject: user.phone forKey: @"phone"];
    [dict setSafeObject: user.gender forKey: @"gender"];
    [dict setSafeObject: [NSNumber numberWithInteger: user.age] forKey: @"age"];
    [dict setSafeObject: [NSNumber numberWithInteger: user.numberOfReviews] forKey: @"userReviews"];
    [dict setSafeObject: user.email forKey: @"email"];
    [dict setSafeObject: user.avatarURL forKey: @"avatar"];
    [dict setSafeObject: user.createdDate forKey: @"created"];
    return dict;
}

+ (NRUser*) userWithID: (NSString*) userID
{
    NRUser* user = [NRUser new];
    user.userID = userID;
    return  user;
}

@end
