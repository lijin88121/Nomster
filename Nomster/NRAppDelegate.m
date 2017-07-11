//
//  NRAppDelegate.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRAppDelegate.h"
#import "BZFoursquare.h"
#import <objc/runtime.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation NRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyWindow];
    [NRUIManager manager].revealViewController = (id)self.window.rootViewController;
    [NRUIManager initTheme];
    [NRMaster master];
    
    UILocalNotification* notification = [launchOptions objectForKey: UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self processNotification: notification];
        application.applicationIconBadgeNumber = 0;
    }

//    NSArray* family = [UIFont familyNames];
//    for (NSString* familyName in family) {
//        if ([familyName rangeOfString: @"Arista"].length > 0) {
//            NSArray* array = [UIFont fontNamesForFamilyName: familyName];
//            for (NSString* fontName in array) {
//                NSLog(@"font - ||%@||", fontName);
//            }
//        }
//    }
 
    return YES;
}

- (void) processNotification: (UILocalNotification*) notification
{
    NSDictionary* userInfoCurrent = notification.userInfo;
    NRReview* review = [NRReview reviewFromDictionary: userInfoCurrent];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"" message: notification.alertBody delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: @"Cancel", nil];
    [alert show];
    objc_setAssociatedObject(alert, @"review", review, OBJC_ASSOCIATION_RETAIN);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NRReview* review = objc_getAssociatedObject(alertView, @"review");
        [NRMaster processFinishReview: review];
    }
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self processNotification: notification];
    application.applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
