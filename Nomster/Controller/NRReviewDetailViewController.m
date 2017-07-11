//
//  NRReviewDetailViewController.m
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewDetailViewController.h"
#import "NRCommentCell.h"
#import "NRUserDetailViewController.h"

typedef enum
{
    ALERT_SHARE = 100,
    ALERT_FOLLOW
} eAlertViewType;

@interface NRReviewDetailViewController ()

@end

@implementation NRReviewDetailViewController

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
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapBackground:)];
    [tblComments addGestureRecognizer: recognizer];
    [self loadFollowings];
}

- (void) onTapBackground: (id) sender
{
    [tvComments resignFirstResponder];
}

- (void) loadFollowings
{
    self.followings = [NRMaster master].followings;
    if (self.followings && [self.followings count] > 0) {
        [self initFromReview];
    }
    else
    {
        if ([NRMaster master].user != nil) {
            [ZAActivityBar showWithStatus: @"Loading review information.."];
            [[NRAPIManager manager] followingUsers: [NRMaster master].user block:^(NSMutableArray *users) {
                [ZAActivityBar dismiss];
                [NRMaster master].followings = [NSMutableArray arrayWithArray: users];
                self.followings = [NRMaster master].followings;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initFromReview];
                });
            }];
        }
        else
        {
            [self initFromReview];
        }
    }
}

- (void) onBack: (id) sender
{
    if ([NRUIManager isIPad]) {
        [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

- (void) onUserPhoto: (id) sender
{
    [self performSegueWithIdentifier: @"sid_userprofile" sender: self];
}

- (void) initFromReview
{
    if (_review == nil) {
        return;
    }

    [imgUser setImageUrl: _review.user.avatarURL];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onUserPhoto:)];
    imgUser.userInteractionEnabled = YES;
    [imgUser addGestureRecognizer: tapGesture];
    
    lblUserName.text = _review.user.username;
    lblTime.text = [NSDate dateStringFromNRDateFormat: _review.created];
    lblAddress.text = _review.description;
    lblNumberOfOtherReviews.text = [NSString stringWithFormat: @"%d", (int)_review.user.numberOfReviews];
    lblRestaurant.text = _review.restaurant;
    
    lblFoodName.text = _review.title;
    lblCategory.text = _review.category.title;
    lblPrice.text = [NSString stringWithFormat: @"$%.2f", _review.price];
    ctrlRatings.rating = _review.ratings;
    lblRating.text = [NSString stringWithFormat: @"%d/5", (int)_review.ratings];
    
    lblNomed.text = [NSString stringWithFormat: @"%d People Nom'd This", (int)[_review.likes count]];
    [imgFood setImageUrl: _review.imageURL];

    if (_review.likes != nil && [_review.likes count] > 0) {
        btnUnlike.highlighted = NO;
        btnLike.highlighted = YES;
    }
    else
    {
        btnUnlike.highlighted = NO;
        btnLike.highlighted = NO;
    }
    
    CGFloat fontSize = 11;
    if ([NRUIManager isIPad]) {
        fontSize = 13;
    }

    [self updateFollowState];
    
    NSDictionary* boldAttr = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: fontSize]};
    NSDictionary* normalAttr = @{NSFontAttributeName: [UIFont systemFontOfSize: fontSize]};
    
    NSMutableString* taggedString = [NSMutableString stringWithString: @"Shared with: "];
    [_review.withs enumerateObjectsUsingBlock:^(NRUser* user, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [taggedString appendFormat: @"%@", user.fullName];
        }
        else
            [taggedString appendFormat: @", %@", user.fullName];
    }];
    NSMutableAttributedString* attribeString = [[NSMutableAttributedString alloc] initWithString: taggedString attributes: normalAttr];
    [attribeString addAttributes: boldAttr range: NSMakeRange(0, 12)];
    lblSharedWith.attributedText = attribeString;
    [tblComments reloadData];
}

- (void) updateFollowState
{
    if ([_review.user.userID isEqualToString: [NRMaster master].user.userID]) {
        [btnFollow setTitleColor: NR_COLOR_DARK_GRAY forState: UIControlStateNormal];
        btnFollow.backgroundColor = NR_COLOR_LIGHT_GRAY;
        btnFollow.enabled = NO;
    }
    else
    {
        if ([self isFollower: _review.user]) {
           [btnFollow setTitleColor: NR_COLOR_DARK_GRAY forState: UIControlStateNormal];
            btnFollow.backgroundColor = NR_COLOR_LIGHT_GRAY;
            btnFollow.enabled = NO;
            [btnFollow setTitle: @"Following" forState: UIControlStateNormal];
        }
        else
        {
            [btnFollow setTitleColor: NR_COLOR_WHITE forState: UIControlStateNormal];
            btnFollow.backgroundColor = NR_COLOR_GREEN;
            btnFollow.enabled = YES;
            [btnFollow setTitle: @"Follow" forState: UIControlStateNormal];
        }
    }
}

- (IBAction) onFollowUser: (UIButton*) sender
{
    NRCommentCell* cell = (id)sender.superview.superview.superview;
    if ([cell isKindOfClass: [NRCommentCell class]]) {
        //Follow User;
        [self followUser: cell.comment.user withName: cell.comment.user.username];
    }
}

- (IBAction) onFollowTheCreator:(id)sender
{
    [self followUser: _review.user withName: _review.user.username];
}

- (IBAction) onGetDirections:(id)sender
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = _review.latitude;
    coordinate.longitude = _review.longitude;
    [NRMaster directionToCoordinate: coordinate withName: _review.restaurant];
}

- (IBAction) onLike:(id)sender
{
    [ZAActivityBar showWithStatus: @"Comment being liked..."];
    [[NRAPIManager manager] likeReview:[NRMaster master].user review:_review block:^(NSError* error) {
        [ZAActivityBar dismiss];
        NSString* message = nil;
        if (error == nil) {
            message = @"Comment liked successfully";
            [_review like: [NRMaster master].user];
            btnUnlike.highlighted = NO;
            btnLike.highlighted = YES;
            lblNomed.text = [NSString stringWithFormat: @"%d People Nom'd This", (int)[_review.likes count]];
        }
        else
        {
            message = [error localizedDescription];
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
    }];
}

- (IBAction) onUnLike:(id)sender
{
    [ZAActivityBar showWithStatus: @"Comment being unliked..."];
    [[NRAPIManager manager] unlikeReview:[NRMaster master].user review:_review block:^(NSError* error) {
        [ZAActivityBar dismiss];
        NSString* message = nil;
        if (error == nil) {
            message = @"Comment unliked successfully";
            [_review unLike: [NRMaster master].user];
            btnLike.highlighted = NO;
            btnUnlike.highlighted = YES;
            lblNomed.text = [NSString stringWithFormat: @"%d People Nom'd This", (int)[_review.likes count]];
        }
        else
        {
            message = [error localizedDescription];
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
    }];
}

- (IBAction) onShare:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Sharing" message: nil delegate: self cancelButtonTitle: nil otherButtonTitles: @"Share via Facebook", @"Share via Twitter", @"Cancel",nil];
    alert.tag = ALERT_SHARE;
    [alert show];
}

- (IBAction) onPostComment:(id)sender
{
    if ([NRMaster master].user == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: @"Please log in first." delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
        [NRMaster checkAndShowLogin];
        return;
    }
    
    [ZAActivityBar showWithStatus: @"Posting Comment..."];
    [[NRAPIManager manager] commentReview: [NRMaster master].user  review: _review comment: tvComments.text block:^(NSError* error) {
        [ZAActivityBar dismiss];
        NSString* message = nil;
        if (error == nil) {
            message = @"Comment posted successfully";
            NRComment* comment = [NRComment new];
            comment.user = [NRMaster master].user;
            comment.review = _review;
            comment.comment = tvComments.text;
            [_review.comments addObject: comment];
            [tblComments reloadData];
            tvComments.text = @"";
        }
        else
        {
            message = [error localizedDescription];
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
    }];
}

- (void) followUser: (NRUser*) user withName: (NSString*) username
{
    if ([NRMaster master].user == nil) {
        return;
    }
    
    [ZAActivityBar showWithStatus: @"Following User..."];
    [[NRAPIManager manager] followUser: [NRMaster master].user toFollow: user block:^(NSError*error) {
        [self.followings addObject: user];
        [ZAActivityBar dismiss];
        NSString* message = nil;
        if (error == nil) {
            message = [NSString stringWithFormat: @"You are following %@ now.", username];
        }
        else
        {
            message = [error localizedDescription];
        }
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
        [alert show];
        [self updateFollowState];
        [tblComments reloadData];
    }];
}

- (IBAction) onAddToFavorite:(id)sender
{
    [[NRMaster master] addToFavorite: _review];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Alert" message: @"Review has just been added to your favorites list." delegate: nil cancelButtonTitle: nil otherButtonTitles: @"OK", nil];
    [alert show];
}

- (IBAction) onCommentit:(id)sender
{
    [tvComments becomeFirstResponder];
    [tblComments scrollRectToVisible:[tblComments convertRect: tblComments.tableFooterView.bounds fromView: tblComments.tableFooterView] animated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_SHARE) {
        if (buttonIndex == 0) {
            [NRMaster shareViaFacebook: _review];
        }
        else if (buttonIndex == 1)
        {
            [NRMaster shareViaTwitter: _review];
        }
    }
}

- (BOOL) isFollower: (NRUser*) user
{
    for (NRUser* usr in self.followings) {
        if ([user.userID isEqualToString: usr.userID])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_review.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"COMMENT_CELL";
    NRCommentCell *cell = (NRCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NRCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NRComment* comment = [_review.comments objectAtIndex: indexPath.row];
    
    if ([comment.user.userID isEqualToString: [NRMaster master].user.userID]) {
        cell.btnFollow.hidden = YES;
    }
    else
    {
        cell.btnFollow.hidden = NO;
    }
    
    if ([self isFollower: comment.user]) {
        cell.btnFollow.enabled = NO;
        cell.btnFollow.backgroundColor = NR_COLOR_LIGHT_GRAY;
        [cell.btnFollow setTitleColor: NR_COLOR_DARK_GRAY forState: UIControlStateNormal];
        [cell.btnFollow setTitle: @"Following" forState: UIControlStateNormal];
    }
    else
    {
        cell.btnFollow.enabled = YES;
        [cell.btnFollow setTitle: @"Follow User" forState: UIControlStateNormal];
        [cell.btnFollow setTitleColor: NR_COLOR_WHITE forState: UIControlStateNormal];
        cell.btnFollow.backgroundColor = NR_COLOR_GREEN;
    }
    [cell resetWithComment: comment];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NRComment* comment = [_review.comments objectAtIndex: indexPath.row];
    return [NRCommentCell heightForComment: comment];
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
    if ([textView.text isEqualToString: @"Comments"]) {
        textView.text = @"";
    }
    
    if (![NRUIManager isIPad]) {
        CGRect rt = self.view.frame;
        rt.origin.y = -100;
        [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            self.view.frame = rt;
        } completion: nil];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"Comments";
    }

    if (![NRUIManager isIPad]) {
        CGRect rt = self.view.frame;
        rt.origin.y = 64;
        [UIView animateWithDuration: 0.2f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            self.view.frame = rt;
        } completion: nil];
    }
}

#pragma mark Segue
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ([segue.identifier isEqualToString: @"sid_userprofile"])
    {
        NRUserDetailViewController* pController = (id) segue.destinationViewController;
        pController.user = _review.user;
    }
}

@end
