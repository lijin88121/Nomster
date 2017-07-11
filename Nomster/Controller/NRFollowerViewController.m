//
//  NRFollowerViewController.m
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRFollowerViewController.h"
#import "NRFollowerCell.h"
#import "NRUserDetailViewController.h"

@interface NRFollowerViewController ()

@end

@implementation NRFollowerViewController

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
    [self loadFollowers];
}

- (void) loadFollowers
{
    self.followers = [NRMaster master].followings;
    if (self.followers && [self.followers count] > 0) {
        [_tblFollowers reloadData];
    }
    else
    {
        [[NRAPIManager manager] followingUsers: [NRMaster master].user block:^(NSMutableArray *users) {
            [NRMaster master].followings = [NSMutableArray arrayWithArray: users];
            self.followers = [NRMaster master].followings;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tblFollowers reloadData];
            });
        }];
    }
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NRUIManager isIPad]) {
        return 70;
    }
    else
        return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.followers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FOLLOWER_CELL";
    NRFollowerCell *cell = (NRFollowerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NRFollowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NRUser* user = [_followers objectAtIndex: indexPath.row];
    [cell resetWithUser: user];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    selectedUser = [_followers objectAtIndex: indexPath.row];
    [self performSegueWithIdentifier: @"sid_userdetail" sender: self];
}

#pragma mark Segue
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: @"sid_userdetail"])
    {
        NRUserDetailViewController* pController = (id) segue.destinationViewController;
        pController.user = selectedUser;
    }
}

@end
