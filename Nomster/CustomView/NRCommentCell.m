//
//  NRCommentCell.m
//  Nomster
//
//  Created by Li Jin on 12/2/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRCommentCell.h"

@implementation NRCommentCell

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

- (void) resetWithComment: (NRComment*) comment
{
    _comment = comment;
    [_imgAvatar setImage: [UIImage imageNamed: @"img_userphoto_placeholder"]];
    [_imgAvatar setImageUrl: comment.user.avatarURL];
    
    _lblUsername.text = comment.user.username;
    _lblComment.text = [comment.comment stringByReplacingOccurrencesOfString: @"\\" withString: @""];
    _lblComment.numberOfLines = 1000;
    
    CGSize size;
    if ([NRUIManager isIPad]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: comment.comment attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 14]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){600, CGFLOAT_MAX} options: NSStringDrawingUsesLineFragmentOrigin context:nil];
        size = rect.size;
    }
    else
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: comment.comment attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 10]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){160, CGFLOAT_MAX} options: NSStringDrawingUsesLineFragmentOrigin context:nil];
        size = rect.size;
    }
    CGRect rt = _lblComment.frame;
    rt.size = size;
    _lblComment.frame = rt;
}

+ (NSInteger) heightForComment: (NRComment*) comment
{
//    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize: 10]};
    if ([NRUIManager isIPad]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: comment.comment attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 14]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){600, CGFLOAT_MAX} options: NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        return 50.0f + MAX(20, size.height);
    }
    else
    {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString: comment.comment attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 10]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){160, CGFLOAT_MAX} options: NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        return 30.0f + MAX(20, size.height);
    }
}

@end
