//
//  NRReviewThumbView.m
//  Nomster
//
//  Created by Li Jin on 11/15/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewThumbView.h"

#define LEFT_MARGIN     3

@implementation NRReviewThumbView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initSubView];
    }
    return self;
}

+ (id) thumbViewWithReview: (NRReview*) review
{
    NRReviewThumbView* thumbView = nil;
    if ([NRUIManager isIPad]) {
        thumbView = (id)[[[NSBundle mainBundle] loadNibNamed: @"NRReviewThumbView_iPad" owner: nil options: nil] firstObject];
    }
    else
    {
        thumbView = (id)[[[NSBundle mainBundle] loadNibNamed: @"NRReviewThumbView_iPhone" owner: nil options: nil] firstObject];
    }
    thumbView.review = review;
    return thumbView;
}

- (void) initSubView
{
    self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent: 0.5f].CGColor;
    self.layer.borderWidth = 1.0f;
}

- (void) applyData
{
    imgReview.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent: 0.2f].CGColor;
    imgReview.layer.borderWidth = 0.1f;
    imgReview.image = [UIImage imageNamed: @"no_image"];

    starRatingControl.backgroundColor = [UIColor clearColor];
    if (!_review.finished) {
        imgUser.hidden = YES;
        lblStillEating.text = @"Still eating this dish";
        if ([_review.user.userID isEqualToString: [NRMaster master].user.userID]) {
            lblTitle.text = @"FINISH YOUR REVIEW";
            vwDescription.backgroundColor = RGB(239,106,8);
            lblTitle.backgroundColor = RGB(239,106,8);
        }
        else
        {
            lblTitle.text = [NSString stringWithFormat: @"%@ is currently eating", _review.user.username];
            vwDescription.backgroundColor = NR_COLOR_GREEN;
            lblTitle.backgroundColor = NR_COLOR_GREEN;
            lblStillEating.text = _review.title;
        }
        
        lblStillEating.hidden = NO;
        lblRestaurant.textColor = [UIColor whiteColor];
        lblLocation.textColor = [UIColor whiteColor];
        starRatingControl.hidden = YES;
        imgRibbon.hidden = YES;
    }
    else
    {
        imgUser.hidden = NO;
        lblTitle.text = _review.title;
        lblStillEating.hidden = YES;
        vwDescription.backgroundColor = [UIColor clearColor];
        lblTitle.backgroundColor = NR_COLOR;
        
        lblRestaurant.textColor = NR_COLOR;
        lblLocation.textColor = [UIColor blackColor];
        imgRibbon.hidden = NO;
        starRatingControl.hidden = NO;
        
        if (_review.user.avatar) {
            [imgUser setImage: _review.user.avatar];
        }
        else
        {
            [imgUser setImageUrl: _review.user.avatarURL];
        }
    }

    lblRestaurant.text = _review.restaurant;
    starRatingControl.rating = _review.ratings;
    lblLocation.text = _review.description;
    
    [activity startAnimating];
    [imgReview loadImageWithURL: [NSURL URLWithString: _review.thumbURL] block:^(BOOL bSuccess) {
        [activity stopAnimating];
    }];
    
    //    if (_review.likes == nil || [_review.likes count] == 0) {
    //        _btnBadge.hidden = YES;
    //    }
    //    else
    //    {
    //        [_btnBadge setTitle: [NSString stringWithFormat: @"%d", (int)[_review.likes count]] forState: UIControlStateNormal];
    //    }
}

- (void) setReview:(NRReview *)review
{
    _review = review;
    [self applyData];
}

@end
