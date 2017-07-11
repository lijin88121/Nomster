//
//  NRReviewListViewController.m
//  Nomster
//
//  Created by Li Jin on 11/26/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRReviewListViewController.h"
#import "NRLocation.h"
#import "NRReviewDetailViewController.h"

@interface NRReviewListViewController ()

@end

@implementation NRReviewListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.reviewListView.userInteractionEnabled = YES;
    self.reviewListView.delegate = self;
    self.vwMap.hidden = YES;
    [self showReviews];
}

- (void) showReviews
{
    if (self.reviews) {
        self.reviewListView.reviews = self.reviews;
    }
}

- (void) setReviews:(NSMutableArray *) arrayReviews
{
    _reviews = arrayReviews;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.reviewListView.reviews = _reviews;
        [self resetAnnotationsWithReviews: _reviews];
    });
}

- (void) reloadData
{
    if (self.delegate && [self.delegate respondsToSelector: @selector( requestReviewsForController:block:)]) {
        [self.delegate requestReviewsForController: self block:^(NSArray* arrayReviews, NSError *error) {
            self.reviews = [NSMutableArray arrayWithArray: arrayReviews];
        }];
    }
}

- (void) reviewSelected: (NRReview*) review
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(reviewListViewController:didReviewSelected:)]) {
        [self.delegate reviewListViewController: self didReviewSelected: review];
    }
    else
    {
        NRReviewDetailViewController* pController = (id)[NRUIManager loadViewController: @"sid_reviewdetailviewcontroller"];
        pController.title = review.title;
        pController.review = review;
        
        if ([NRUIManager isIPad]) {
            UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController: pController];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [[NRUIManager manager].revealViewController presentViewController: navController animated: YES completion: nil];
        }
        else
        {
            [self.navigationController pushViewController: pController animated: YES];
        }
    }
}

- (IBAction) onSegmentedControl:(UISegmentedControl*) sender
{
    if (sender.selectedSegmentIndex == 0) {
        _vwMap.hidden = YES;
        _reviewListView.hidden = NO;
    }
    else
    {
        _vwMap.hidden = NO;
        _reviewListView.hidden = YES;
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"View Rotated:");
}

#pragma mark MKMapView Concerned Methods
- (void) resetAnnotationsWithReviews: (NSArray*) reviews
{
    [_vwMap removeAnnotations: _vwMap.annotations];
    
    [reviews enumerateObjectsUsingBlock:^(NRReview* review, NSUInteger idx, BOOL *stop) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = review.latitude;
        coordinate.longitude = review.longitude;
        NRLocation *annotation = [[NRLocation alloc] initWithName: review.title address: review.restaurant coordinate: coordinate];
        annotation.review = review;
        [_vwMap addAnnotation:annotation];
    }];
    
    [self fitToRegion];
}


- (void) fitToRegion
{
	if ([_vwMap.annotations count] == 0)
		return;
	
    NSMutableArray* annotations = [NSMutableArray arrayWithArray: _vwMap.annotations];
	for(NRLocation *annotation in annotations)
    {
        if ([annotation isKindOfClass: [MKUserLocation class]]) {
            [annotations removeObject: annotation];
            break;
        }
    }
    
	NRLocation *firstMark = [annotations objectAtIndex: 0];
	CLLocationCoordinate2D topLeftCoord = firstMark.coordinate;
	CLLocationCoordinate2D bottomRightCoord = firstMark.coordinate;
	
	for(NRLocation *annotation in annotations)
    {
		if (annotation.coordinate.latitude < topLeftCoord.latitude)
			topLeftCoord.latitude = annotation.coordinate.latitude;
        
		if (annotation.coordinate.longitude > topLeftCoord.longitude)
			topLeftCoord.longitude = annotation.coordinate.longitude;
		
		if (annotation.coordinate.latitude > bottomRightCoord.latitude)
			bottomRightCoord.latitude = annotation.coordinate.latitude;
		
		if (annotation.coordinate.longitude < bottomRightCoord.longitude)
			bottomRightCoord.longitude = annotation.coordinate.longitude;
	}
	
	MKCoordinateRegion region;
	region.center.latitude = (topLeftCoord.latitude + bottomRightCoord.latitude)/2.0;
	region.center.longitude = (topLeftCoord.longitude + bottomRightCoord.longitude)/2.0;
	region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
	region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
	if (region.span.latitudeDelta < 0.01)
	{
		region.span.latitudeDelta = 0.01;
	}
	if (region.span.longitudeDelta < 0.01)
	{
		region.span.longitudeDelta = 0.01;
	}
    
	region = [_vwMap regionThatFits:region];
	[_vwMap setRegion:region animated:YES];
}

#pragma mark MKMapView

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"NRLocation";
    if ([annotation isKindOfClass:[NRLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"buttonicon_namelocation"];//here we use a nice image instead of the default pins
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NRLocation *location = (NRLocation*)view.annotation;
    if (location.review) {
        [self reviewSelected: location.review];
    }
//    
//    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
//    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}

@end
