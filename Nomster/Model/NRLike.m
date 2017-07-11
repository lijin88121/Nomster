//
//  NRLike.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRLike.h"

@implementation NRLike

- (id) initWithDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.user = [NRUser userFromDictionary: [dict safeObjectForKey: @"user"]];
        id dateObj = [dict safeObjectForKey: @"created"];
        if ([dateObj isKindOfClass: [NSDate class]]) {
            self.created = (id)dateObj;
        }
        else
        {
            self.created = [NSDate dateFromBackendFormat: dateObj];
        }
    }
    return self;
}

+ (NRLike*) likeFromDictionary: (NSDictionary*) dict;
{
    if (![dict isKindOfClass: [NSDictionary class]]) {
        return nil;
    }
    return [[self alloc] initWithDictionary: dict];
}

+ (NSDictionary*) dictFromLike: (NRLike*) like
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setSafeObject: [NRUser dictFromUser: like.user] forKey: @"user"];
    [dict setSafeObject: like.created forKey: @"created"];
    return dict;
}
@end
