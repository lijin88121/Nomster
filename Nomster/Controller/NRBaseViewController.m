//
//  NRBaseViewController.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"

@implementation NRBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSLog(@"%f",version);

    UIImageView *titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"img_logo_nomster"]];
    [self.navigationController.navigationBar.topItem setTitleView:titleView];
    
    if (self.revealButtonItem) {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector(rightRevealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown) ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) : YES;
}

- (BOOL)shouldAutorotate {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSUInteger)supportedInterfaceOrientations{
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
