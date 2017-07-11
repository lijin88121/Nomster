//
//  NRReview.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReview.h"

@implementation NRReview
/**
 review =     {
 category = Coffee;
 created = "2013-11-14 09:42:40";
 description = " Front Street and Wall Street New York NY United States";
 id = 24;
 latitude = "40.70084";
 longitude = "-74.00211";
 photo = "http://192.168.180.75/Nomster/api/data/review/784-25305577-avatar";
 restaurant = "Chinese Mirch";
 tag =         (
 {
 avatar = "<null>";
 email = "<null>";
 "first_name" = 1;
 "last_name" = "<null>";
 phone = "<null>";
 }
 );
 thumb = "http://192.168.180.75/Nomster/api/data/review/784-25305577-avatar_thumb.";
 title = asdf;
 userID = 11;
 };
 */
- (id) initWithDictionary: (NSDictionary*) dict
{
    self = [super init];
    if (self) {
        NSString* userID = [dict safeObjectForKey: @"userID"];
        NSString* username = [dict safeObjectForKey: @"username"];
        NSInteger numberOfReviews = [[dict safeObjectForKey: @"userReviews"] integerValue];
        self.user = [NRUser new];
        self.user.userID = userID;
        self.user.username = username;
        self.user.avatarURL = [dict safeObjectForKey: @"avatar"];
        self.user.numberOfReviews = numberOfReviews;
        self.reviewID = [dict safeObjectForKey: @"id"];
        self.title = [dict safeObjectForKey: @"title"];
        self.description = [dict safeObjectForKey: @"description"];
        self.restaurant = [dict safeObjectForKey: @"restaurant"];
        NSDictionary* cateDict = [dict safeObjectForKey: @"category"];
        if ([cateDict isKindOfClass: [NSDictionary class]]) {
            self.category = [NRCategory categoryFromDict: cateDict];
        }
        self.latitude = [[dict safeObjectForKey: @"latitude"] floatValue];
        self.longitude = [[dict safeObjectForKey: @"longitude"] floatValue];
        self.imageURL = [dict safeObjectForKey: @"photo"];
        self.thumbURL = [dict safeObjectForKey: @"thumb"];
        
        id dateObj = [dict safeObjectForKey: @"created"];
        if ([dateObj isKindOfClass: [NSDate class]]) {
            self.created = dateObj;
        }
        else
        {
            self.created = (id)[NSDate dateFromBackendFormat: dateObj];
        }

        self.withs = [NSMutableArray array];
        NSArray* tagPeople = [dict safeObjectForKey: @"tag"];
        if ([tagPeople isKindOfClass: [NSArray class]]) {
            [tagPeople enumerateObjectsUsingBlock:^(NSDictionary* tagDict, NSUInteger idx, BOOL *stop) {
                NRUser* user = [NRUser userFromDictionary: tagDict];
                [self.withs addObject: user];
            }];
        }

        if ([[dict safeObjectForKey: @"status"] isEqualToString: @"finished"])
            self.finished = YES;
        else
            self.finished = NO;
        self.ratings = [[dict safeObjectForKey: @"rating"] intValue];
        self.price = [[dict safeObjectForKey: @"price"] floatValue];
        
        self.likes = [NSMutableArray array];
        NSArray* likesDicts = [dict safeObjectForKey: @"likes"];
        if ([likesDicts isKindOfClass: [NSArray class]]) {
            [likesDicts enumerateObjectsUsingBlock:^(NSDictionary* likeDict, NSUInteger idx, BOOL *stop) {
                NRLike* like = [NRLike likeFromDictionary: likeDict];
                like.review = self;
                [self.likes addObject: like];
            }];
        }
        
        self.comments = [NSMutableArray array];
        NSArray* commentDicts = [dict safeObjectForKey: @"comments"];
        if ([commentDicts isKindOfClass: [NSArray class]]) {
            [commentDicts enumerateObjectsUsingBlock:^(NSDictionary* commentDict, NSUInteger idx, BOOL *stop) {
                NRComment* comment = [NRComment commentFromDictionary: commentDict];
                comment.review = self;
                [self.comments addObject: comment];
            }];
        }
    }
    return self;
}

- (void) unLike: (NRUser*) user
{
    for (int i=(int)self.likes.count-1; i>=0; i--) {
        NRLike* like = [self.likes objectAtIndex: i];
        if ([like.user.userID isEqualToString: user.userID]) {
            [self.likes removeObject: like];
        }
    }
}

- (void) like: (NRUser*) user
{
    BOOL bExisting = NO;
    for (int i=(int)self.likes.count-1; i>=0; i--) {
        NRLike* like = [self.likes objectAtIndex: i];
        if ([like.user.userID isEqualToString: user.userID]) {
            bExisting = YES;
            break;
        }
    }
    
    if (!bExisting) {
        if (self.likes == nil) {
            self.likes = [NSMutableArray array];
        }
        
        NRLike* like = [NRLike new];
        like.user = user;
        like.created = [NSDate date];
        [self.likes addObject: like];
    }
}

+ (NRReview*) reviewFromDictionary: (NSDictionary*) dict
{
    if (![dict isKindOfClass: [NSDictionary class]]) {
        return nil;
    }
    return [[self alloc] initWithDictionary: dict];
}

+ (NSDictionary*) dictFromReview: (NRReview*) review
{
    NSMutableDictionary* reviewDict = [NSMutableDictionary dictionary];
    [reviewDict setSafeObject: review.reviewID forKey: @"id"];
    [reviewDict setSafeObject: review.user.userID forKey: @"userID"];
    [reviewDict setSafeObject: review.user.username forKey: @"username"];
    [reviewDict setSafeObject: review.user.avatarURL forKey: @"avatar"];
    [reviewDict setSafeObject: [NSNumber numberWithInt: (int)review.user.numberOfReviews] forKey: @"userReviews"];
    [reviewDict setSafeObject: review.title forKey: @"title"];
    [reviewDict setSafeObject: review.imageURL forKey: @"photo"];
    [reviewDict setSafeObject: review.thumbURL forKey: @"thumb"];
    [reviewDict setSafeObject: review.restaurant forKey: @"restaurant"];
    [reviewDict setSafeObject: review.description forKey: @"description"];
    NSDictionary* categoryDict = [NRCategory dictFromCategory: review.category];
    [reviewDict setSafeObject: categoryDict forKey: @"category"];
    [reviewDict setSafeObject: [NSNumber numberWithFloat: review.latitude] forKey: @"latitude"];
    [reviewDict setSafeObject: [NSNumber numberWithFloat: review.longitude] forKey: @"longitude"];
    
    [reviewDict setSafeObject: [NSNumber numberWithInt: (int)review.ratings] forKey: @"rating"];
    [reviewDict setSafeObject: [NSNumber numberWithFloat: review.price] forKey: @"price"];
    [reviewDict setSafeObject: review.created forKey: @"created"];
    
    if (review.finished) {
        [reviewDict setSafeObject: @"finished" forKey: @"status"];
    }
    
    NSMutableArray* array = [NSMutableArray array];
    [review.withs enumerateObjectsUsingBlock:^(NRUser* user, NSUInteger idx, BOOL *stop) {
        [array addObject: [NRUser dictFromUser: user]];
    }];
    [reviewDict setSafeObject: array forKey: @"withs"];
    
    array = [NSMutableArray array];
    [review.comments enumerateObjectsUsingBlock:^(NRComment* comment, NSUInteger idx, BOOL *stop) {
        [array addObject: [NRComment dictFromComment: comment]];
    }];
    [reviewDict setSafeObject: array forKey: @"comments"];

    array = [NSMutableArray array];
    [review.likes enumerateObjectsUsingBlock:^(NRLike* like, NSUInteger idx, BOOL *stop) {
        [array addObject: [NRLike dictFromLike: like]];
    }];
    [reviewDict setSafeObject: array forKey: @"likes"];

    return  reviewDict;
}
@end
