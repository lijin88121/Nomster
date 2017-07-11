//
//  NRRegisterViewController.m
//  Nomster
//
//  Created by Li Jin on 11/5/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRRegisterViewController.h"

@interface NRRegisterViewController ()

@end

@implementation NRRegisterViewController

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
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onPhoto:)];
    [self.imgPhoto addGestureRecognizer: recognizer];
    [self.imgPhoto setImage: [UIImage imageNamed: @"img_userphoto_placeholder"]];
    
    [self initFromFBUser];
    
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapBackground:)];
    [self.view addGestureRecognizer: recognizer];
}

- (void) onTapBackground: (id) sender
{
    [self textFieldShouldReturn: _txtUsername];
    [self textFieldShouldReturn: _txtEmail];
    [self textFieldShouldReturn: _txtFirstname];
    [self textFieldShouldReturn: _txtLastname];
    [self textFieldShouldReturn: _txtPhone];
    [self textFieldShouldReturn: _txtAge];
    [self textFieldShouldReturn: _txtPassword];
    [self textFieldShouldReturn: _txtConfirm];
}

- (void) initFromFBUser
{
    if (self.fbUserInfo == nil) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?width=150&height=150", _fbUserInfo.id]]];
        UIImage* image = [UIImage imageWithData: data];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgPhoto.image = image;
        });
    });

    _txtFirstname.text = _fbUserInfo.first_name;
    _txtLastname.text = _fbUserInfo.last_name;
    _txtEmail.text = [_fbUserInfo safeObjectForKey: @"email"];
    NSString* gender = [_fbUserInfo safeObjectForKey: @"gender"];
    if ([gender isEqualToString: @"male"]) {
        _swGender.on = NO;
    }
    else
        _swGender.on = YES;
    
    _txtUsername.text = _fbUserInfo.username;
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat: @"MM/dd/yyyy"];
    NSDate* dateBirth = [formatter dateFromString: _fbUserInfo.birthday];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate: dateBirth];
    int year = timeInterval/D_YEAR;
    _txtAge.text = [NSString stringWithFormat: @"%d", year];
}

- (BOOL) checkInputData
{
    NSString* errorMessage = nil;
    if ([_txtEmail.text length] == 0) {
        errorMessage = @"Input the email address, please";
    }
    else if ([_txtUsername.text length] == 0) {
        errorMessage = @"Input the username, please";
    }
    else if ([_txtPassword.text length] == 0 || [_txtConfirm.text length] == 0) {
        errorMessage = @"Input the password, please";
    }
    else if (![_txtPassword.text isEqualToString: _txtConfirm.text])
    {
        errorMessage = @"Password doesn't match. Please check again";
    }
    
    if (errorMessage) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Error" message: errorMessage delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (IBAction) onSignUp:(id)sender
{
    if (![self checkInputData]) {
        return;
    }
    
    NSMutableDictionary* userDict = [NSMutableDictionary dictionary];
    [userDict setObject: _txtEmail.text forKey: @"email"];
    [userDict setObject: _txtFirstname.text forKey: @"firstname"];
    [userDict setObject: _txtLastname.text forKey: @"lastname"];
    [userDict setObject: _txtAge.text forKey: @"age"];
    [userDict setObject: _txtUsername.text forKey: @"username"];
    if (_swGender.isOn == NO) {
        [userDict setObject: @"Male" forKey: @"gender"];
    }
    else
    {
        [userDict setObject: @"Female" forKey: @"gender"];
    }
    [userDict setObject: _txtPassword.text forKey: @"password"];
    [userDict setObject: _txtPhone.text forKey: @"phone"];
    
    [ZAActivityBar showWithStatus: @"Registering..."];
    [[NRAPIManager manager] userRegisterWithAttribute: userDict photo: _imgPhoto.image block: ^(NRUser *user) {
        [ZAActivityBar dismiss];
        if (user) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Registration Success" message: nil delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Registration Failed" message: @"Please confirm your credentials again." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
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
        isPhotoSelected = YES;
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
