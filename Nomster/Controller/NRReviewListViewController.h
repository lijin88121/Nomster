//
//  NRReviewListViewController.h
//  Nomster
//
//  Created by Li Jin on 11/26/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class NRReviewListViewController;

@protocol NRReviewListViewControllerDelegate <NSObject>
@optional
- (void) requestReviewsForController: (NRReviewListViewController*) controller block: (void(^)(NSArray* reviews, NSError* error)) block;
- (void) reviewListViewController: (NRReviewListViewController*) controller didReviewSelected: (NRReview*) review;
@end

@interface NRReviewListViewController : UIViewController <NRReviewListViewDelegate, MKMapViewDelegate>
@property (nonatomic, strong) IBOutlet MKMapView*                       vwMap;
@property (nonatomic, strong) IBOutlet NRReviewListView*                reviewListView;
@property (nonatomic, strong) NSMutableArray*                           reviews;
@property (nonatomic, strong) id<NRReviewListViewControllerDelegate>    delegate;

- (void) reloadData;
@end
