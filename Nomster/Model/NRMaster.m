//
//  NRMaster.m
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRMaster.h"
#import "NRFinishReviewViewController.h"
#import "NRSearchOption.h"
#import <Social/Social.h>

#define FB_APP_ID             @"687852077915257"

// UserDefault for Facebook
#define FB_ACCESS_TOKEN       @"FBAccessTokenKey"
#define FB_EXPIRATION_DATE    @"FBExpirationDateKey"
#define FB_LOGINNAME          @"FBLoginName"

@implementation NRMaster
static NRMaster* sharedMaster = nil;

+ (NRMaster*) master
{
    if (sharedMaster == nil) {
        sharedMaster = [NRMaster new];
    }
    return sharedMaster;
}

+ (void) registerReviewNotification: (NRReview*) review
{
    UILocalNotification* notification = [UILocalNotification new];
    NSDate* alertDate = [NSDate dateWithMinutesFromNow: 30];
    notification.fireDate = alertDate;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.alertAction = @"Open";
    notification.alertBody = [NSString stringWithFormat: @"It's time to finish your share - %@", review.title];
    notification.repeatInterval = 0;
    notification.userInfo = [NRReview dictFromReview: review];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
}

+ (void) checkAndRemoveFromLocalNotification: (NRReview*) review
{
    NSArray* localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification* notification in localNotifications) {
        if (notification.userInfo && [notification.userInfo isKindOfClass: [NSDictionary class]]) {
            NRReview* registeredReview = [NRReview reviewFromDictionary: notification.userInfo];
            if (registeredReview && [registeredReview.reviewID intValue] == [review.reviewID intValue]) {
                [[UIApplication sharedApplication] cancelLocalNotification: notification];
                return;
            }
        }
    }
}

+ (void) processFinishReview: (NRReview*) review
{
    UINavigationController* pController = (id)[NRUIManager loadViewController: @"sid_finishreview"];
    NRFinishReviewViewController* finishViewController = (id)pController.viewControllers.firstObject;
    finishViewController.review = review;
    [[NRUIManager manager].revealViewController presentViewController: pController animated: YES completion: nil];
}

+ (BOOL) checkAndShowLogin
{
    if ([NRMaster master].user == nil) {
        [[NRUIManager manager].revealViewController performSegueWithIdentifier: @"sid_login" sender: [NRUIManager manager].revealViewController];
        return NO;
    }
    return YES;
}

#pragma mark Local Methods

- (id)init
{
    self = [super init];
    if (self) {
        [self initLocationManager];
        [self loadUser];
        [self loadSearchOption];
        [self loadFavorites];
//        [self loadCategories];
    }
    return self;
}

- (void) initLocationManager
{
    if (_locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager setDelegate: self];
        
        if ([CLLocationManager locationServicesEnabled] == NO) {
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [servicesDisabledAlert show];
        }
        
        [self.locationManager startUpdatingLocation];
        self.currentLocation = _locationManager.location;
    }
}

- (void) loadCategories
{
    [[NRAPIManager manager] getCategoriesWithBlock:^(NSMutableArray *categories) {
        self.categories = [NSMutableArray arrayWithArray: categories];
    }];
}

- (void) loadSearchOption
{
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [standard objectForKey: @"LastSearchOption"];
    if (dict) {
        self.searchOption = [NRSearchOption searchOptionFromDict: dict];
    }
    else
    {
        self.searchOption = [NRSearchOption new];
    }
}

- (void) storeSearchOption
{
    NSDictionary* dictOption = [NRSearchOption dictFromSearchOption: self.searchOption];
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    [standard setObject: dictOption forKey: @"LastSearchOption"];
    [standard synchronize];
}

- (void) loadUser
{
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict = [standard objectForKey: @"LastUser"];
    if (dict == nil) {
        self.user = nil;
    }
    else
    {
        self.user = [NRUser userFromDictionary: dict];
    }
}

- (void) storeUser
{
    NSDictionary* dictUser = [NRUser dictFromUser: self.user];
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    [standard setObject: dictUser forKey: @"LastUser"];
    [standard synchronize];
}

- (void) loadFavorites
{
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    NSArray* array = [standard objectForKey: @"Favorites"];
    self.favorites = [NSMutableArray array];
    if (array != nil)
    {
        for (NSDictionary* dict in array) {
            NRReview* review = [NRReview reviewFromDictionary: dict];
            [self.favorites addObject: review];
        }
    }
}

- (void) storeFavorites
{
    NSUserDefaults* standard = [NSUserDefaults standardUserDefaults];
    NSMutableArray* array = [NSMutableArray array];
    for (NRReview* review in self.favorites) {
        NSDictionary* dict = [NRReview dictFromReview: review];
        [array addObject: dict];
    }
    
    [standard setObject: array forKey: @"Favorites"];
    [standard synchronize];
}

- (void) addToFavorite: (NRReview*) review
{
    [self.favorites addObject: review];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self storeFavorites];
    });
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations == nil || [locations count] == 0) {
        return;
    }
    
    self.currentLocation = [locations lastObject];
    NSLog(@"new location: %f, %f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

+ (BOOL) isFacebookLoggedIn
{
    return (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded);
}

+ (void) directionToCoordinate: (CLLocationCoordinate2D) coordinate withName: (NSString*) name
{
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate: coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName: name];
    [mapItem openInMapsWithLaunchOptions:nil];
}

#pragma mark Facebook
+ (NSString*) composeShareMessageFromReview: (NRReview*) review
{
    NSMutableString* shareMessage = [NSMutableString stringWithString: @"Review from Nomster app! :)"];
    [shareMessage appendString: @"\n"];
    [shareMessage appendFormat: @"Name: %@", review.title];
    [shareMessage appendString: @"\n"];
    [shareMessage appendFormat: @"Price: $%.2f", review.price];
    [shareMessage appendString: @"\n"];
    [shareMessage appendFormat: @"Ratings: %d", (int)review.ratings];
    [shareMessage appendString: @"\n"];
    if (review.category != nil) {
        [shareMessage appendFormat: @"Category: %@", review.category.title];
        [shareMessage appendString: @"\n"];
    }
    [shareMessage appendString: review.restaurant];
    [shareMessage appendString: @"\n"];
    [shareMessage appendString: review.description];
    return shareMessage;
}

+ (void) shareViaFacebook: (NRReview*) review
{
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook])
    {
        SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSString* shareMessage = [self composeShareMessageFromReview: review];
        [fbSheet setInitialText: shareMessage];
        
        if (review.image)
        {
            [fbSheet addImage: review.image];
        }
        else if (review.imageURL)
        {
            [fbSheet addURL: [NSURL URLWithString: review.imageURL]];
        }
        
        [[NRUIManager manager].revealViewController presentViewController: fbSheet animated:YES completion:nil];
    }
    else
    {
        //[self publishToFacebookReview: review];
        [self publishViaFeedDialog: review];
    }
}

+ (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

+ (void) publishViaFeedDialog: (NRReview*) review
{
    NSString* shareMessage = [[self composeShareMessageFromReview: review] stringByReplacingOccurrencesOfString: @"\n" withString: @"<p/>"];

    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     review.title, @"name",
     [NSString stringWithFormat: @"By %@", review.user.username], @"caption",
     shareMessage, @"description",
     @"https://nomster.co", @"link",
     review.imageURL, @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams: [resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
}

+ (void) publishToFacebookReview: (NRReview*) review
{
    NSString* shareMessage = [self composeShareMessageFromReview: review];
    if (review.image == nil) {
        review.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: review.imageURL]]];
    }
    
        [self performPublishAction:^{
            BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom: [NRUIManager manager].revealViewController
                                                                                  initialText: shareMessage
                                                                                        image: review.image
                                                                                          url: nil
                                                                                      handler: nil];
            if (!displayedNativeDialog) {
                [FBRequestConnection startForUploadPhoto: review.image
                                       completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                           //[self showAlert:@"Photo Post" result:result error:error];
                                           NSString* strResult = @"Success";
                                           if ( error )
                                               strResult = @"Fail";
                                           
                                           UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                            message:strResult
                                                                                           delegate:nil
                                                                                  cancelButtonTitle:@"Ok"
                                                                                  otherButtonTitles:nil];
                                           [alert show];
                                       }];
            }
        }];
}

+ (void) performPublishAction:(void (^)(void)) action {
    if ( [[FBSession activeSession] isOpen]){
        // we defer request for permission to post to the moment of post, then we check for the permission
        if ([FBSession.activeSession.permissions indexOfObject: @"publish_actions"] == NSNotFound) {
            [FBSession.activeSession requestNewPublishPermissions: [NSArray arrayWithObjects: @"publish_actions", @"publish_stream", nil]
                                                  defaultAudience: FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                                                      if (!error) {
                                                          action();
                                                      }
                                                  }];
        } else {
            action();
        }
    }else {
        [FBSession openActiveSessionWithPublishPermissions: [NSArray arrayWithObjects: @"publish_actions", @"publish_stream", nil]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (!error) {
                                                 action();
                                             }
                                         }];
    }
}

+ (void) shareViaTwitter: (NRReview*) review
{
    if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
        NSString* shareMessage = [self composeShareMessageFromReview: review];
        [tweetSheet setInitialText: shareMessage];
        
        if (review.image)
        {
            [tweetSheet addImage: review.image];
        }
        else if (review.imageURL)
        {
            [tweetSheet addURL: [NSURL URLWithString: review.imageURL]];
        }
        
        [[NRUIManager manager].revealViewController presentViewController: tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup in the Device Settings."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
