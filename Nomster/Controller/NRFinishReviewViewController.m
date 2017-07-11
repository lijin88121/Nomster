//
//  NRFinishReviewViewController.m
//  Nomster
//
//  Created by Li Jin on 11/13/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRFinishReviewViewController.h"
#import "NRMenuViewController.h"

@interface NRFinishReviewViewController ()

@end

@implementation NRFinishReviewViewController

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
    [self initView];
    [self initFromReview];
}

- (void) initFromReview
{
    if (_review == nil) {
        return;
    }
    
    _lblTitle.text = _review.title;
    _lblCategory.text = _review.category.title;
    _lblRestaurant.text = _review.restaurant;
    
    NSMutableString*    taggedString = [NSMutableString string];
    [_review.withs enumerateObjectsUsingBlock:^(NRUser* user, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [taggedString appendFormat: @"%@", user.fullName];
        }
        else
            [taggedString appendFormat: @", %@", user.fullName];
    }];
    _lblWithUsers.text = taggedString;
    [_imgPhoto setImageUrl: _review.imageURL];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapBackground:)];
    [self.view addGestureRecognizer: recognizer];
}

- (void) onTapBackground: (id) sender
{
    [_txtPrice resignFirstResponder];
    [_tvComments resignFirstResponder];
}

- (void) initView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_share"] style:UIBarButtonItemStyleBordered target:self action:@selector(onShare:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) onBack: (id) sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) onShare: (UIBarButtonItem*) sender
{
    if ([self checkInputedData] == NO) {
        return;
    }
    
    sender.enabled = NO;
    [[NRAPIManager manager] finishReview: _review withComment: _tvComments.text withPrice: _txtPrice.text withRatings: _starControl.rating block: ^(NSError* error) {
        if (error == nil) {
            [NRMaster checkAndRemoveFromLocalNotification: _review];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Success" message: @"You have successfully finished your review." delegate: self cancelButtonTitle: nil otherButtonTitles: @"Ok", nil];
            [alert show];
            
            NRMenuViewController* menuController = [NRUIManager manager].menuViewController;
            [menuController performSegueWithIdentifier: @"sid_myreview" sender: menuController];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Failure" message: @"Try again a bit later, please" delegate: nil cancelButtonTitle: nil otherButtonTitles: @"Ok", nil];
            [alert show];
        }
        sender.enabled = YES;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (BOOL) checkInputedData
{
    NSString* message = nil;
    if ([_txtPrice.text length] == 0) {
        message = @"Please input the price of the food";
    }
    else if ([_tvComments.text length] == 0 || [_tvComments.text isEqualToString: @"Tell us more about your experience"])
    {
        message = @"Please give some comments to the food.";
    }
    if (_starControl.rating == 0) {
        message = @"Please give any rating to the food.";
    }
    
    if (message) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Warnning" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"Ok", nil];
        [alert show];
        return NO;
    }
    return YES;
}

#pragma mark NRStarRatingControl
-(void)newRating:(NRStarRatingControl *)control :(float)rating
{
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (![NRUIManager isIPad]) {
        CGRect rt = self.view.frame;
        rt.origin.y = -100;
        [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            self.view.frame = rt;
        } completion: nil];
    }
    if ([textView.text isEqualToString: @"Tell us more about your experience"]) {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![NRUIManager isIPad]) {
        CGRect rt = self.view.frame;
        rt.origin.y = 0;
        [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            self.view.frame = rt;
        } completion: nil];
    }
    if (textView.text.length == 0) {
        textView.text = @"Tell us more about your experience";
    }
}
@end
