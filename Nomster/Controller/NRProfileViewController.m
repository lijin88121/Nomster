//
//  NRProfileViewController.m
//  Nomster
//
//  Created by Li Jin on 12/10/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRProfileViewController.h"

@interface NRProfileViewController ()

@end

@implementation NRProfileViewController

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
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onPhoto:)];
    [self.imgPhoto addGestureRecognizer: recognizer];
    [self.imgPhoto setImage: [UIImage imageNamed: @"img_userphoto_placeholder"]];
    
    NRUser* user = [NRMaster master].user;
    _txtEmail.text = user.email;
    _txtFirstname.text = user.firstName;
    _txtLastname.text = user.lastName;
    
    [_imgPhoto setImageUrl: user.avatarURL];
}

- (void) onBack: (id) sender
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

- (BOOL) checkInputData
{
    NSString* errorMessage = nil;
    if ([_txtPassword.text length] != 0 || [_txtConfirm.text length] != 0) {
        if (![_txtPassword.text isEqualToString: _txtConfirm.text])
        {
            errorMessage = @"Password doesn't match. Please check again";
        }
    }
    
    if (errorMessage) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Error" message: errorMessage delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}


- (IBAction)onSaveChange: (id)sender
{
    if (![self checkInputData]) {
        return;
    }
    
    NSMutableDictionary* userDict = [NSMutableDictionary dictionary];
    [userDict setObject: _txtEmail.text forKey: @"email"];
    [userDict setObject: _txtFirstname.text forKey: @"firstname"];
    [userDict setObject: _txtLastname.text forKey: @"lastname"];
    if ([_txtPassword.text length] != 0) {
        [userDict setObject: _txtPassword.text forKey: @"password"];
    }
    
    UIImage* image = nil;
    if (isPhotoTaken) {
        image = _imgPhoto.image;
    }

    [ZAActivityBar showWithStatus: @"Saving Changes..."];
    [[NRAPIManager manager] updateUser: [NRMaster master].user attribute: userDict photo: image block:^(NRUser* user) {
        [ZAActivityBar dismiss];
        if (user) {
            [NRMaster master].user = user;
            [[NRMaster master] storeUser];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Update Success" message: nil delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Update Failed" message: @"Please confirm your credentials again." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void) onPhoto: (id) sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle: @"Choose your profile picture" delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"From your camera roll", @"Take new photo", nil];
    [actionSheet showInView: self.view];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor: NR_COLOR forState: UIControlStateNormal];
            [button setTitleColor: [NR_COLOR colorWithAlphaComponent: 0.4f] forState: UIControlStateHighlighted];
            [button setTitleColor: [NR_COLOR colorWithAlphaComponent: 0.6f] forState: UIControlStateSelected];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    [picker dismissViewControllerAnimated: YES completion: nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    if (image) {
        isPhotoTaken = YES;
        [self.imgPhoto setImage: image];
    }
    [picker dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([NRUIManager isIPad] == NO) {
        int offset = MAX(0, 20 + 216 - (_scrollView.contentSize.height - textField.frame.origin.y - 30) + (_scrollView.contentSize.height - _scrollView.frame.size.height));
        if (offset > 0) {
            [_scrollView setContentOffset: CGPointMake(0, offset) animated: YES];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([NRUIManager isIPad] == NO) {
        [_scrollView setContentOffset: CGPointZero animated: YES];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
