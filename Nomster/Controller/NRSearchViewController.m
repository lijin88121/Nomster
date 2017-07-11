//
//  NRSearchViewController.m
//  Nomster
//
//  Created by Li Jin on 11/22/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRSearchViewController.h"
#import "NRSearchOption.h"
#import "NRReviewDetailViewController.h"

@interface NRSearchViewController ()

@end

@implementation NRSearchViewController

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

    [[NRMaster master].searchOption reset];

    self.reviewListController = (id)[NRUIManager loadViewController: @"sid_reviewlistviewcontroller"];
    self.reviewListController.delegate = self;
    [self.view addSubview: self.reviewListController.view];
    CGRect rtContent = CGRectMake(0, CGRectGetMaxY(_vwDistance.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_vwDistance.frame));
    self.reviewListController.view.frame = rtContent;
    [self addChildViewController: self.reviewListController];
    [self.reviewListController reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    _lblRadius.text = [NSString stringWithFormat: @"%d Miles", (int) [NRMaster master].searchOption.radiusInMiles];
    self.reviewListController.view.frame = CGRectMake(0, CGRectGetMaxY(_vwDistance.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_vwDistance.frame));
}

- (IBAction) onCustom: (id) sender
{
    [self performSegueWithIdentifier: @"sid_searchoption" sender: self];
}

#pragma mark Segue
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: @"sid_searchoption"])
    {
        NRSearchOptionViewController* optionController = segue.destinationViewController;
        if ([optionController isKindOfClass: [UINavigationController class]]) {
            optionController = [((UINavigationController*)optionController).viewControllers firstObject];
        }
        optionController.delegate = self;
    }
}

#pragma mark NRReviewListViewDelegate
- (void) requestReviewsForController: (NRReviewListViewController*) controller block: (void(^)(NSArray* reviews, NSError* error)) block
{
    [ZAActivityBar showWithStatus: @"Searching Reviews..."];
    [[NRAPIManager manager] searchReviewBySearchOption: [NRMaster master].searchOption block:^(NSMutableArray *arrayReviews) {
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

#pragma mark NRSearchOptionViewControllerDelegate
- (void) doSearch
{
    _lblRadius.text = [NSString stringWithFormat: @"%d Miles", (int) [NRMaster master].searchOption.radiusInMiles];
    [self.reviewListController reloadData];
}

@end
