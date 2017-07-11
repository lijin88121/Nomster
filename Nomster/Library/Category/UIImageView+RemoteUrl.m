//
//  UIImageView+RemoteUrl.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "UIImageView+RemoteUrl.h"

@implementation UIImageView (RemoteUrl)
- (void) setImageUrl:(NSString *) url
{
    [self loadImageWithURL: [NSURL URLWithString: url]];
}

- (void) loadImageWithURL: (NSURL*) url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * imageData = [NSData dataWithContentsOfURL: url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageWithData: imageData];
        });
    });
}

- (void) loadImageWithURL: (NSURL*) url block: (void (^)(BOOL bSuccess)) block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * imageData = [NSData dataWithContentsOfURL: url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [UIImage imageWithData: imageData];
            if (block != nil) {
                if (self.image) {
                    block(YES);
                }
                else
                {
                    block(NO);
                }
            }
        });
    });
}

@end
