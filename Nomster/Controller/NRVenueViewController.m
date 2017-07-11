//
//  NRVenueViewController.m
//  Nomster
//
//  Created by Li Jin on 11/9/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRVenueViewController.h"

@interface NRVenueViewController ()

@end

@implementation NRVenueViewController

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
    if ([NRMaster master].foursquare == nil) {
        [NRMaster master].foursquare = [[BZFoursquare alloc] initWithClientID: kClientID callbackURL:kCallbackURL];
        [NRMaster master].foursquare.clientSecret = kClientSecret;
    }

    [self initView];
    
    self.venues = [NRMaster master].venuesAroundme;
    if (self.venues == nil || [self.venues count] == 0) {
        self.foursquare = [NRMaster master].foursquare;
        self.foursquare.version = @"20120609";
        self.foursquare.locale = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
        self.foursquare.sessionDelegate = self;
        
        [self loadVenues];
    }
    else
    {
        [_tblVenues reloadData];
    }
}

- (void) initView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_done_green"] style:UIBarButtonItemStyleBordered target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    _vwTitleContainer.layer.borderColor = RGB(226, 226, 226).CGColor;
    _vwTitleContainer.layer.borderWidth = 1.0f;
}

- (void) onBack: (id) sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) onDone: (id) sender
{
    if (self.selectedVenue) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(venueSelected:)]) {
            [self.delegate venueSelected: self.selectedVenue];
        }
        [self.navigationController popViewControllerAnimated: YES];
    }
    else
    {
        [self createVenue];
        if (self.selectedVenue != nil) {
            if (self.delegate && [self.delegate respondsToSelector: @selector(venueSelected:)]) {
                [ZAActivityBar showWithStatus: @"Getting Address..."];
                [[NRAPIManager manager] getAddressFromCoordinate: [NRMaster master].currentLocation.coordinate block:^(NSString *address) {
                    [ZAActivityBar dismiss];
                    self.selectedVenue.description = address;
                    [self.delegate venueSelected: self.selectedVenue];
                    [self.navigationController popViewControllerAnimated: YES];
                }];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Warnning" message: @"You haven't chose any venues here. Please choose one." delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)cancelRequest {
    if (_request) {
        _request.delegate = nil;
        [_request cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
}

- (void)searchVenues {
    [self prepareForRequest];
    
    NSString* gpsLocation = [NSString stringWithFormat: @"%f,%f", [NRMaster master].currentLocation.coordinate.latitude, [NRMaster master].currentLocation.coordinate.longitude];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: /*@"40.7,-74"*/gpsLocation, @"ll",
                               @"100000", @"radius", nil];
    
    self.request = [_foursquare userlessRequestWithPath: @"venues/search" HTTPMethod: @"GET" parameters: parameters delegate: self];
    [_request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void) loadVenues
{
    [ZAActivityBar showWithStatus: @"Loading Venues..."];
    [self searchVenues];
}

#pragma mark BZFoursquareRequestDelegate
- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    NSLog(@"iconurl_bg_64.png");
    NSMutableArray* venueArray = [request.response safeObjectForKey: @"venues"];
    [self parseVenueArray: venueArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tblVenues reloadData];
        [ZAActivityBar dismiss];
    });
}

- (void) parseVenueArray: (NSMutableArray*) venueArray
{
    if (self.venues == nil) {
        self.venues = [NSMutableArray array];
    }
    
    for (NSDictionary* dict in venueArray) {
        NRVenue* venue = [NRVenue venueFromDict: dict];
        [self.venues addObject: venue];
    }
    [NRMaster master].venuesAroundme = [NSMutableArray arrayWithArray: self.venues];
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    [ZAActivityBar dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.candidates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VenueCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize: 13];
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 10];
    }

    NRVenue* venue = [self.candidates objectAtIndex: indexPath.row];
    NSString* title = venue.title;
    if (venue.category != nil && ![venue.category isKindOfClass: [NSNull class]]) {
        title = [title stringByAppendingFormat: @" (%@)", venue.category];
    }
	cell.textLabel.text = title;
    cell.detailTextLabel.text = venue.description;
//	[cell.imageView setImageUrl: venue.icon];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedVenue = [self.candidates objectAtIndex: indexPath.row];
    NSString* title = self.selectedVenue.title;
    if (self.selectedVenue.category != nil && ![self.selectedVenue.category isKindOfClass: [NSNull class]]) {
        title = [title stringByAppendingFormat: @" (%@)", self.selectedVenue.category];
    }
    _txtPlacename.text = title;
}

#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
    [self loadVenues];
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}

- (void) prepareCandidates: (NSString*) str
{
    if (_candidates == nil) {
        self.candidates = [NSMutableArray array];
    }
    else
    {
        [_candidates removeAllObjects];
    }
    
    [self.venues enumerateObjectsUsingBlock:^(NRVenue* venue, NSUInteger idx, BOOL *stop) {
        if ([venue.title.lowercaseString rangeOfString: str.lowercaseString].length != 0 ||
            [venue.description.lowercaseString rangeOfString: str.lowercaseString].length != 0)
        {
            [_candidates addObject: venue];
        }
    }];
    [_tblVenues reloadData];
}

- (void) createVenue
{
    if ([_txtPlacename.text length] > 0) {
        self.selectedVenue = [NRVenue new];
        self.selectedVenue.title = _txtPlacename.text;
        self.selectedVenue.latitude = [NRMaster master].currentLocation.coordinate.latitude;
        self.selectedVenue.longitude = [NRMaster master].currentLocation.coordinate.longitude;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _tblVenues.hidden = NO;
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self prepareCandidates: textField.text];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _tblVenues.hidden = YES;
    NSString *string = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length > 0)
    {
        [textField resignFirstResponder];
        return NO;
    }
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

@end
