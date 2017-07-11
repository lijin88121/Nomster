//
//  NRData.m
//  NR
//
//  Created by Li Jin on 01/05/13.
//  Copyright 2012-2013 Li Jin, Inc. All rights reserved.
//  Permission to use this file is granted in NRetworking/license.txt (apache v2).
//

#import "NR_categories.h"
#import "NRData.h"


NSString *stringForMimeType(MimeType type) {
    
    switch (type) {
        case MimeType_image_jpeg:       return @"image/jpeg";
        case MimeType_application_json: return @"application/json";
        case MimeType_unknown:          return nil;
        default:
            NSLog(@"ERROR: NRData: unknown MimeType: %d", type);
            
            // do not return "application/octet-stream"; instead, let the recipient guess
            // http://en.wikipedia.org/wiki/Internet_media_type
            return nil;
    }
}

@implementation NRData

- (id)description {
    NSString *fn = self.fileName ? [NSString stringWithFormat:@"; fileName=%@", self.fileName] : @"";
    
    return [NSString stringWithFormat:@"<NRData: %p; data: %p; length: %lu; mimeType: %@%@>",
            self, _data, (unsigned long)_data.length, self.mimeTypeString, fn];
}

- (id)initWithData:(NSData *)data mimeType:(MimeType)mimeType fileName:(NSString*)fileName {
    self = [super init];
    if (!self) return nil;
    
    self.data = data;
    self.mimeType = mimeType;
    self.fileName = fileName;
    
    return self;
}

+ (id)withData:(NSData *)data mimeType:(MimeType)mimeType fileName:(NSString*)fileName {
    return [[self alloc] initWithData:data mimeType:mimeType fileName:fileName];
}


+ (id)withDataPath:(NSString*)path fileName:(NSString*)fileName {
    NSError *e = nil;
    NSData *d = [NSData dataWithContentsOfFile:path options:0 error:&e];
    if (e) {
        NRLog(@"ERROR: failed to read from data path: %@", path);
        return nil;
    }
    return [self withData:d mimeType:MimeType_unknown fileName:fileName];
}

#if TARGET_OS_IPHONE
+ (id)withImage:(UIImage*)image jpegQuality:(CGFloat)quality fileName:(NSString*)fileName {
    return [self withData:UIImageJPEGRepresentation(image, quality) mimeType:MimeType_image_jpeg fileName:fileName];
}
#endif

- (NSString *)mimeTypeString {
    return stringForMimeType(self.mimeType);
}

@end
