//
//  NRCreateReviewViewController.h
//  Nomster
//
//  Created by Li Jin on 11/8/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRVenueViewController.h"
#import "NRCategoriesViewController.h"
#import "NRTagPeopleViewController.h"

@interface NRCreateReviewViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, NRVenueViewControllerDelegate, NRCategoriesViewControllerDelegate, NRTagPeopleViewControllerDelegate>
{
    BOOL        isPhotoTaken;
    BOOL        isNeededToShareDirectly;
}

@property (nonatomic, strong) IBOutlet UIImageView*     imgPhoto;
@property (nonatomic, strong) IBOutlet UITableView*     tblOption;
@property (nonatomic, strong) NSMutableDictionary*      optionItems;
@property (nonatomic, strong) NRVenue*                  selectedVenue;
@property (nonatomic, strong) NRCategory*               selectedCategory;
@property (nonatomic, strong) NSMutableArray*           taggedPeople;
@property (nonatomic, strong) IBOutlet UITextView*      tvTitle;
@end
