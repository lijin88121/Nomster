//
//  NRImageEditViewController.h
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "HFImageEditorViewController.h"
#import "NRFilterThumbView.h"

@interface NRImageEditViewController : HFImageEditorViewController <NRFilterThumbViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView*    scrollView;
@property (nonatomic, strong) NRFilterThumbView*        currentThumbView;

@end
