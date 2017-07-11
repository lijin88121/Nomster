//
//  NRSearchOption.m
//  Nomster
//
//  Created by Li Jin on 11/22/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRSearchOption.h"

@implementation NRSearchOption

+ (NSMutableDictionary*) dictFromSearchOption: (NRSearchOption*) option
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setFloat: option.radiusInMiles forKey: @"radius"];
    if (option.price != -1) {
        [dict setFloat: option.price forKey: @"price"];
    }
    
    if (option.price != -1) {
        [dict setInteger: option.ratings forKey: @"rating"];
    }
    
    [dict setSafeObject: option.country forKey: @"country"];
    [dict setSafeObject: option.state forKey: @"state"];
    [dict setSafeObject: option.city forKey: @"city"];
    [dict setSafeObject: option.category forKey: @"category"];
    [dict setSafeObject: option.restaurant forKey: @"name"];
    return dict;
}

+ (NRSearchOption*) searchOptionFromDict: (NSDictionary*) dict
{
    NRSearchOption* option = [NRSearchOption new];
    option.radiusInMiles = [dict floatForKey: @"radius"];
    option.price = [dict floatForKey: @"price"];
    option.ratings = [dict integerForKey: @"rating"];
    option.country = [dict safeObjectForKey: @"country"];
    option.state = [dict safeObjectForKey: @"state"];
    option.city = [dict safeObjectForKey: @"city"];
    option.category = [dict safeObjectForKey: @"category"];
    option.restaurant = [dict safeObjectForKey: @"restaurant"];
    return option;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.radiusInMiles = 25.0f;
    }
    return self;
}

- (void) reset
{
    self.radiusInMiles = 25.0f;
    self.price = -1;
    self.ratings = -1;
    
    self.country = nil;
    self.state = nil;
    self.city = nil;
    self.category = nil;
    self.restaurant = nil;
}
@end
