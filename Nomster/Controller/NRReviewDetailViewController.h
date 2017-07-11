//
//  NRReviewDetailViewController.h
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRStarRatingControl.h"

@interface NRReviewDetailViewController : UIViewController <UIActionSheetDelegate>
{
//User Info
//    IBOutlet UIImageView*       imgUser;
    IBOutlet NRCircularImageView*   imgUser;
    IBOutlet UILabel*           lblUserName;
    IBOutlet UILabel*           lblTime;
    IBOutlet UILabel*           lblAddress;
    IBOutlet UILabel*           lblNumberOfOtherReviews;
    IBOutlet UILabel*           lblRestaurant;
    
    IBOutlet UIButton*          btnFollow;
//Food Info
    IBOutlet UILabel*           lblFoodName;
    IBOutlet UILabel*           lblCategory;
    IBOutlet UILabel*           lblPrice;
    IBOutlet UILabel*           lblRating;
    IBOutlet NRStarRatingControl*   ctrlRatings;
    IBOutlet UIImageView*       imgFood;
//Social
    IBOutlet UIButton*          btnLike;
    IBOutlet UIButton*          btnUnlike;
    
    IBOutlet UILabel*           lblNomed; //Number of Likes
    IBOutlet UILabel*           lblSharedWith; //Number of Likes
//Comments
    IBOutlet UITableView*       tblComments;
//Footer
    IBOutlet UITextView*        tvComments;
}

@property (nonatomic, strong) NRReview*     review;
@property (nonatomic, strong) NSMutableArray* followings;

@end
