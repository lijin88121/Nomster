//
//  NRRegisterViewController.h
//  Nomster
//
//  Created by Li Jin on 11/5/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRRegisterViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    BOOL    isPhotoSelected;
}

@property (nonatomic, strong) IBOutlet UIScrollView*            scrollView;
@property (nonatomic, strong) IBOutlet NRCircularImageView*     imgPhoto;
@property (nonatomic, strong) IBOutlet UITextField*             txtUsername;
@property (nonatomic, strong) IBOutlet UITextField*             txtEmail;
@property (nonatomic, strong) IBOutlet UITextField*             txtFirstname;
@property (nonatomic, strong) IBOutlet UITextField*             txtLastname;
@property (nonatomic, strong) IBOutlet UITextField*             txtPhone;
@property (nonatomic, strong) IBOutlet UITextField*             txtAge;
@property (nonatomic, strong) IBOutlet UITextField*             txtPassword;
@property (nonatomic, strong) IBOutlet UITextField*             txtConfirm;
@property (nonatomic, strong) IBOutlet UISwitch*                swGender;
@property (nonatomic, strong) NSDictionary<FBGraphUser>*        fbUserInfo;
@end
