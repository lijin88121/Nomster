//
//  NRReviewGroup.h
//  Nomster
//
//  Created by Li Jin on 11/25/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRReviewGroup : NSObject
@property (nonatomic, strong) NSString*         thumbnailImage;
@property (nonatomic, strong) NRCategory*       category;
@property (nonatomic, strong) NSMutableArray*   reviews;

- (void) addReview: (NRReview*) review;
@end
