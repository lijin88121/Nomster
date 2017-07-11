//
//  NRHomeViewController.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRHomeViewController.h"
#import "NRSearchOption.h"
#import "NRReviewDetailViewController.h"

@implementation NRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NRMaster master].searchOption reset];
    
    self.reviewListController = (id)[NRUIManager loadViewController: @"sid_reviewlistviewcontroller"];
    self.reviewListController.delegate = self;
    [self.view addSubview: self.reviewListController.view];
    if (![NRUIManager isIPad])
    {
        self.reviewListController.view.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        self.reviewListController.view.frame = CGRectMake(0, 64, 768, 960);
    }
    [self addChildViewController: self.reviewListController];
    [self.reviewListController reloadData];
}

#pragma mark NRReviewListViewDelegate
- (void) requestReviewsForController: (NRReviewListViewController*) controller block: (void(^)(NSArray* reviews, NSError* error)) block
{
    [ZAActivityBar showWithStatus: @"Loading Reviews..."];
    if ([NRMaster master].user == nil) {
        [[NRAPIManager manager] searchReviewBySearchOption: [NRSearchOption new] block:^(NSMutableArray *arrayReviews) {
            [ZAActivityBar dismiss];
            if (arrayReviews == nil) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Loading Reviews Failure" message: @"Please try a bit later. Your network status seems not so good" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [alert show];
                block(nil, nil);
            }
            else
            {
                block(arrayReviews, nil);
            }
        }];
    }
    else
    {
        [[NRAPIManager manager] followerReviews: [NRMaster master].user block:^(NSMutableArray *reviews) {
            [ZAActivityBar dismiss];
            if (reviews == nil) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Loading Reviews Failure" message: @"Please try a bit later. Your network status seems not so good" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [alert show];
                block(nil, nil);
            }
            else
            {
                block(reviews, nil);
            }
        }];
    }
}

- (void) reviewListViewController: (NRReviewListViewController*) controller didReviewSelected: (NRReview*) review
{
    if (review.finished)
    {
            NRReviewDetailViewController* pController = (id)[NRUIManager loadViewController: @"sid_reviewdetailviewcontroller"];
            pController.title = review.title;
            pController.review = review;
        
            if ([NRUIManager isIPad]) {
                UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: pController];
                navController.modalPresentationStyle = UIModalPresentationFormSheet;
                [[NRUIManager manager].revealViewController presentViewController: navController animated: YES completion: nil];
            }
            else
            {
                [self.navigationController pushViewController: pController animated: YES];
            }
    }
}

- (IBAction) onCreateNew:(id)sender
{
    if ([NRMaster master].user == nil) {
        [self.revealViewController performSegueWithIdentifier: @"sid_login" sender: nil];
    }
    else
    {
        [self.revealViewController performSegueWithIdentifier: @"sid_createreview" sender: nil];
    }
}
@end
