//
//  UINavigationController+Nomster.m
//  Nomster
//
//  Created by Li Jin on 11/6/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "UINavigationController+Nomster.h"

@implementation UINavigationController (Nomster)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown) ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) : YES;
}

- (BOOL)shouldAutorotate {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSUInteger)supportedInterfaceOrientations{
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
