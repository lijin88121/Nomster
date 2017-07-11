//
//  NSObject+SafePerformSelector.m
//  Nomster
//
//  Created by Li Jin on 11/28/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NSObject+SafePerformSelector.h"

@implementation NSObject (SafePerformSelector)
-(id) performSelectorSafely:(SEL)aSelector
{
    NSParameterAssert(aSelector != NULL);
    NSParameterAssert([self respondsToSelector:aSelector]);
    
    NSMethodSignature* methodSig = [self methodSignatureForSelector:aSelector];
    if(methodSig == nil)
        return nil;
    
    const char* retType = [methodSig methodReturnType];
    if(strcmp(retType, @encode(id)) == 0 || strcmp(retType, @encode(void)) == 0){
        return [self performSelector:aSelector];
    } else {
        NSLog(@"-[%@ performSelector:@selector(%@)] shouldn't be used. The selector doesn't return an object or void", [self class], NSStringFromSelector(aSelector));
        return nil;
    }
}
@end
