//
//  NRReviewListView.h
//  Nomster
//
//  Created by Li Jin on 11/15/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NRReviewListViewDelegate <NSObject>
@optional
- (void) reviewSelected: (NRReview*) review;
@end

@interface NRReviewListView : UIView
{
    NSInteger       cellWidth;
}

@property (nonatomic, assign) NSInteger              cols;
@property (nonatomic, strong) UIScrollView*          scrollView;
@property (nonatomic, strong) NSMutableArray*        reviews;

@property (nonatomic, strong) id<NRReviewListViewDelegate> delegate;
@end
