/*

    NRStarRating
    Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 

    All rights reserved. This program and the accompanying materials
    are made available under the terms of the Eclipse Public License v1.0
    which accompanies this distribution, and is available at
    http://www.eclipse.org/legal/epl-v10.html

 */

#import <UIKit/UIKit.h>

#define kDefaultNumberOfStars 5
#define kNumberOfFractions 10

@protocol NRStarRatingDelegate;

@interface NRStarRatingControl : UIControl {
	int numberOfStars;
	int currentIdx;
	UIImage *star;
	UIImage *highlightedStar;
	IBOutlet id<NRStarRatingDelegate> delegate;
    BOOL isFractionalRatingEnabled;
}

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andStars:(NSUInteger)_numberOfStars isFractional:(BOOL)isFract;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage atIndex:(int)index;

@property (retain,nonatomic) UIImage *star;
@property (retain,nonatomic) UIImage *highlightedStar;
@property (nonatomic) float rating;
@property (assign,nonatomic) id<NRStarRatingDelegate> delegate;
@property (nonatomic,assign) BOOL isFractionalRatingEnabled;

@end

@protocol NRStarRatingDelegate
@optional
-(void)newRating:(NRStarRatingControl *)control :(float)rating;
@end
