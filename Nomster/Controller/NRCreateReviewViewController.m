//
//  NRCreateReviewViewController.m
//  Nomster
//
//  Created by Li Jin on 11/8/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRCreateReviewViewController.h"
#import "NRImageEditViewController.h"
#import "NRButtonCell.h"
#import "NRReviewSharedViewController.h"

@interface NRCreateReviewViewController ()

@end

@implementation NRCreateReviewViewController

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
    [self initButtonOptions];
    [self initView];
    [self onPhoto: nil];
}

- (void) initView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_share"] style:UIBarButtonItemStyleBordered target:self action:@selector(onShare:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) initButtonOptions
{
    _optionItems = [NSMutableDictionary dictionary];
    NRButtonActionItem* item = [NRButtonActionItem itemWithTitle: @"Category: ie, Drink, Appetizer, Entree" image: [UIImage imageNamed: @"buttonicon_category"] target: self action: @selector(onCategory:)];
    [_optionItems setObject: item forKey: @0];
    item = [NRButtonActionItem itemWithTitle: @"Name This Location" image: [UIImage imageNamed: @"buttonicon_namelocation"] target: self action: @selector(onLocation:)];
    [_optionItems setObject: item forKey: @1];
    item = [NRButtonActionItem itemWithTitle: @"Tag People" image: [UIImage imageNamed: @"buttonicon_tagpeople"] target: self action: @selector(onTagPeople:)];
    [_optionItems setObject: item forKey: @2];
  
    _tblOption.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tblOption.bounds.size.width, 10.0f)];
    [_tblOption reloadData];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onPhoto:)];
    [_imgPhoto addGestureRecognizer: recognizer];
}

- (void) onBack: (id) sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (NSString*) getTagString
{
    NSMutableString* tagString = [NSMutableString string];
    [_taggedPeople enumerateObjectsUsingBlock:^(NRUser* user, NSUInteger idx, BOOL *stop) {
        NSString* strTag = user.userID;
        if ([user.userID isEqualToString: @"-1"]) {
            strTag = user.fullName;
        }
        
        if (idx == 0) {
            [tagString appendString: strTag];
        }
        else
        {
            [tagString appendFormat: @", %@", strTag];
        }
    }];
    return  tagString;
}

- (void) onShare: (UIBarButtonItem*) sender
{
    if ([self checkInputedData] == NO) {
        return;
    }
    
    sender.enabled = NO;
    NSMutableDictionary* reviewDict = [NSMutableDictionary dictionary];
    [reviewDict setSafeObject: [NRMaster master].user.userID forKey: @"userid"];
    [reviewDict setSafeObject: _tvTitle.text forKey: @"title"];
    [reviewDict setSafeObject: _selectedVenue.title forKey: @"restaurant"];
    [reviewDict setSafeObject: [self getTagString] forKey: @"tag"];
    [reviewDict setSafeObject: _selectedCategory.categoryID forKey: @"category"];
    [reviewDict setSafeObject: [NSNumber numberWithFloat: _selectedVenue.latitude] forKey: @"latitude"];
    [reviewDict setSafeObject: [NSNumber numberWithFloat: _selectedVenue.longitude] forKey: @"longitude"];
    [reviewDict setSafeObject: _selectedVenue.description forKey: @"description"];
    
    [[NRAPIManager manager] createReview: [NRMaster master].user.userID attribute: reviewDict  photo: _imgPhoto.image block:^(NRReview *review) {
        if (review) {
            if (isNeededToShareDirectly) {
                [self dismissViewControllerAnimated: NO completion: nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NRMaster processFinishReview: review];
                });
            }
            else
            {
                [NRMaster registerReviewNotification: review];
                [self dismissViewControllerAnimated: NO completion:^{
                    NRReviewSharedViewController* pController = (id)[NRUIManager loadViewController: @"sid_reviewsharedviewcontroller"];
                    [[NRUIManager manager].revealViewController presentViewController: pController animated: YES completion: nil];
                }];
            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Failure" message: @"Try again a bit later, please" delegate: nil cancelButtonTitle: nil otherButtonTitles: @"Ok", nil];
            [alert show];
        }
        sender.enabled = YES;
    }];
}

- (BOOL) checkInputedData
{
    NSString* message = nil;
    if (!isPhotoTaken) {
        message = @"Please take a photo of the food first.";
    }
    else if ([_tvTitle.text length] == 0 || [_tvTitle.text isEqualToString: @"Tell us what you are eating"])
    {
        message = @"Please input what you are eating.";
    }
    else if (_selectedCategory == nil) {
        message = @"Please choose the category";
    }
    else if (_selectedVenue == nil) {
        message = @"Please choose the venue";
    }
    
    if (message) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Warnning" message: message delegate: nil cancelButtonTitle: nil otherButtonTitles: @"Ok", nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void) onPhoto: (id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Take a picture" message: nil delegate: self cancelButtonTitle: nil otherButtonTitles: @"From camera roll", @"Take new photo", @"Cancel", nil];
    [alert show];
}

- (void) onCategory: (id) sender
{
    [self performSegueWithIdentifier: @"sid_categories" sender: self];
}

- (void) onLocation: (id) sender
{
    [self performSegueWithIdentifier: @"sid_venues" sender: self];
}

- (void) onTagPeople: (id) sender
{
    [self performSegueWithIdentifier: @"sid_tagpeople" sender: self];
}

- (void) setSelectedVenue:(NRVenue *) aVenue
{
    _selectedVenue = aVenue;
    NRButtonActionItem* item = [self.optionItems objectForKey: @1];
    item.title = aVenue.title;
    [_tblOption reloadRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation: UITableViewRowAnimationAutomatic];
}

- (void) setSelectedCategory:(NRCategory*) selectedCategory
{
    _selectedCategory = selectedCategory;
    NRButtonActionItem* item = [self.optionItems objectForKey: @0];
    item.title = selectedCategory.title;
    [_tblOption reloadRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
}

- (void) setTaggedPeople:(NSMutableArray *) array
{
    _taggedPeople = array;
    NSMutableString*    taggedString = [NSMutableString string];
    [_taggedPeople enumerateObjectsUsingBlock:^(NRUser* user, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [taggedString appendFormat: @"%@", user.fullName];
        }
        else
            [taggedString appendFormat: @", %@", user.fullName];
    }];
    
    NRButtonActionItem* item = [self.optionItems objectForKey: @2];
    item.title = taggedString;
    [_tblOption reloadRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation: UITableViewRowAnimationAutomatic];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0 && buttonIndex != 1) {
        return;
    }
    
    UIImagePickerController* pController = [UIImagePickerController new];
    pController.delegate = self;
    
    if (buttonIndex == 0) { ///Choose existing photo
        pController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 1) { //Take new Photo
        pController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController: pController animated: YES completion: nil];
}

#pragma mark ImagePickerController Delegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (!isPhotoTaken) {
        isNeededToShareDirectly = NO;
    }
    
    [picker dismissViewControllerAnimated: NO completion: nil];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        isNeededToShareDirectly = YES;
    }
    else
    {
        isNeededToShareDirectly = NO;
    }
    
    UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    if (image) {
        [self performSegueWithIdentifier: @"sid_editphoto" sender: image];
    }
    [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ButtonCell";
    NRButtonCell* cell = (NRButtonCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[NRButtonCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }

    NRButtonActionItem* item = [_optionItems objectForKey: [NSNumber numberWithInteger: indexPath.section]];
	cell.textLabel.text = item.title;
	cell.imageView.image = item.image;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NRButtonActionItem* item = [_optionItems objectForKey: [NSNumber numberWithInteger: indexPath.section]];
    [item.target performSelector: item.action withObject: nil];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"Tell us what you are eating"]) {
        textView.text = @"";
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"Tell us what you are eating";
    }
}

#pragma mark NRVenueViewControllerDelegate
- (void) venueSelected:(NRVenue *)venue
{
    self.selectedVenue = venue;
}

#pragma mark NRCategoryViewControllerDelegate
- (void) categorySelected:(NRCategory*) category
{
    self.selectedCategory = category;
}

#pragma mark NRTagPeopleViewControllerDelegate
- (void) peopleSelected:(NSMutableArray *)people
{
    self.taggedPeople = [NSMutableArray arrayWithArray: people];
}

- (void) saveImageToCameraRoll: (UIImage*) image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

#pragma mark Segue
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        if ([rvc.frontViewController isKindOfClass: [UINavigationController class]]) {
            UIViewController* viewController = [[(UINavigationController*)rvc.frontViewController viewControllers] objectAtIndex:0];
            if ([viewController.restorationIdentifier isEqualToString: [segue.destinationViewController restorationIdentifier]]) {
                [rvc setFrontViewController: rvc.frontViewController animated: YES];
                return;
            }
        }
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController: dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
    else if ([segue.identifier isEqualToString: @"sid_editphoto"])
    {
        UIImage* image = (id)sender;
        NRImageEditViewController* pController = (id)segue.destinationViewController;
        pController.sourceImage = image;
        [pController reset: NO];
        pController.doneCallback = ^(UIImage *editedImage, BOOL canceled){
            if(!canceled) {
                isPhotoTaken = YES;
                _imgPhoto.image = editedImage;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    [self saveImageToCameraRoll: editedImage];
                });
            }
            else
            {
                if (!isPhotoTaken) {
                    isNeededToShareDirectly = NO;
                }
            }
            [self.navigationController popViewControllerAnimated: YES];
        };
    }
    else if ([segue.identifier isEqualToString: @"sid_venues"])
    {
        NRVenueViewController* pController = (id) segue.destinationViewController;
        pController.delegate = self;
    }
    else if ([segue.identifier isEqualToString: @"sid_categories"])
    {
        NRCategoriesViewController* pController = (id) segue.destinationViewController;
        pController.delegate = self;
    }
    else if ([segue.identifier isEqualToString: @"sid_tagpeople"])
    {
        NRTagPeopleViewController* pController = (id) segue.destinationViewController;
        pController.delegate = self;
        pController.taggedUsers = _taggedPeople;
    }
}

@end
