//
//  GTCircularImageView.m
//  Goodtime
//
//  Created by Mountain on 8/25/13.
//  Copyright (c) 2013 Goodtime. All rights reserved.
//

#import "NRCircularImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NRCircularImageView
@synthesize image;
@synthesize imageUrl;
@synthesize borderWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (id) initWithImage: (UIImage*) img
{
    self = [super init];
    if (self) {
        [self initSubViews];
        self.image = img;        
    }
    return self;
}

- (id) initWithImageURL: (NSString*) url
{
    self = [super init];
    if (self) {
        [self initSubViews];
        self.imageUrl = url;        
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self initSubViews];
}

- (void) initSubViews
{
    self.borderWidth = 2;
    self.backgroundColor = [UIColor clearColor];
    if (!imageCircularView) {
        imageCircularView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"img_circularview"]];
        [self addSubview: imageCircularView];
    }
    
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithImage: self.image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview: imageView];
    }
}

- (void) setImage:(UIImage *)img
{
    image = img;
    if (!imageView)
    {
        imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview: imageView];
    }
    imageView.image = img;
}

- (void) setImageUrl:(NSString *) url
{
    imageUrl = url;
    if (!imageView)
    {
        imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview: imageView];
    }
    [self loadImageWithURL: [NSURL URLWithString: url]];
}

- (void) loadImageWithURL: (NSURL*) url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * imageData = [NSData dataWithContentsOfURL: url];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData: imageData];
        });
    });
}

- (void) setBorderWidth:(NSInteger) width
{
    borderWidth = width;
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    imageCircularView.frame = self.bounds;
    imageView.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    imageView.layer.cornerRadius = MIN(imageView.frame.size.width / 2, imageView.frame.size.height/2);
}

@end

