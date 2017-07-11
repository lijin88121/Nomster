//
//  NRCommentCell.h
//  Nomster
//
//  Created by Li Jin on 12/2/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCommentCell : UITableViewCell
@property (nonatomic, weak) IBOutlet NRCircularImageView*   imgAvatar;
@property (nonatomic, weak) IBOutlet UILabel*               lblUsername;
@property (nonatomic, weak) IBOutlet UILabel*               lblComment;
@property (nonatomic, weak) IBOutlet UIButton*              btnFollow;

@property (nonatomic, strong) NRComment*                    comment;

- (void) resetWithComment: (NRComment*) comment;
+ (NSInteger) heightForComment: (NRComment*) comment;
@end
