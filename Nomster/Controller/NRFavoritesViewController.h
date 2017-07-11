//
//  NRFavoritesViewController.h
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
#import "NRReviewListViewController.h"

@interface NRFavoritesViewController : NRBaseViewController <NRReviewListViewControllerDelegate>
@property (nonatomic, strong) NRReviewListViewController* reviewListController;

@end
