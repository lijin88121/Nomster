//
//  NRLike.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NRUser;
@class NRReview;

@interface NRLike : NSObject
@property (nonatomic, strong) NRUser*   user;
@property (nonatomic, strong) NRReview* review;
@property (nonatomic, strong) NSDate*   created;

- (id) initWithDictionary: (NSDictionary*) dict;
+ (NRLike*) likeFromDictionary: (NSDictionary*) dict;
+ (NSDictionary*) dictFromLike: (NRLike*) like;
@end
