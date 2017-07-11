//
//  NRSearchOptionViewController.h
//  Nomster
//
//  Created by Li Jin on 11/22/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NRSearchOption;
@class NRStarRatingControl;

@protocol NRSearchOptionViewControllerDelegate <NSObject>
- (void) doSearch;
@end

@interface NRSearchOptionViewController : UIViewController
{
    IBOutlet UISlider*      sliderRadius;
    IBOutlet UILabel*       lblRadius;
    IBOutlet UITextField*   txtCountry;
    IBOutlet UITextField*   txtState;
    IBOutlet UITextField*   txtCity;
    IBOutlet UITextField*   txtCategory;
    IBOutlet UITextField*   txtPrice;
    IBOutlet UITextField*   txtRestaurant;
    IBOutlet NRStarRatingControl*   ratingControl;
}

@property (nonatomic, assign) NRSearchOption* searchOption;
@property (nonatomic, strong) id<NRSearchOptionViewControllerDelegate> delegate;
@end
