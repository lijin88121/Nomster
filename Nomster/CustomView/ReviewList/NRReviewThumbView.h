//
//  NRReviewThumbView.h
//  Nomster
//
//  Created by Li Jin on 11/15/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRStarRatingControl.h"

@interface NRReviewThumbView : UIView
{
    __weak IBOutlet UIImageView *               imgReview;
    __weak IBOutlet UILabel *                   lblTitle;
    __weak IBOutlet UIImageView *               imgRibbon;
    __weak IBOutlet NRStarRatingControl *       starRatingControl;
    __weak IBOutlet UIView *                    vwDescription;
    
    __weak IBOutlet UILabel *                   lblRestaurant;
    __weak IBOutlet UILabel *                   lblLocation;
    __weak IBOutlet UILabel *                   lblStillEating;
    __weak IBOutlet UIActivityIndicatorView *   activity;
    __weak IBOutlet NRCircularImageView*        imgUser;
}

@property (nonatomic, strong) NRReview* review;
+ (id) thumbViewWithReview: (NRReview*) review;

@end
