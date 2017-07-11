//
//  UIImage+Filters.m
//  PhotoFilters
//
//  Created by Roberto Breve on 6/2/12.
//  Copyright (c) 2012 Icoms. All rights reserved.
//

#import "UIImage+Filters.h"

@implementation UIImage (Filters)

- (UIImage*) saturateImage:(float)saturationAmount withContrast:(float)contrastAmount
{
    UIImage *sourceImage = self;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:sourceImage];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    
    [filter setValue:[NSNumber numberWithFloat:saturationAmount] forKey:@"inputSaturation"];
    [filter setValue:[NSNumber numberWithFloat:contrastAmount] forKey:@"inputContrast"];
    
    
    return [self imageFromContext:context withFilter:filter];
    
}

- (UIImage*) blendMode:(NSString *)blendMode withImageNamed:(NSString *) imageName
{
    
    /*
     Blend Modes
     
     CISoftLightBlendMode
     CIMultiplyBlendMode
     CISaturationBlendMode
     CIScreenBlendMode
     CIMultiplyCompositing
     CIHardLightBlendMode
     */
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    //try with different textures
    CIImage *bgCIImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];


    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter= [CIFilter filterWithName:blendMode];
    
    
    // inputBackgroundImage most be the same size as the inputImage

    [filter setValue:inputImage forKey:@"inputBackgroundImage"];
    [filter setValue:bgCIImage forKey:@"inputImage"];
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage*) imageFromContext:(CIContext*)context withFilter:(CIFilter*)filter
{
    CGImageRef imageRef = [context createCGImage:[filter outputImage] fromRect:filter.outputImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage*) originalFilter
{
    return self;
}

- (UIImage*) vividFilter
{
    return [self saturateImage:1.7 withContrast:1];
}

- (UIImage*) springFilter
{
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CIToneCurve"];
    
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:0.0  Y:0.0] forKey:@"inputPoint0"]; // default
    [filter setValue:[CIVector vectorWithX:0.25 Y:0.15] forKey:@"inputPoint1"];
    [filter setValue:[CIVector vectorWithX:0.5  Y:0.5] forKey:@"inputPoint2"];
    [filter setValue:[CIVector vectorWithX:0.75  Y:0.85] forKey:@"inputPoint3"];
    [filter setValue:[CIVector vectorWithX:1.0  Y:1.0] forKey:@"inputPoint4"]; // default
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage*) vintageFilter
{
    return [self blendMode:@"CISoftLightBlendMode" withImageNamed:@"paper.jpg"];
}

- (UIImage*) sepiaFilter
{
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat: 1.0f] forKey:@"inputIntensity"]; // default
    
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage*) coolFilter
{
    CIImage *inputImage =[[CIImage alloc] initWithImage:self];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    
    [filter setDefaults];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    CIColor *color = [CIColor colorWithRed: 0.3
                                     green: 0.45
                                      blue: 0.9f
                                     alpha:1.0];
    [filter setValue:color forKey: @"inputColor"];
    [filter setValue: [NSNumber numberWithFloat: 0.433792] forKey: @"inputIntensity"];
    return [self imageFromContext:context withFilter:filter];
}

- (UIImage*) vignetteFilter
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter= [CIFilter filterWithName:@"CIVignette"];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat: 18] forKey:@"inputIntensity"];
    [filter setValue:[NSNumber numberWithFloat: 0] forKey:@"inputRadius"];
    
    return [self imageFromContext:context withFilter:filter];
}

+ (UIImage*) imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
