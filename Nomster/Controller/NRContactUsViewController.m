//
//  NRContactUsViewController.m
//  Nomster
//
//  Created by Li Jin on 12/10/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRContactUsViewController.h"

@interface NRContactUsViewController ()

@end

@implementation NRContactUsViewController

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
}

- (void) onBack: (id) sender
{
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onEmailNomster:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Hello, Nomnoms"];
    [controller setMessageBody:@"Hello, Nomnoms" isHTML:NO];
    [self presentViewController: controller animated: YES completion: nil];
}

- (IBAction)onTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/eatnoms"]];
}

- (IBAction)onFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/eatnoms"]];
}

- (IBAction)onHomepage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://nomster.co/"]];
}

#pragma mark MailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Nomster" message: @"Message has been successfully sent." delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end
