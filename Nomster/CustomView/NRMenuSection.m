//
//  NRMenuSection.m
//  Nomster
//
//  Created by Mountain on 12/14/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRMenuSection.h"

@implementation NRMenuSection

+ (id) menuSectionWithTitle: (NSString*) title withIndex: (NSInteger) index
{
    NRMenuSection* section = [NRMenuSection new];
    section.title = title;
    section.index = index;
    return section;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.menuItems = [NSMutableArray array];
    }
    return self;
}

- (void) addItem: (id) menuItem
{
    if (menuItem == nil) {
        return;
    }
    if (_menuItems == nil) {
        self.menuItems = [NSMutableArray array];
    }
    [self.menuItems addObject: menuItem];
}
@end
