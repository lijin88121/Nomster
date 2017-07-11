//
//  NRReviewSharedViewController.m
//  Nomster
//
//  Created by Li Jin on 12/9/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewSharedViewController.h"
#import "UIViewController+Font.h"

@interface NRReviewSharedViewController ()

@end

@implementation NRReviewSharedViewController

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
    self.lblUserName.text = [NSString stringWithFormat: @"%@,", [NRMaster master].user.username];
    [self applyFont: FONT_HELVETICANEUE_NORMAL boldfontname: FONT_ARISTA];
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapped:)];
    [self.view addGestureRecognizer: recognizer];
}

- (void) onTapped: (id) sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
