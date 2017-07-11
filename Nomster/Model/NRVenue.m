//
//  NRVenue.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRVenue.h"

@implementation NRVenue

- (id) initFromDict: (NSDictionary*) venueDict
{
    self = [super init];
    if (self) {
        NSDictionary* categoryDict = [[venueDict safeObjectForKey: @"categories"] firstObject];
        self.category = [categoryDict safeObjectForKey: @"name"];
        self.icon = [NSString stringWithFormat: @"%@bg_64.png", [[categoryDict safeObjectForKey: @"icon"] safeObjectForKey: @"prefix"]];
        self.title = [venueDict safeObjectForKey: @"name"];
        
        NSDictionary* locationDict = [venueDict safeObjectForKey: @"location"];
        self.latitude = [[locationDict safeObjectForKey: @"lat"] floatValue];
        self.longitude = [[locationDict safeObjectForKey: @"lng"] floatValue];
        
        self.description = [self addressFromLocationDict: locationDict];
    }
    return self;
}

- (NSString*) addressFromLocationDict: (NSDictionary*) locationDict
{
    NSString* address = [locationDict safeObjectForKey: @"address"];
    NSString* city = [locationDict safeObjectForKey: @"city"];
    NSString* state = [locationDict safeObjectForKey: @"state"];
    NSString* country = [locationDict safeObjectForKey: @"country"];

    NSMutableString* addressString = [NSMutableString string];
    if (address) {
        [addressString appendFormat: @" %@", address];
    }
    if (city) {
        [addressString appendFormat: @" %@", city];
    }
    if (state) {
        [addressString appendFormat: @" %@", state];
    }
    if (country) {
        [addressString appendFormat: @" %@", country];
    }
    return  addressString;
}

+ (id) venueFromDict: (NSDictionary*) venueDict
{
    return [[self alloc] initFromDict: venueDict];
}
@end
