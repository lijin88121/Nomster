//
//  NRRecommendedViewController.h
//  Nomster
//
//  Created by Li Jin on 11/8/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
#import "NRStarRatingControl.h"

@class NRReviewGroup;

@interface NRRecommendedViewController : NRBaseViewController
{
    //User Info
    IBOutlet UILabel*           lblAddress;
    //Food Info
    IBOutlet UILabel*           lblFoodName;
    IBOutlet UILabel*           lblCategory;
    IBOutlet UILabel*           lblPrice;
    IBOutlet NRStarRatingControl*   ctrlRatings;
    IBOutlet UIImageView*       imgFood;
    IBOutlet UIView*            vwHeaderBack;
}

@property (nonatomic, strong) IBOutlet UITableView*         tblCategory;
@property (nonatomic, strong) NSMutableArray*               reviewGroups;
@property (nonatomic, strong) NRReview*                     topReview;
@property (nonatomic, strong) NRReviewGroup*                selectedGroup;
@end
