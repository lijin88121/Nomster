//
//  NRAPIManager.h
//  Nomster
//
//  Created by Li Jin on 11/5/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRAPIManager : NSObject

+ (NRAPIManager*) manager;

- (void) userLoginWithEmail: (NSString*) userEmail password: (NSString*) password deviceToken: (NSString*) deviceToken block: (void (^)(NRUser* user)) block;
- (void) userRegisterWithAttribute: (NSDictionary*) attribute photo: (UIImage*) photo block: (void (^)(NRUser* user)) block;
- (void) updateUser: (NRUser*) user attribute: (NSDictionary*) attribute photo: (UIImage*) photo block: (void (^)(NRUser* user)) block;
- (void) createReview: (NSString*) userID attribute: (NSDictionary*) reviewAttribute photo: (UIImage*) photo block: (void (^)(NRReview* review)) block;
- (void) finishReview: (NRReview*) review withComment: (NSString*) comment withPrice: (NSString*) priceText withRatings: (NSInteger) ratings  block: (void (^)(NSError* error)) block;
- (void) likeReview: (NRUser*) user review:(NRReview*) review block: (void (^)(NSError* error)) block;
- (void) unlikeReview: (NRUser*) user review:(NRReview*) review block: (void (^)(NSError* error)) block;
- (void) commentReview: (NRUser*) user review:(NRReview*) review comment: (NSString*) comment block: (void (^)(NSError* error)) block;
- (void) searchReviewBySearchOption: (NRSearchOption*) option block: (void (^)(NSMutableArray* reviews)) block;
- (void) reviewOfUser: (NRUser*) user block: (void (^)(NSMutableArray* reviews)) block;
- (void) reviewDetail: (NRReview*) review block: (void (^)(NRReview* review)) block;

- (void) followUser: (NRUser*) user toFollow:(NRUser*) follow block: (void (^)(NSError* error)) block;
- (void) unfollowUser: (NRUser*) user toUnfollow:(NRUser*) unfollow block: (void (^)(NSError** error)) block;

- (void) followingUsers: (NRUser*) user block: (void (^)(NSMutableArray* users)) block;
- (void) followerUsers: (NRUser*) user block: (void (^)(NSMutableArray* users)) block;

- (void) recommendedReview: (NRUser*) user latitude: (CGFloat) latitude longitude: (CGFloat) longitude block: (void (^)(NSMutableArray* reviews, NRReview* topReview)) block;
- (void) followerReviews: (NRUser*) user block: (void (^)(NSMutableArray* reviews)) block;

- (void) getCategoriesWithBlock: (void (^)(NSMutableArray* categories)) block;
- (void) getAddressFromCoordinate: (CLLocationCoordinate2D) coordinate block: (void(^)(NSString* address)) block;
@end
