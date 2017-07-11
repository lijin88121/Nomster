//
//  NRUIManager.h
//  Nomster
//
//  Created by Li Jin on 11/8/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NRMenuViewController;
@interface NRUIManager : NSObject 
@property (nonatomic, strong) SWRevealViewController*   revealViewController;
@property (nonatomic, strong) NRMenuViewController*     menuViewController;

+ (NRUIManager*) manager;
+ (void) initTheme;
+ (UIViewController*) loadViewController: (NSString*) storyboardID;
+ (BOOL) isIPad;
+ (UIImage*) imageNamed: (NSString*) name;
@end
