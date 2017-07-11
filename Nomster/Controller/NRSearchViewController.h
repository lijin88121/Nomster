//
//  NRSearchViewController.h
//  Nomster
//
//  Created by Li Jin on 11/22/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRBaseViewController.h"
#import "NRSearchOptionViewController.h"
#import "NRReviewListViewController.h"

@interface NRSearchViewController : NRBaseViewController <NRSearchOptionViewControllerDelegate, NRReviewListViewControllerDelegate>
@property (nonatomic, strong) IBOutlet UIView*              vwDistance;
@property (nonatomic, strong) IBOutlet UILabel*             lblRadius;
@property (nonatomic, strong) NSMutableArray*               reviews;
@property (nonatomic, strong) NRReviewListViewController*   reviewListController;

@end
