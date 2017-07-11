//
//  NRComment.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRComment.h"

@implementation NRComment

- (id) initWithDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.comment = [dict safeObjectForKey: @"comment"];
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

+ (NRComment*) commentFromDictionary: (NSDictionary*) dict;
{
    if (![dict isKindOfClass: [NSDictionary class]]) {
        return nil;
    }
    return [[self alloc] initWithDictionary: dict];
}

+ (NSDictionary*) dictFromComment: (NRComment*) comment
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setSafeObject: [NRUser dictFromUser: comment.user] forKey: @"user"];
    [dict setSafeObject: comment.comment forKey: @"comment"];
    [dict setSafeObject: comment.created forKey: @"created"];
    return dict;
}

@end
