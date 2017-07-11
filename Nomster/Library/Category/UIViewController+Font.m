//
//  UIViewController+Font.m
//  Nomster
//
//  Created by Li Jin on 12/9/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "UIViewController+Font.h"

@implementation UIViewController (Font)

- (void) applyFont: (NSString*) fontname boldfontname: (NSString*) boldfontname
{
    [self applyFontToView: self.view fontname: fontname boldfontname: boldfontname];
}

- (void) applyFontToView: (UIView*) view fontname: (NSString*) font boldfontname: (NSString*) boldfontname
{
    for (UIView* subView in view.subviews) {
        if( [subView isKindOfClass: [UILabel class]])
        {
            UILabel* label = (UILabel*) subView;
            if ([[label.font.fontName lowercaseString] rangeOfString: @"bold"].length != 0)
            {
                [label setFont: [UIFont fontWithName: boldfontname size: label.font.pointSize]];
            }
            else{
                [label setFont: [UIFont fontWithName: font size: label.font.pointSize]];
            }
        
        }
        else if ([subView isKindOfClass: [UIButton class]])
        {
            UIButton* button = (UIButton*) subView;
            if ([[button.titleLabel.font.fontName lowercaseString] rangeOfString: @"bold"].length != 0)
            {
                [button.titleLabel setFont: [UIFont fontWithName: boldfontname size: button.titleLabel.font.pointSize]];
            }
            else{
                [button.titleLabel setFont: [UIFont fontWithName: font size: button.titleLabel.font.pointSize]];
            }
        }
        else if ( [subView isKindOfClass: [UIView class]] && view.subviews != nil && [view.subviews count] > 0) {
            [self applyFontToView: subView fontname: font boldfontname: boldfontname];
        }
    }
}

@end
