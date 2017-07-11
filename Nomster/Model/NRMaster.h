//
//  NRMaster.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class BZFoursquare;
@class NRSearchOption;

@interface NRMaster : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NRUser*           user;
@property (nonatomic, strong) NSString*         deviceToken;
@property (nonatomic, strong) BZFoursquare*     foursquare;

@property (nonatomic, strong) CLLocationManager*    locationManager;
@property (nonatomic, strong) CLLocation*           currentLocation;

@property (nonatomic, strong) NRSearchOption*       searchOption;
@property (nonatomic, strong) NSMutableArray*       venuesAroundme;
@property (nonatomic, strong) NSMutableArray*       categories;
@property (nonatomic, strong) NSMutableArray*       followers;
@property (nonatomic, strong) NSMutableArray*       followings;
@property (nonatomic, strong) NSMutableArray*       favorites;

+ (NRMaster*) master;
+ (void) registerReviewNotification: (NRReview*) review;
+ (void) checkAndRemoveFromLocalNotification: (NRReview*) review;

+ (void) processFinishReview: (NRReview*) review;
+ (void) directionToCoordinate: (CLLocationCoordinate2D) coordinate withName: (NSString*) name;
+ (BOOL) checkAndShowLogin;

- (void) loadSearchOption;
- (void) storeSearchOption;
- (void) loadUser;
- (void) storeUser;

- (void) loadFavorites;
- (void) storeFavorites;
- (void) addToFavorite: (NRReview*) review;

+ (BOOL) isFacebookLoggedIn;
+ (void) shareViaFacebook: (NRReview*) review;
+ (void) shareViaTwitter: (NRReview*) review;
@end
