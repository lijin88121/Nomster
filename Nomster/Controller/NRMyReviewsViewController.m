//
//  NRMyReviewsViewController.m
//  Nomster
//
//  Created by Li Jin on 11/18/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRMyReviewsViewController.h"
#import "NRReviewDetailViewController.h"

@interface NRMyReviewsViewController ()

@end

@implementation NRMyReviewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reviewListController = (id)[NRUIManager loadViewController: @"sid_reviewlistviewcontroller"];
    self.reviewListController.delegate = self;
    [self.view addSubview: self.reviewListController.view];
    isNeededToReload = YES;
    if (![NRUIManager isIPad])
    {
        self.reviewListController.view.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        self.reviewListController.view.frame = CGRectMake(0, 64, 768, 960);
    }
    [self addChildViewController: self.reviewListController];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (isNeededToReload) {
        [self.reviewListController reloadData];
        isNeededToReload = NO;
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

#pragma mark NRReviewListViewDelegate
- (void) requestReviewsForController: (NRReviewListViewController*) controller block: (void(^)(NSArray* reviews, NSError* error)) block
{
    if ([NRMaster master].user == nil) {
        block(nil, nil);
    }

    [ZAActivityBar showWithStatus: @"Loading Your Reviews..."];
    [[NRAPIManager manager] reviewOfUser: [NRMaster master].user block:^(NSMutableArray *arrayReviews) {
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

- (void) reviewListViewController: (NRReviewListViewController*) controller didReviewSelected: (NRReview*) review
{
    if (!review.finished) {
        isNeededToReload = YES;
        [NRMaster processFinishReview: review];
    }
    else
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

@end

