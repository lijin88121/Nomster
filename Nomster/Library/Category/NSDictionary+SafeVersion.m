//
//  NSDictionary+SafeVersion.m
//
//  Created by Mountain on 7/16/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NSDictionary+SafeVersion.h"

@implementation NSDictionary (SafeVersion)
- (id) safeObjectForKey: (NSString*) key
{
    NSObject* object = [self objectForKey: key];
    if (object == nil || [object isKindOfClass: [NSNull class]]) {
        return nil;
    }
    else
        return object;
    return @"";
}

- (id) objectAtIndex: (NSInteger) index
{
    NSArray* keys = [self allKeys];
    if (index < 0 || index >= [keys count]) {
        return nil;
    }
    
    id key = [keys objectAtIndex: index];
    return [self safeObjectForKey: key];
}

- (NSInteger) integerForKey: (id) key
{
    return [[self safeObjectForKey: key] integerValue];
}

- (CGFloat) floatForKey: (id) key
{
    return [[self safeObjectForKey: key] floatValue];
}

@end

@implementation NSMutableDictionary (SafeVersion)
- (void) setSafeObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (anObject == nil || [anObject isKindOfClass: [NSNull class]]) {
        return;
    }
    else
    {
        [self setObject: anObject forKey: aKey];
    }
}

- (void) setInteger: (NSInteger) anInt forKey: (id <NSCopying>)aKey
{
    [self setObject: [NSNumber numberWithInteger: anInt] forKey: aKey];
}

- (void) setFloat: (NSInteger) aFloat forKey: (id <NSCopying>)aKey
{
    [self setObject: [NSNumber numberWithFloat: aFloat] forKey: aKey];
}

@end
