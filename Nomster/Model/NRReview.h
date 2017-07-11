//
//  NRReview.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NRCategory;
@interface NRReview : NSObject
@property (nonatomic, strong) NSString*     reviewID;
@property (nonatomic, strong) NRUser*       user;
@property (nonatomic, strong) NSString*     title;
@property (nonatomic, strong) NSString*     description;
@property (nonatomic, strong) NSString*     restaurant;
@property (nonatomic, strong) NRCategory*     category;
@property (nonatomic, strong) NSString*     imageURL;
@property (nonatomic, strong) NSString*     thumbURL;
@property (nonatomic, strong) UIImage*      image;
@property (nonatomic, assign) CGFloat       latitude;
@property (nonatomic, assign) CGFloat       longitude;

@property (nonatomic, assign) BOOL          finished;
@property (nonatomic, assign) NSInteger     ratings;
@property (nonatomic, assign) CGFloat       price;

@property (nonatomic, strong) NSMutableArray* withs;
@property (nonatomic, strong) NSMutableArray* likes;
@property (nonatomic, strong) NSMutableArray* comments;

@property (nonatomic, strong) NSDate*       created;

- (id) initWithDictionary: (NSDictionary*) dict;
+ (NRReview*) reviewFromDictionary: (NSDictionary*) dict;
+ (NSDictionary*) dictFromReview: (NRReview*) review;

- (void) unLike: (NRUser*) user;
- (void) like: (NRUser*) user;

@end
