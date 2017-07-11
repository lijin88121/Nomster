//
//  UIImageView+RemoteUrl.h
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RemoteUrl)
- (void) setImageUrl:(NSString *) url;
- (void) loadImageWithURL: (NSURL*) url block: (void (^)(BOOL bSuccess)) block;
@end
