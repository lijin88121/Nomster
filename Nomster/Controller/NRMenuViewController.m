//
//  NRMenuViewController.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRMenuViewController.h"
#import "NRMenuCell.h"
#import "NRMenuSection.h"

@implementation NRMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 238, 237);
    self.tblMenu.backgroundColor = RGB(240, 238, 237);
    [NRUIManager manager].menuViewController = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self resetMenu];
}

- (void) resetMenu
{
    if (self.menuSections != nil) {
        [self.menuSections removeAllObjects];
    }
    else
    {
        self.menuSections = [NSMutableArray array];
    }
    
    if ([NRMaster master].user != nil) {
        NRMenuSection* section = [NRMenuSection menuSectionWithTitle: [NSString stringWithFormat: @"WELCOME %@", [NRMaster master].user.fullName] withIndex: 0];
        NRMenuItem* item = [NRMenuItem itemWithTitle: @"Home" image: @"icon_sidebar_home" segue: @"sid_home"];
        [section addItem: item];
        item = [NRMenuItem itemWithTitle: @"Followers" image: @"icon_sidebar_followers" segue: @"sid_follower"];
        [section addItem: item];
        [self.menuSections addObject: section];
    }
    
    NRMenuSection* section = [NRMenuSection menuSectionWithTitle: @"REVIEWS" withIndex: 1];
    NRMenuItem* item = nil;
    if ([NRMaster master].user == nil) {
        item = [NRMenuItem itemWithTitle: @"News Feed" image: @"icon_sidebar_newsfeed" segue: @"sid_home"];
        [section addItem: item];
    }
    item = [NRMenuItem itemWithTitle: @"Create Review" image: @"icon_sidebar_photo" segue: @"sid_createreview"];
    [section addItem: item];
    item = [NRMenuItem itemWithTitle: @"Search and Explore" image: @"icon_sidebar_explore" segue: @"sid_explore"];
    [section addItem: item];
    item = [NRMenuItem itemWithTitle: @"Recommendations" image: @"icon_sidebar_recommend" segue: @"sid_recommended"];
    [section addItem: item];
    item = [NRMenuItem itemWithTitle: @"Your Reviews" image: @"icon_sidebar_yourreview" segue: @"sid_myreview"];
    [section addItem: item];
    item = [NRMenuItem itemWithTitle: @"Favorites" image: @"icon_sidebar_favorites" segue: @"sid_favorites"];
    [section addItem: item];
    [self.menuSections addObject: section];

    section = [NRMenuSection menuSectionWithTitle: @"SETTINGS" withIndex: 2];
    item = [NRMenuItem itemWithTitle: @"Settings" image: nil segue: @"sid_settings"];
    [section addItem: item];
    item = [NRMenuItem itemWithTitle: @"Contact Us" image: nil segue: @"sid_contactus"];
    [section addItem: item];
    [self.menuSections addObject: section];
    
    [_tblMenu reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.menuSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NRMenuSection* _section = [self.menuSections objectAtIndex: section];
    return [_section.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NRMenuCell";
    NRMenuCell *cell = (NRMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NRMenuCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    NRMenuSection* section = [self.menuSections objectAtIndex: indexPath.section];
    NRMenuItem* item = [section.menuItems objectAtIndex: indexPath.row];
	cell.textLabel.text = item.title;
	cell.imageView.image = [UIImage imageNamed: item.imageName];
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 45.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = [[self.menuSections objectAtIndex: section] title];
    
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 45.0f)];
        CALayer* layer = [CALayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.frame = headerView.bounds;
        [headerView.layer insertSublayer: layer atIndex: 0];
        
		UILabel *textLabel = [[UILabel alloc] initWithFrame: CGRectMake(20.0f, 15, 300, 30)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont boldSystemFontOfSize: 15.0f];
		textLabel.textColor = NR_COLOR_BRIGHT;
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 45.0f, 300, 1.0f)];
		bottomLine.backgroundColor = NR_COLOR_BRIGHT;
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NRMenuSection* section = [self.menuSections objectAtIndex: indexPath.section];
    NRMenuItem* item = [section.menuItems objectAtIndex: indexPath.row];
    [self performSegueWithIdentifier: item.segueName  sender: self];
}

#pragma mark Segue
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        if ([segue.identifier isEqualToString: @"sid_recommended"] ||
            [segue.identifier isEqualToString: @"sid_myreview"] ||
            [segue.identifier isEqualToString: @"sid_createreview"]) {
            if (![NRMaster checkAndShowLogin]) {
                return;
            }
        }
        
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        if ([rvc.frontViewController isKindOfClass: [UINavigationController class]]) {
            UIViewController* viewController = [[(UINavigationController*)rvc.frontViewController viewControllers] objectAtIndex:0];
            if ([viewController.restorationIdentifier isEqualToString: [segue.destinationViewController restorationIdentifier]]) {
                [rvc setFrontViewController: rvc.frontViewController animated: YES];
                return;
            }
        }
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController: dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
    else
    {
        if ([segue.identifier isEqualToString: @"sid_createreview"] ||
            [segue.identifier isEqualToString: @"sid_settings"]) {
            if (![NRMaster checkAndShowLogin]) {
                return;
            }
        }
    }
}
@end
