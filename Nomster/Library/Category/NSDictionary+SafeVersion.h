//
//  NSDictionary+SafeVersion.h
//
//  Created by Mountain on 7/16/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeVersion)
- (id) safeObjectForKey: (NSString*) key;
- (id) objectAtIndex: (NSInteger) index;
- (NSInteger) integerForKey: (id) key;
- (CGFloat) floatForKey: (id) key;
@end


@interface NSMutableDictionary (SafeVersion)
- (void) setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void) setInteger: (NSInteger) anInt forKey: (id <NSCopying>)aKey;
- (void) setFloat: (NSInteger) aFloat forKey: (id <NSCopying>)aKey;
@end
