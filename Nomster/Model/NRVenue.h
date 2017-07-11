//
//  NRVenue.h
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NRVenue : NSObject
@property (nonatomic, strong) NSString*     title;
@property (nonatomic, strong) NSString*     description;
@property (nonatomic, strong) NSString*     category;
@property (nonatomic, strong) NSString*     icon;
@property (nonatomic, assign) CGFloat       latitude;
@property (nonatomic, assign) CGFloat       longitude;

+ (id) venueFromDict: (NSDictionary*) venueDict;
@end
