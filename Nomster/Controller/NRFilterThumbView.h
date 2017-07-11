//
//  NRFilterThumbView.h
//  Nomster
//
//  Created by Li Jin on 11/28/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NRFilterThumbView;

@protocol NRFilterThumbViewDelegate <NSObject>
- (void) filterView: (NRFilterThumbView*) thumbView filterSelected: (NSString*) filter;
@end

@interface NRFilterThumbView : UIView
@property (nonatomic, strong) UIImageView*      imageView;
@property (nonatomic, strong) UILabel*          lblTitle;
@property (nonatomic, strong) NSString*         filter;
@property (nonatomic, strong) UIImage*          image;
@property (nonatomic, strong) id<NRFilterThumbViewDelegate> delegate;

@property (nonatomic, assign) BOOL              highlighted;

+ (id) thumbViewWithFilter: (NSString*) filter withImage: (UIImage*) image;
@end
