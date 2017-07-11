//
//  NRMenuSection.h
//  Nomster
//
//  Created by Mountain on 12/14/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRMenuSection : NSObject
@property (nonatomic, strong) NSString*         title;
@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, strong) NSMutableArray*   menuItems;

+ (id) menuSectionWithTitle: (NSString*) title withIndex: (NSInteger) index;
- (void) addItem: (id) menuItem;
@end
