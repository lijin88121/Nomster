//
//  GTCircularImageView.h
//  Goodtime
//
//  Created by Mountain on 8/25/13.
//  Copyright (c) 2013 Goodtime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCircularImageView : UIView
{
    UIImageView*    imageView;
    UIImageView*    imageCircularView;
}

@property (nonatomic, strong) UIImage*  image;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, assign) NSInteger borderWidth;

- (id) initWithImage: (UIImage*) image;
- (id) initWithImageURL: (NSString*) imageUrl;

@end
