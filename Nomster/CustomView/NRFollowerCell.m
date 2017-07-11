//
//  NRFollowerCell.m
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRFollowerCell.h"

@implementation NRFollowerCell

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

- (void) resetWithUser: (NRUser*) user
{
    [_imgAvatar setImage: [UIImage imageNamed: @"img_userphoto_placeholder"]];
    [_imgAvatar setImageUrl: user.avatarURL];
    _lblUsername.text = user.username;
    _lblFullname.text = user.fullName;
}

@end
