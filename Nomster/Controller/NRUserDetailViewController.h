//
//  NRUserDetailViewController.h
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRReviewListViewController.h"

@interface NRUserDetailViewController : UIViewController <NRReviewListViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray*               reviews;
@property (nonatomic, strong) NRReviewListViewController*   reviewListController;
@property (nonatomic, strong) NRUser*                       user;

@property (nonatomic, weak) IBOutlet NRCircularImageView*   imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel*               lblUsername;
@property (nonatomic, weak) IBOutlet UIButton*              btnFollow;
@end
