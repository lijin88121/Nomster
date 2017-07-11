//
//  NSObject+SafePerformSelector.h
//  Nomster
//
//  Created by Li Jin on 11/28/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafePerformSelector)
-(id) performSelectorSafely:(SEL)aSelector;
@end
