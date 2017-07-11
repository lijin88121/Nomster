//
//  NRVenueViewController.h
//  Nomster
//
//  Created by Li Jin on 11/9/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
#import "BZFoursquare.h"
#import "SLGlowingTextField.h"

@protocol NRVenueViewControllerDelegate <NSObject>
- (void) venueSelected: (NRVenue*) venue;
@end

@interface NRVenueViewController : NRBaseViewController <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate>
@property (nonatomic, strong) IBOutlet UITableView*             tblVenues;
@property (nonatomic, strong) BZFoursquare*                     foursquare;
@property (nonatomic, strong) BZFoursquareRequest*              request;
@property (nonatomic, strong) id<NRVenueViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet SLGlowingTextField*      txtPlacename;
@property (nonatomic, strong) IBOutlet UIView*                  vwTitleContainer;

@property (nonatomic, strong) NSMutableArray*                   venues;
@property (nonatomic, strong) NSMutableArray*                   candidates;

@property (nonatomic, strong) NRVenue*                          selectedVenue;
@end

