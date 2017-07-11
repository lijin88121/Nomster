//
//  NRReviewGroupCell.h
//  Nomster
//
//  Created by Li Jin on 11/25/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NRReviewGroup;
@interface NRReviewGroupCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView*      imgCategory;
@property (nonatomic, weak) IBOutlet UILabel*          lblTitle;
@property (nonatomic, weak) IBOutlet UILabel*          lblReviewCount;

- (void) resetWithGroup: (NRReviewGroup*) reviewGroup;
@end
