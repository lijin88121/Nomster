//
//  NRButtonActionItem.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRButtonActionItem.h"

@implementation NRButtonActionItem

+ (NRButtonActionItem*) itemWithTitle: (NSString*) title image: (UIImage*) image target:(id)target action:(SEL)action
{
    NRButtonActionItem* item = [NRButtonActionItem new];
    item.title = title;
    item.image = image;
    item.target = target;
    item.action = action;
    return item;
}

@end
