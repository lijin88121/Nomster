//
//  NRCategory.h
//  Nomster
//
//  Created by Li Jin on 11/25/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRCategory : NSObject
@property (nonatomic, strong) NSString* categoryID;
@property (nonatomic, strong) NSString* title;

+ (NRCategory*) categoryFromDict: (NSDictionary*) dict;
+ (NSDictionary*) dictFromCategory: (NRCategory*) category;

@end
