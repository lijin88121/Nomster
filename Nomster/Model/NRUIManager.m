//
//  NRUIManager.m
//  Nomster
//
//  Created by Li Jin on 11/8/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRUIManager.h"

@implementation NRUIManager

+ (NRUIManager*) manager
{
    static dispatch_once_t once;
    static NRUIManager* sharedManager = nil;
    dispatch_once(&once, ^{
        sharedManager = [NRUIManager new];
    });
    return sharedManager;
}

+ (void) initTheme
{
    [UIApplication sharedApplication].keyWindow.tintColor = NR_COLOR;
}

+ (UIViewController*) loadViewController: (NSString*) storyboardID
{
    if ([self isIPad])
    {
        return [[UIStoryboard storyboardWithName: @"Main_iPad" bundle: nil] instantiateViewControllerWithIdentifier: storyboardID];
    }
    else
    {
        return [[UIStoryboard storyboardWithName: @"Main_iPhone" bundle: nil] instantiateViewControllerWithIdentifier: storyboardID];
    }
}

+ (BOOL) isIPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (UIImage*) imageNamed: (NSString*) name
{
    UIImage* image = nil;
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        image = [UIImage imageNamed: name];
    }
    else
    {
        image = [[UIImage imageNamed: name] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

@end
