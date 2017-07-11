//
//  NRButtonActionItem.h
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRButtonActionItem : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) UIImage*  image;
@property (nonatomic, strong) id        target;
@property (nonatomic)         SEL       action;

+ (NRButtonActionItem*) itemWithTitle: (NSString*) title image: (UIImage*) image target:(id)target action:(SEL)action;

@end
