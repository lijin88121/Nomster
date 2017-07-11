//
//  NRReviewListView.m
//  Nomster
//
//  Created by Li Jin on 11/15/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewListView.h"
#import "NRReviewThumbView.h"

#define CELL_GAP                5
#define NRTHUMBVIEW_TAGBASE     100

@implementation NRReviewListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView
{
    if (self.scrollView == nil) {
        self.scrollView = [UIScrollView new];
        [self addSubview: self.scrollView];
    }
}

- (void) resetLayout: (BOOL) animated
{
    if ([NRUIManager isIPad]) {
        if (self.bounds.size.width > self.bounds.size.height) {
             cellWidth = 246;
             self.cols = 4;
        }
        else
        {
            cellWidth = 246;
            self.cols = 3;
        }
    }
    else
    {
        cellWidth = 146;
        self.cols = 2;
    }
    
    self.scrollView.frame = self.bounds;
    
    CGFloat animateDuration = 0.0f;
    if (animated) {
        animateDuration = 0.3f;
    }
    
    [UIView animateWithDuration: animateDuration animations:^{
        [self alignThumbViews];
    }];
}

- (void) alignThumbViews
{
    CGFloat x, y, width, height;
    width = cellWidth;

    if ([NRUIManager isIPad]) {
        height = 288;
    }
    else
        height = 171;
    
    CGFloat gap = (self.bounds.size.width - cellWidth * self.cols) / (self.cols + 1);

    for (int i=0; i<_reviews.count; i++) {
        NRReviewThumbView* thumbView = (id)[self.scrollView viewWithTag: NRTHUMBVIEW_TAGBASE + i];
        x = gap + (gap + width) * (i%self.cols);
        y = gap + (gap + height) * (i/self.cols);
        thumbView.frame = CGRectMake(x, y, width, height);
    }
    
    CGSize contentSize = CGSizeMake(self.bounds.size.width, gap + (_reviews.count+self.cols-1) / self.cols * (gap+height));
    [self.scrollView setContentSize: contentSize];
}

- (NSInteger) columnWidthFromView
{
    cellWidth = (self.bounds.size.width - CELL_GAP*(self.cols+1))/self.cols;
    return cellWidth;
}

- (void) layoutSubviews
{
    [self resetLayout: NO];
}

- (void) setReviews:(NSMutableArray *) arrayReviews
{
    _reviews = arrayReviews;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NRReviewThumbView* thumbView in self.scrollView.subviews) {
            if ([thumbView isKindOfClass: [NRReviewThumbView class]]) {
                [thumbView removeFromSuperview];
            }
        }
        
        [_reviews enumerateObjectsUsingBlock:^(NRReview* review, NSUInteger idx, BOOL *stop) {
            NRReviewThumbView* thumbView = [NRReviewThumbView thumbViewWithReview: review];
            thumbView.tag = NRTHUMBVIEW_TAGBASE + idx;
            thumbView.userInteractionEnabled = YES;
            UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onThumbView:)];
            [thumbView addGestureRecognizer: recognizer];
            [self.scrollView addSubview: thumbView];
        }];
        [self resetLayout: NO];
    });
}

- (void) onThumbView: (UIGestureRecognizer*) recognizer
{
    NRReviewThumbView* thumbView = (id)recognizer.view;
    NRReview* review = thumbView.review;
    
    if (!review.finished && ![review.user.userID isEqualToString: [NRMaster master].user.userID]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector: @selector(reviewSelected:)]) {
        [_delegate reviewSelected: thumbView.review];
    }
}
@end
