//
//  NRMyReviewsViewController.h
//  Nomster
//
//  Created by Li Jin on 11/18/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
#import "NRReviewListViewController.h"

@interface NRMyReviewsViewController : NRBaseViewController <NRReviewListViewControllerDelegate>
{
    BOOL  isNeededToReload;
}
@property (nonatomic, strong) NRReviewListViewController* reviewListController;
@end
