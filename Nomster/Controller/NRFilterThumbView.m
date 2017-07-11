//
//  NRFilterThumbView.m
//  Nomster
//
//  Created by Li Jin on 11/28/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRFilterThumbView.h"
#import "NSObject+SafePerformSelector.h"

@implementation NRFilterThumbView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id) thumbViewWithFilter: (NSString*) filter withImage: (UIImage*) image
{
    return [[self alloc] initWithFilter: filter withImage: image];
}

- (id) initWithFilter: (NSString*) filterName withImage: (UIImage*) iconImage
{
    self = [super init];
    if (self) {
        self.filter = filterName;
        self.image = iconImage;
        [self initSubView];
    }
    return self;
}

- (void) initSubView
{
    _imageView = [[UIImageView alloc] init];
    self.highlighted = NO;
    [self addSubview: _imageView];
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(imageTouched:)];
    [_imageView addGestureRecognizer: recognizer];

    _lblTitle = [[UILabel alloc] init];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textColor = [UIColor whiteColor];
    _lblTitle.font = [UIFont systemFontOfSize: 10];
    _lblTitle.text = _filter.capitalizedString;
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview: _lblTitle];
    
    NSString* selectorName = [NSString stringWithFormat: @"%@Filter", _filter.lowercaseString];
    _imageView.image = _image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage* filteredImage = [self.image performSelectorSafely: NSSelectorFromString(selectorName)];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = filteredImage;
        });
    });
    
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    CGRect rt = self.bounds;
    _imageView.frame = CGRectMake(0, 0, rt.size.width, rt.size.width);
    _lblTitle.frame = CGRectMake(0, rt.size.height - 30, rt.size.width, 25);
}

- (void) imageTouched: (UIGestureRecognizer*) recognizer
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(filterView:filterSelected:)]) {
        [self.delegate filterView: self filterSelected: _filter];
    }
}

- (void) setHighlighted:(BOOL) highlighted
{
    _highlighted = highlighted;
    
    if (_highlighted) {
        _imageView.layer.borderWidth = 2.0f;
        _imageView.layer.borderColor = NR_COLOR_GREEN.CGColor;
    }
    else
    {
        _imageView.layer.borderWidth = 1.5f;
        _imageView.layer.borderColor = NR_COLOR_ORANGE.CGColor;
    }
}

@end

