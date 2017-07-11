//
//  NRMenuItem.h
//  Nomster
//
//  Created by Li Jin on 11/4/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRMenuItem : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subTitle;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* segueName;

+ (NRMenuItem*) itemWithTitle: (NSString*) title image: (NSString*) imageName segue: (NSString*) segueName;
+ (NRMenuItem*) itemWithTitle: (NSString*) title subTitle: (NSString*) subTitle image: (NSString*) imageName segue: (NSString*) segueName;
@end
