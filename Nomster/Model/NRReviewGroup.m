//
//  NRReviewGroup.m
//  Nomster
//
//  Created by Li Jin on 11/25/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewGroup.h"

@implementation NRReviewGroup

- (void) addReview: (NRReview*) review
{
    if (self.reviews == nil) {
        self.reviews = [NSMutableArray array];
    }
    [self.reviews addObject: review];
}

@end
