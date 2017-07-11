//
//  NRUserDetailViewController.m
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRUserDetailViewController.h"
#import "NRReviewDetailViewController.h"

@interface NRUserDetailViewController ()

@end

@implementation NRUserDetailViewController

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
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    if (_user != nil) {
        [_imgAvatar setImageUrl: _user.avatarURL];
        _lblUsername.text = _user.username;
    }
    [self loadUserReviews];
    [self loadFollowingState];
}

- (void) loadFollowingState
{
    NSMutableArray* followings = [NRMaster master].followings;
    if (followings == nil || [followings count] == 0)
    {
        [ZAActivityBar showWithStatus: @"Loading following users..."];
        [[NRAPIManager manager] followingUsers: [NRMaster master].user block:^(NSMutableArray *users) {
            [ZAActivityBar dismiss];
            [NRMaster master].followings = [NSMutableArray arrayWithArray: users];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateFollowingState];
            });
        }];
    }
    else
    {
        [self updateFollowingState];
    }
}

- (void) updateFollowingState
{
    BOOL bAlreadyFollowing = NO;
    for (NRUser* user in [NRMaster master].followings) {
        if ([user.userID isEqualToString: _user.userID]) {
            bAlreadyFollowing = YES;
            break;
        }
    }
    
    if (bAlreadyFollowing) {
        _btnFollow.enabled = NO;
        _btnFollow.backgroundColor = NR_COLOR_LIGHT_GRAY;
        [_btnFollow setTitleColor: NR_COLOR_DARK_GRAY forState: UIControlStateNormal];
        [_btnFollow setTitle: @"Following" forState: UIControlStateNormal];
    }
    else
    {
        _btnFollow.enabled = YES;
        [_btnFollow setTitle: @"Follow User" forState: UIControlStateNormal];
        [_btnFollow setTitleColor: NR_COLOR_WHITE forState: UIControlStateNormal];
        _btnFollow.backgroundColor = NR_COLOR_GREEN;
    }
}

- (void) onBack: (id) sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) loadUserReviews
{
    if (self.user != nil) {
        self.reviewListController = (id)[NRUIManager loadViewController: @"sid_reviewlistviewcontroller"];
        self.reviewListController.delegate = self;
        [self.view addSubview: self.reviewListController.view];
        if (![NRUIManager isIPad])
        {
            self.reviewListController.view.frame = CGRectMake(0, 50, 320, [UIScreen mainScreen].applicationFrame.size.height - 24);
        }
        else
        {
            self.reviewListController.view.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70);
        }
        
        [self addChildViewController: self.reviewListController];
        [self.reviewListController reloadData];
    }
}

#pragma mark NRReviewListViewDelegate
- (void) requestReviewsForController: (NRReviewListViewController*) controller block: (void(^)(NSArray* reviews, NSError* error)) block
{
    if (self.user == nil) {
        block(nil, nil);
    }
    
    [ZAActivityBar showWithStatus: @"Loading Reviews..."];
    [[NRAPIManager manager] reviewOfUser: _user block:^(NSMutableArray *arrayReviews) {
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

- (IBAction) onFollow:(id)sender
{
    [ZAActivityBar showWithStatus: @"Following User..."];
    [[NRAPIManager manager] followUser: [NRMaster master].user toFollow: _user block:^(NSError*error) {
        [ZAActivityBar dismiss];
        NSString* message = nil;
        if (error == nil) {
            [[NRMaster master].followings addObject: _user];
            [self updateFollowingState];
            message = [NSString stringWithFormat: @"You are following %@ now.", _user.username];
        }
        else
        {
            message = [error localizedDescription];
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
    }];
}
@end
