//
//  NRSearchOptionViewController.m
//  Nomster
//
//  Created by Li Jin on 11/22/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRSearchOptionViewController.h"
#import "NRSearchOption.h"
#import "NRStarRatingControl.h"

@interface NRSearchOptionViewController ()

@end

@implementation NRSearchOptionViewController

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
    self.searchOption = [NRMaster master].searchOption;
    [self initView];
}

- (void) initView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_done_green"] style:UIBarButtonItemStyleBordered target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    lblRadius.text = [NSString stringWithFormat: @"%d Miles", (int)self.searchOption.radiusInMiles];
    sliderRadius.value = self.searchOption.radiusInMiles;
}

- (void) onBack: (id) sender
{
    if ([NRUIManager isIPad])
    {
        [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void) onDone: (id) sender
{
    [self applySearchOption];
    if (self.delegate && [self.delegate respondsToSelector: @selector(doSearch)]) {
        [self.delegate doSearch];
    }
    
    if ([NRUIManager isIPad])
    {
        [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void) applySearchOption
{
    if (self.searchOption) {
        self.searchOption.country = txtCountry.text;
        self.searchOption.state = txtState.text;
        self.searchOption.city = txtCity.text;
        self.searchOption.category = txtCategory.text;
        self.searchOption.price = [[txtPrice.text stringByReplacingOccurrencesOfString: @"$" withString: @""] floatValue];
        self.searchOption.restaurant = txtRestaurant.text;
        self.searchOption.radiusInMiles = sliderRadius.value;
        self.searchOption.ratings = ratingControl.rating;
    }
}

#pragma UISliderValue Event
- (IBAction) onSliderChanged:(id)sender
{
    lblRadius.text = [NSString stringWithFormat: @"%d Miles", (int)sliderRadius.value];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    int offset = MAX(0, textField.superview.frame.origin.y - self.view.frame.size.height + 216 + 44);
    if (offset > 0) {
        CGRect rt = self.view.frame;
        rt.origin.y = -offset;
        [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            self.view.frame = rt;
        } completion: nil];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect rt = self.view.frame;
    rt.origin.y = 0;
    [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
        self.view.frame = rt;
    } completion: nil];
    
    [textField resignFirstResponder];
    return YES;
}


@end
