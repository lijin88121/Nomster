//
//  NRHomeViewController.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
#import "NRReviewListViewController.h"

@interface NRHomeViewController : NRBaseViewController <NRReviewListViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray*               reviews;
@property (nonatomic, strong) NRReviewListViewController*   reviewListController;
@end
