//
//  UINavigationBar+Nomster.m
//  Nomster
//
//  Created by Li Jin on 11/4/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "UINavigationBar+Nomster.h"

@implementation UINavigationBar (Nomster)

const int dx = 0;
const int dy = 5;

- (void) drawRect:(CGRect)rect
{
    UIImage* image = [UIImage imageNamed: @"img_logo_nomster"];
    CGSize size = image.size;
    
    CGRect rtImage = CGRectInset(self.bounds, (self.bounds.size.width - size.width)/2, dy);
    [image drawInRect: rtImage];
}

@end
