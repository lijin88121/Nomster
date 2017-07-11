//
//  NRComment.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NRUser;
@class NRReview;

@interface NRComment : NSObject
@property (nonatomic, strong) NRUser*   user;
@property (nonatomic, strong) NRReview* review;
@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) NSDate*   created;

- (id) initWithDictionary: (NSDictionary*) dict;
+ (NRComment*) commentFromDictionary: (NSDictionary*) dict;
+ (NSDictionary*) dictFromComment: (NRComment*) comment;

@end
