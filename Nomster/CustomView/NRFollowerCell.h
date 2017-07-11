//
//  NRFollowerCell.h
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRFollowerCell : UITableViewCell
@property (nonatomic, weak) IBOutlet NRCircularImageView*   imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel*          lblUsername;
@property (nonatomic, weak) IBOutlet UILabel*          lblFullname;

- (void) resetWithUser: (NRUser*) user;
@end
