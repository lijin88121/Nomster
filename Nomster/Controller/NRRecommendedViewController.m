//
//  NRRecommendedViewController.m
//  Nomster
//
//  Created by Li Jin on 11/8/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRRecommendedViewController.h"
#import "NRReviewListViewController.h"
#import "NRReviewGroup.h"
#import "NRReviewGroupCell.h"
#import "NRReviewDetailViewController.h"

@interface NRRecommendedViewController ()

@end

@implementation NRRecommendedViewController

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
    [self loadRecommendedReviews];
}

- (void) loadRecommendedReviews
{
    if ([NRMaster master].user == nil) {
        return;
    }
    
    [ZAActivityBar showWithStatus: @"Loading Reviews..."];
    [[NRAPIManager manager] recommendedReview: [NRMaster master].user latitude: [NRMaster master].currentLocation.coordinate.latitude longitude: [NRMaster master].currentLocation.coordinate.longitude block:^(NSMutableArray *reviews, NRReview* review) {
        _topReview = review;
        if (_topReview == nil) {
            _tblCategory.tableHeaderView.hidden = YES;
            _tblCategory.tableHeaderView = nil;
        }
        else
        {
            [self configureHeaderWithReview: _topReview];
        }
        [self separateReviewsToGroups: reviews];
        [ZAActivityBar dismiss];
    }];
}

- (void) configureHeaderWithReview: (NRReview*) review
{
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTopReviewDetail:)];
    [vwHeaderBack addGestureRecognizer: recognizer];
    
    lblFoodName.text = review.title;
    lblAddress.text = review.description;
    lblCategory.text = review.category.title;
    lblPrice.text = [NSString stringWithFormat: @"$%.2f", review.price];
    ctrlRatings.rating = review.ratings;
    [imgFood setImageUrl: review.imageURL];
}

- (void) onTopReviewDetail: (id) sender
{
    NRReviewDetailViewController* pController = (id)[NRUIManager loadViewController: @"sid_reviewdetailviewcontroller"];
    pController.title = _topReview.title;
    pController.review = _topReview;
    
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

- (IBAction) onTopReviewDirection:(id)sender
{
    if (_topReview) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = _topReview.latitude;
        coordinate.longitude = _topReview.longitude;
        [NRMaster directionToCoordinate: coordinate withName: _topReview.restaurant];
    }
}

- (NRReviewGroup*) reviewGroupByCategory: (NRCategory*) category
{
    for (NRReviewGroup* group in self.reviewGroups) {
        if ([group.category.title isEqualToString: category.title]) {
            return group;
        }
    }
    return nil;
}

- (void) addReviewToGroups: (NRReview*) review
{
    if (self.reviewGroups == nil ) {
        self.reviewGroups = [NSMutableArray array];
    }
    
    NRReviewGroup* group = [self reviewGroupByCategory: review.category];
    if (group == nil) {
        group = [NRReviewGroup new];
        [self.reviewGroups addObject: group];
    }
    
    if (group.category == nil) {
        group.category = review.category;
    }
    if (group.thumbnailImage == nil) {
        group.thumbnailImage = review.imageURL;
    }
    [group addReview: review];
}

- (void) separateReviewsToGroups: (NSMutableArray*) reviews
{
    for (NRReview* review in reviews) {
        [self addReviewToGroups: review];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tblCategory reloadData];
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.reviewGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ReviewGroupCell";
    NRReviewGroupCell *cell = (NRReviewGroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NRReviewGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NRReviewGroup* group = [self.reviewGroups objectAtIndex: indexPath.row];
    [cell resetWithGroup: group];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedGroup = [self.reviewGroups objectAtIndex: indexPath.row];
    [self performSegueWithIdentifier: @"sid_reviewlist" sender: self];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"sid_reviewlist"]) {
        NRReviewListViewController* pController = segue.destinationViewController;
        pController.edgesForExtendedLayout = UIRectEdgeNone;
        pController.reviews = self.selectedGroup.reviews;
        pController.title = self.selectedGroup.category.title;
    }
}
@end
