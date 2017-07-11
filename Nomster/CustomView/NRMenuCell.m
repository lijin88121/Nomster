//
//  NRMenuCell.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRMenuCell.h"

@implementation NRMenuCell

#pragma mark Memory Management
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = RGB(220, 220, 220);
		self.selectedBackgroundView = bgView;
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		self.textLabel.font = [UIFont systemFontOfSize: 15.0f];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite: 0.5f alpha:0.25f];
		self.textLabel.textColor = NR_COLOR_BRIGHT;//RGB(37, 37, 37);
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 42.0f, 240, 1.0f)];
		bottomLine.backgroundColor = NR_COLOR_BRIGHT;
		[self.textLabel.superview addSubview: bottomLine];
	
//		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
//		bottomLine.backgroundColor = RGB(227, 227, 227);
//		[self.textLabel.superview addSubview:bottomLine];
    }
	return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
	self.textLabel.frame = CGRectMake(85.0f, 15.0f, 200.0f, 28.0f);
	self.imageView.frame = CGRectMake(40.0f, 15.0f, 28.0f, 28.0f);
}

@end
