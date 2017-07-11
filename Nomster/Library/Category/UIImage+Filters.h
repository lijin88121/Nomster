//
//  UIImage+Filters.h
//  PhotoFilters
//
//  Created by Roberto Breve on 6/2/12.
//  Copyright (c) 2012 Icoms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filters)
+ (UIImage*) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

- (UIImage*) saturateImage:(float)saturationAmount withContrast:(float)contrastAmount;
- (UIImage*) blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName;
- (UIImage*) imageFromContext:(CIContext*)context withFilter:(CIFilter*)filter;

- (UIImage*) originalFilter;
- (UIImage*) vividFilter;
- (UIImage*) springFilter;
- (UIImage*) vintageFilter;
- (UIImage*) sepiaFilter;
- (UIImage*) coolFilter;
- (UIImage*) vignetteFilter;

@end
