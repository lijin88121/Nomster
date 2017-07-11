//
//  NRCategoriesViewController.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRCategoriesViewController.h"

@interface NRCategoriesViewController ()

@end

@implementation NRCategoriesViewController

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
    self.categories = [NRMaster master].categories;
    if (self.categories == nil || [self.categories count] == 0) {
        [self loadCategory];
    }
    else
    {
        [_tblCategories reloadData];
    }
}

- (void) loadCategory
{
    [[NRAPIManager manager] getCategoriesWithBlock:^(NSMutableArray* arrayCategories) {
        self.categories = arrayCategories;
        [_tblCategories reloadData];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VenueCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 13];
    }
    
	cell.textLabel.text = [(NRCategory*)[self.categories objectAtIndex: indexPath.row] title];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector: @selector(categorySelected:)]) {
        [self.delegate categorySelected: [self.categories objectAtIndex: indexPath.row]];
        [self.navigationController popViewControllerAnimated: YES];
    }
}

@end
