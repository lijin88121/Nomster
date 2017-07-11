//
//  NRSearchOption.h
//  Nomster
//
//  Created by Li Jin on 11/22/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRSearchOption : NSObject
@property (nonatomic, assign) CGFloat       radiusInMiles;
@property (nonatomic, strong) NSString*     country;
@property (nonatomic, strong) NSString*     state;
@property (nonatomic, strong) NSString*     city;
@property (nonatomic, strong) NSString*     category;
@property (nonatomic, assign) CGFloat       price;
@property (nonatomic, strong) NSString*     restaurant;
@property (nonatomic, assign) NSInteger     ratings;

+ (NSMutableDictionary*) dictFromSearchOption: (NRSearchOption*) option;
+ (NRSearchOption*) searchOptionFromDict: (NSDictionary*) dict;

- (void) reset;
@end
