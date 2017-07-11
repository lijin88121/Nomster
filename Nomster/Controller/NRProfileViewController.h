//
//  NRProfileViewController.h
//  Nomster
//
//  Created by Li Jin on 12/10/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"

@interface NRProfileViewController : NRBaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    BOOL isPhotoTaken;
}
@property (nonatomic, strong) IBOutlet UIScrollView*            scrollView;
@property (nonatomic, strong) IBOutlet NRCircularImageView*     imgPhoto;
@property (nonatomic, strong) IBOutlet UITextField*             txtEmail;
@property (nonatomic, strong) IBOutlet UITextField*             txtFirstname;
@property (nonatomic, strong) IBOutlet UITextField*             txtLastname;
@property (nonatomic, strong) IBOutlet UITextField*             txtPassword;
@property (nonatomic, strong) IBOutlet UITextField*             txtConfirm;
@end
