//
//  NRFavoritesViewController.m
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRFavoritesViewController.h"
#import "NRReviewDetailViewController.h"

@interface NRFavoritesViewController ()

@end

@implementation NRFavoritesViewController

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
    if (![NRUIManager isIPad])
    {
        self.reviewListController.view.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].applicationFrame.size.height - 44);
    }
    else
    {
        self.reviewListController.view.frame = CGRectMake(0, 64, 768, 960 );
    }
    [self addChildViewController: self.reviewListController];
    [self.reviewListController reloadData];
}


#pragma mark NRReviewListViewDelegate
- (void) requestReviewsForController: (NRReviewListViewController*) controller block: (void(^)(NSArray* reviews, NSError* error)) block
{
    block([NRMaster master].favorites, nil);
}

- (void) reviewListViewController: (NRReviewListViewController*) controller didReviewSelected: (NRReview*) review
{
    if (!review.finished) {
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
