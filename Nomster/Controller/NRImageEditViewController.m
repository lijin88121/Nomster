//
//  NRImageEditViewController.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRImageEditViewController.h"
#import "UIImage+Filters.h"

@interface NRImageEditViewController ()

@end

@implementation NRImageEditViewController

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
}

- (void) initView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_done_green"] style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    _scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    _scrollView.layer.borderWidth = 1.0f;
    
    [self initFilters];
}

- (void) initFilters
{
    NSArray* filters = @[@"original", @"sepia", @"vivid", @"cool", @"vintage", @"vignette", @"spring"];
    CGFloat gap = 5.0f;
    
    CGFloat width = (_scrollView.frame.size.width - gap * (filters.count + 1)) / filters.count;
    CGFloat height = _scrollView.frame.size.height - gap * 2;
    
    UIImage* iconImage = [UIImage imageWithImage: self.sourceImage scaledToSize: CGSizeMake(width, width)];
    
    [filters enumerateObjectsUsingBlock:^(NSString* filter, NSUInteger idx, BOOL *stop) {
        NRFilterThumbView* thumbView = [NRFilterThumbView thumbViewWithFilter: filter withImage: iconImage];
        thumbView.delegate = self;
        thumbView.frame = CGRectMake(gap + idx*(gap+width), gap+gap, width, height);
        if (idx == 0) {
            thumbView.highlighted = YES;
            _currentThumbView = thumbView;
        }        
        [_scrollView addSubview: thumbView];
    }];
}

#pragma mark NRFilterThumbViewDelegate
- (void) filterView:(NRFilterThumbView *)thumbView filterSelected:(NSString *)filter
{
    if (_currentThumbView != nil) {
        _currentThumbView.highlighted = NO;
    }
    
    _currentThumbView = thumbView;
    _currentThumbView.highlighted = YES;
    
    [self applyFilter: filter];
}

@end
