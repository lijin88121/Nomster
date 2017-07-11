//
//  NRFinishReviewViewController.h
//  Nomster
//
//  Created by Li Jin on 11/13/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRStarRatingControl.h"

@interface NRFinishReviewViewController : UIViewController <NRStarRatingDelegate>
@property (nonatomic, strong) IBOutlet NRStarRatingControl*     starControl;
@property (nonatomic, strong) IBOutlet UILabel*                 lblTitle;
@property (nonatomic, strong) IBOutlet UILabel*                 lblCategory;
@property (nonatomic, strong) IBOutlet UILabel*                 lblRestaurant;
@property (nonatomic, strong) IBOutlet UILabel*                 lblWithUsers;
@property (nonatomic, strong) IBOutlet UITextField*             txtPrice;
@property (nonatomic, strong) IBOutlet UITextView*              tvComments;
@property (nonatomic, strong) IBOutlet UIImageView*             imgPhoto;

@property (nonatomic, strong) NRReview*                         review;
@end
