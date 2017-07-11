//
//  NRCategory.m
//  Nomster
//
//  Created by Li Jin on 11/25/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRCategory.h"

@implementation NRCategory

- (id) initFromDict: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        self.categoryID = [dict safeObjectForKey: @"id"];
        self.title = [dict safeObjectForKey: @"category"];
    }
    return self;
}

+ (NRCategory*) categoryFromDict: (NSDictionary*) dict
{
    return [[self alloc] initFromDict: dict];
}

+ (NSDictionary*) dictFromCategory: (NRCategory*) category
{
    return [NSDictionary dictionaryWithObjectsAndKeys: category.categoryID, @"id", category.title, @"category", nil];
}
@end
