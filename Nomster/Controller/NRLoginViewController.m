//
//  NRLoginViewController.m
//  Nomster
//
//  Created by Li Jin on 11/5/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRLoginViewController.h"
#import "NRRegisterViewController.h"

@interface NRLoginViewController ()

@end

@implementation NRLoginViewController

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
    [self initView];
}

- (void) initView
{
    UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleDone target: self action: @selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapBackground:)];
    [self.view addGestureRecognizer: recognizer];
}

- (void) onTapBackground: (id) sender
{
    [self textFieldShouldReturn: _txtEmail];
    [self textFieldShouldReturn: _txtPassword];
}

- (void) onBack: (id) sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (BOOL) checkInputData
{
    if ([_txtEmail.text length] == 0 || [_txtPassword.text length] == 0) {
        return NO;
    }
    return YES;
}

- (IBAction) onSignin:(id)sender
{
    if (![self checkInputData]) {
        return;
    }
    
    [ZAActivityBar showWithStatus: @"Login..."];
    [[NRAPIManager manager] userLoginWithEmail: _txtEmail.text password: _txtPassword.text deviceToken: [NRMaster master].deviceToken block:^(NRUser *user) {
        [ZAActivityBar dismiss];
        if (user) {
            [NRMaster master].user = user;
            [[NRMaster master] storeUser];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Login Success" message: nil delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Login Failed" message: @"Please confirm your credentials again." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

#pragma mark Facebook Login
- (IBAction) onSigninWithFacebook:(id)sender
{
    [ZAActivityBar showWithStatus: @"Logging in Facebook..."];
    [self openSession];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            [self facebookConnectionRetry];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    NSArray* permissions = @[@"email", @"user_birthday"];
    [FBSession openActiveSessionWithReadPermissions: permissions
                                       allowLoginUI:YES
                                  completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void) loadUserInformation: (void(^)(NSDictionary<FBGraphUser>* user, NSError* error)) block {
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser>* userFB, NSError *error) {
         if (!error) {
              block (userFB, nil);
         }
         else
         {
              if (block) {
                   block(nil, error);
              }
         }
    }];
}

- (void)facebookConnectionRetry {
    [self loadUserInformation:^(NSDictionary<FBGraphUser>* user, NSError *error) {
        if (error) {
            [self performSelector: @selector(facebookConnectionRetry) withObject:nil afterDelay:10];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self goSignUpWithUserInformation: user];
            });
        }
    }];
}

- (void) goSignUpWithUserInformation: (NSDictionary<FBGraphUser>*) user
{
    [ZAActivityBar dismiss];
    NRRegisterViewController* pController = (id)[NRUIManager loadViewController: @"sid_signupviewcontroller"];
    pController.fbUserInfo = user;
    [self.navigationController pushViewController: pController animated: YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([NRUIManager isIPad] == NO) {
        int offset = MAX(0, textField.frame.origin.y - self.view.frame.size.height + 216 + 44);
        if (offset > 0) {
            CGRect rt = self.view.frame;
            rt.origin.y = -offset;
            [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
                self.view.frame = rt;
            } completion: nil];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([NRUIManager isIPad] == NO) {
        CGRect rt = self.view.frame;
        rt.origin.y = 0;
        [UIView animateWithDuration: 0.3f delay:0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
            self.view.frame = rt;
        } completion: nil];
    }
    
    [textField resignFirstResponder];
    return YES;
}


@end
