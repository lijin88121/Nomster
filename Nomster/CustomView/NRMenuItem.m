//
//  NRMenuItem.m
//  Nomster
//
//  Created by Li Jin on 11/4/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRMenuItem.h"

@implementation NRMenuItem

+ (NRMenuItem*) itemWithTitle: (NSString*) title image: (NSString*) imageName segue: (NSString*) segueName
{
    return [self itemWithTitle: title subTitle: nil image: imageName segue: segueName];
}

+ (NRMenuItem*) itemWithTitle: (NSString*) title subTitle: (NSString*) subTitle image: (NSString*) imageName segue: (NSString*) segueName
{
    NRMenuItem* item = [NRMenuItem new];
    item.title = title;
    item.subTitle = subTitle;
    item.imageName = imageName;
    item.segueName = segueName;
    return item;
}

@end
