//
//  NRButtonCell.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRButtonCell.h"

@implementation NRButtonCell

#pragma mark Memory Management
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = RGB(220, 220, 220);
		self.selectedBackgroundView = bgView;
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size: 13.0f];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite: 0.5f alpha:0.25f];
		self.textLabel.textColor = RGB(70, 70, 70);
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = RGB(223, 223, 223);
		[self.textLabel.superview addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = RGB(190, 190, 190);
		[self.textLabel.superview addSubview:bottomLine];
    }
	return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = CGRectMake(60.0f, 0.0f, 240.0f, 43.0f);
	self.imageView.frame = CGRectMake(10.0f, 0.0f, 50.0f, 43.0f);
}

@end
