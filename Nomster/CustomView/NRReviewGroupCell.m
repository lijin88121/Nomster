//
//  NRReviewGroupCell.m
//  Nomster
//
//  Created by Li Jin on 11/25/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewGroupCell.h"
#import "NRReviewGroup.h"

@implementation NRReviewGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) resetWithGroup: (NRReviewGroup*) reviewGroup
{
    [_imgCategory loadImageWithURL: [NSURL URLWithString: reviewGroup.thumbnailImage] block: nil];
    _lblTitle.text = reviewGroup.category.title;
    _lblReviewCount.text = [NSString stringWithFormat: @"%d Reviews", (int)[reviewGroup.reviews count]];
}
@end
