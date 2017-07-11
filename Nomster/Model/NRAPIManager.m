//
//  NRAPIManager.m
//  Nomster
//
//  Created by Li Jin on 11/5/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRAPIManager.h"
#import "NRConnection.h"
#import "NRSearchOption.h"

@implementation NRAPIManager

+ (NRAPIManager*) manager
{
    static dispatch_once_t once;
    static NRAPIManager* sharedManager = nil;
    dispatch_once(&once, ^{
        sharedManager = [NRAPIManager new];
    });
    return sharedManager;
}

- (void) userLoginWithEmail: (NSString*) userEmail password: (NSString*) password deviceToken: (NSString*) deviceToken block: (void (^)(NRUser* user)) block
{
    NSURL* url = [NSURL URLWithString: URL_LOGIN];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                userEmail, @"username",
                                password, @"password",
                                deviceToken, @"deviceToken",
                                nil];
    
    NRConnection* connection = [NRConnection withUrl: url
                    method: NRRequestMethodPOST
                   headers: nil
                parameters: parameters
                parseBlock: ^id(NRConnection* c, NSError** error){
                    return [c.responseData dictionaryFromJSONWithError:error];
                }
           completionBlock:^(NRConnection* c) {
               NSDictionary* result = (NSDictionary*)c.parseResult;
               NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
               if (bSuccess == 1)
               {
                   block([NRUser userFromDictionary: [result safeObjectForKey: @"userdata"]]);
               }
               else
               {
                   block(nil);
               }
           }
             progressBlock: nil];
    [connection start];
}

- (void) userRegisterWithAttribute: (NSDictionary*) attribute photo: (UIImage*) photo block: (void (^)(NRUser* user)) block
{
    NSURL* url = [NSURL URLWithString: URL_REGISTER];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: attribute];
    [parameters setObject: [NRData withImage: photo jpegQuality: 0.75f fileName: @"avatar.jpg"] forKey: @"avatar"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block([NRUser userFromDictionary: [result safeObjectForKey: @"data"]]);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) updateUser: (NRUser*) user attribute: (NSDictionary*) attribute photo: (UIImage*) photo block: (void (^)(NRUser* user)) block
{
    NSURL* url = [NSURL URLWithString: URL_UPDATE_PROFILE];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: attribute];
    [parameters setObject: user.userID forKey: @"uid"];
    if (photo != nil) {
        [parameters setObject: [NRData withImage: photo jpegQuality: 0.75f fileName: @"avatar"] forKey: @"avatar"];
    }
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block([NRUser userFromDictionary: [result safeObjectForKey: @"data"]]);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) createReview: (NSString*) userID attribute: (NSDictionary*) reviewAttribute photo: (UIImage*) photo block: (void (^)(NRReview* review)) block
{
    NSURL* url = [NSURL URLWithString: URL_CREATE_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: reviewAttribute];
    [parameters setObject: userID forKey: @"userid"];
    [parameters setObject: [NRData withImage: photo jpegQuality: 0.75f fileName: @"avatar"] forKey: @"image"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSDictionary* dictReview = [result safeObjectForKey: @"review"];
                                             NRReview* review = [NRReview reviewFromDictionary: dictReview];
                                             block(review);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) finishReview: (NRReview*) review withComment: (NSString*) comment withPrice: (NSString*) priceText withRatings: (NSInteger) ratings  block: (void (^)(NSError* error)) block
{
    NSURL* url = [NSURL URLWithString: URL_FINISH_REVIEW];
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: review.reviewID forKey: @"reviewid"];
    [parameters setObject: [NSNumber numberWithInteger: ratings] forKey: @"rating"];
    [parameters setObject: comment forKey: @"comment"];
    [parameters setObject: priceText forKey: @"price"];
    [parameters setObject: review.user.userID forKey: @"userid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSDictionary* dictReview = [result safeObjectForKey: @"review"];
                                             review.price = [[dictReview safeObjectForKey: @"price"] floatValue];
                                             review.ratings = [[dictReview safeObjectForKey: @"rating"] integerValue];
                                             review.finished = YES;

                                             NRComment* comment = [NRComment new];
                                             comment.user = review.user;
                                             comment.review = review;
                                             comment.comment = [dictReview safeObjectForKey: @"comment"];
                                             id dateObj = [dictReview safeObjectForKey: @"updated"];
                                             if ([dateObj isKindOfClass: [NSDate class]]) {
                                                 comment.created = dateObj;
                                             }
                                             else
                                             {
                                                 comment.created = (id)[NSDate dateFromBackendFormat: dateObj];
                                             }
                                             
                                             if (review.comments == nil) {
                                                 review.comments = [NSMutableArray array];
                                             }
                                             [review.comments addObject: comment];
                                             block(nil);
                                         }
                                         else
                                         {
                                             block([NSError errorWithDomain: @"Finish Review Failed" code: 100 userInfo: nil]);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) likeReview: (NRUser*) user review:(NRReview*) review block: (void (^)(NSError* error)) block
{
    NSURL* url = [NSURL URLWithString: URL_LIKE_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    [parameters setObject: review.reviewID forKey: @"reviewid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block(nil);
                                         }
                                         else
                                         {
                                             block(c.error);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) unlikeReview: (NRUser*) user review:(NRReview*) review block: (void (^)(NSError* error)) block
{
    NSURL* url = [NSURL URLWithString: URL_UNLIKE_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    [parameters setObject: review.reviewID forKey: @"reviewid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block(nil);
                                         }
                                         else
                                         {
                                             block(c.error);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) commentReview: (NRUser*) user review:(NRReview*) review comment: (NSString*) comment block: (void (^)(NSError* error)) block
{
    NSURL* url = [NSURL URLWithString: URL_COMMENT_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    [parameters setObject: review.reviewID forKey: @"reviewid"];
    [parameters setObject: comment forKey: @"comment"];

    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block(nil);
                                         }
                                         else
                                         {
                                             block(c.error);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) searchReviewWithParam: (NSDictionary*) parameters block: (void (^)(NSMutableArray* reviews)) block
{
    NSURL* url = [NSURL URLWithString: URL_SEARCH_REVIEW];
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* dictReviews = [result safeObjectForKey: @"data"];
                                             NSMutableArray* reviews = [NSMutableArray array];
                                             [dictReviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                 NRReview* review = [NRReview reviewFromDictionary: obj];
                                                 [reviews addObject: review];
                                             }];
                                             block(reviews);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) searchReviewBySearchOption: (NRSearchOption*) option block: (void (^)(NSMutableArray* reviews)) block
{
    NSMutableDictionary *parameters = [NRSearchOption dictFromSearchOption: option];
    CGFloat radius = [[parameters safeObjectForKey: @"radius"] floatValue];
    [parameters setSafeObject: [NSNumber numberWithFloat: MILES_TO_KILOMETERS(radius)] forKey: @"radius"];
    
    CLLocationCoordinate2D coordinate = [NRMaster master].currentLocation.coordinate;
    [parameters setObject: [NSNumber numberWithFloat: coordinate.latitude] forKey: @"lat"];
    [parameters setObject: [NSNumber numberWithFloat: coordinate.longitude] forKey: @"lon"];
    [self searchReviewWithParam: parameters block:^(NSMutableArray *reviews) {
        block(reviews);
    }];
}

- (void) reviewOfUser: (NRUser*) user block: (void (^)(NSMutableArray* reviews)) block
{
    NSURL* url = [NSURL URLWithString: URL_USER_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* dictReviews = [result safeObjectForKey: @"data"];
                                             NSMutableArray* reviews = [NSMutableArray array];
                                             [dictReviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                 NRReview* review = [NRReview reviewFromDictionary: obj];
                                                 [reviews addObject: review];
                                             }];
                                             block(reviews);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) reviewDetail: (NRReview*) review block: (void (^)(NRReview* review)) block
{
    NSURL* url = [NSURL URLWithString: URL_USER_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: review.reviewID forKey: @"reviewid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSDictionary* dictReview = [result safeObjectForKey: @"review"];
                                             NRReview* review = [NRReview reviewFromDictionary: dictReview];
                                             block(review);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) followUser: (NRUser*) user toFollow:(NRUser*) follow block: (void (^)(NSError* error)) block
{
    NSURL* url = [NSURL URLWithString: URL_FOLLOW_USER];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    [parameters setObject: follow.userID forKey: @"following"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block(nil);
                                         }
                                         else
                                         {
                                             block(c.error);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) unfollowUser: (NRUser*) user toUnfollow:(NRUser*) unfollow block: (void (^)(NSError** error)) block
{
    NSURL* url = [NSURL URLWithString: URL_UNFOLLOW_USER];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    [parameters setObject: unfollow.userID forKey: @"following"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             block(nil);
                                         }
                                         else
                                         {
                                             NSError* error = c.error;
                                             block(&error);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) followingUsers: (NRUser*) user block: (void (^)(NSMutableArray* users)) block
{
    NSURL* url = [NSURL URLWithString: URL_GET_FOLLOWINGS];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* dictUsers = [result safeObjectForKey: @"data"];
                                             NSMutableArray* users = [NSMutableArray array];
                                             [dictUsers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                 NRUser* user = [NRUser userFromDictionary: obj];
                                                 [users addObject: user];
                                             }];
                                             block(users);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) followerUsers: (NRUser*) user block: (void (^)(NSMutableArray* users)) block
{
    NSURL* url = [NSURL URLWithString: URL_GET_FOLLOWERS];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* dictUsers = [result safeObjectForKey: @"data"];
                                             NSMutableArray* users = [NSMutableArray array];
                                             for (NSDictionary* dict in dictUsers) {
                                                 if (dict && ![dict isKindOfClass: [NSNull class]]) {
                                                     NRUser* user = [NRUser userFromDictionary: dict];
                                                     if (user != nil) {
                                                         [users addObject: user];
                                                     }
                                                 }
                                             }
                                             block(users);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) recommendedReview: (NRUser*) user latitude: (CGFloat) latitude longitude: (CGFloat) longitude block: (void (^)(NSMutableArray* reviews, NRReview* topReview)) block
{
    NSURL* url = [NSURL URLWithString: URL_RECOMMENDED_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    [parameters setObject: [NSNumber numberWithFloat: latitude] forKey: @"lat"];
    [parameters setObject: [NSNumber numberWithFloat: longitude] forKey: @"lon"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* dictReviews = [result safeObjectForKey: @"data"];
                                             NSMutableArray* reviews = [NSMutableArray array];
                                             [dictReviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                 NRReview* review = [NRReview reviewFromDictionary: obj];
                                                 [reviews addObject: review];
                                             }];
                                             
                                             NRReview* topReview = [NRReview reviewFromDictionary: [result safeObjectForKey: @"topReview"]];
                                             if (topReview.reviewID == nil || [topReview.reviewID length] == 0) {
                                                 topReview = nil;
                                             }
                                             block(reviews, topReview);
                                         }
                                         else
                                         {
                                             block(nil, nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) followerReviews: (NRUser*) user block: (void (^)(NSMutableArray* reviews)) block
{
    NSURL* url = [NSURL URLWithString: URL_FOLLOWER_REVIEW];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject: user.userID forKey: @"userid"];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* dictReviews = [result safeObjectForKey: @"data"];
                                             NSMutableArray* reviews = [NSMutableArray array];
                                             [dictReviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                 NRReview* review = [NRReview reviewFromDictionary: obj];
                                                 [reviews addObject: review];
                                             }];
                                             block(reviews);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) getCategoriesWithBlock: (void (^)(NSMutableArray* categories)) block
{
    NSURL* url = [NSURL URLWithString: URL_GET_CATEGORIES];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NRConnection* connection = [NRConnection withUrl: url
                                              method: NRRequestMethodPOST
                                             headers: nil
                                          parameters: parameters
                                          parseBlock: ^id(NRConnection* c, NSError** error){
                                              return [c.responseData dictionaryFromJSONWithError:error];
                                          }
                                     completionBlock:^(NRConnection* c) {
                                         NSDictionary* result = (NSDictionary*)c.parseResult;
                                         NSInteger bSuccess = [[result safeObjectForKey: @"result"] intValue];
                                         if (bSuccess)
                                         {
                                             NSMutableArray* array = [result safeObjectForKey: @"data"];
                                             NSMutableArray* categories = [NSMutableArray array];
                                             [array enumerateObjectsUsingBlock:^(NSDictionary* categoryDict, NSUInteger idx, BOOL *stop) {
                                                 [categories addObject: [NRCategory categoryFromDict: categoryDict]];
                                             }];
                                             block(categories);
                                         }
                                         else
                                         {
                                             block(nil);
                                         }
                                     }
                                       progressBlock: nil];
    [connection start];
}

- (void) getAddressFromCoordinate: (CLLocationCoordinate2D) coordinate block: (void(^)(NSString* address)) block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *strUrl = [[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false", coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: strUrl]];
       
        NSError* error;
        NSDictionary* dict = [data dictionaryFromJSONWithError: &error];
        NSMutableArray* addresses = [dict safeObjectForKey: @"results"];
        NSDictionary* address = [addresses firstObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (address != nil) {
                    block([address safeObjectForKey: @"formatted_address"]);
            }
            else
                block (nil);
        });
    });
}


@end
