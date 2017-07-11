//
//  NRTagPeopleViewController.h
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
#import "AOTag.h"
#import "SLGlowingTextField.h"

@protocol NRTagPeopleViewControllerDelegate <NSObject>
- (void) peopleSelected: (NSMutableArray*) people;
@end

@interface NRTagPeopleViewController : NRBaseViewController <AOTagDelegate>
{
    NSMutableArray*     candidates;
}

@property (nonatomic, strong) NSMutableArray*               followers;
@property (nonatomic, strong) IBOutlet SLGlowingTextField*  txtUserName;
@property (nonatomic, strong) IBOutlet AOTagList*           tagView;
@property (nonatomic, strong) IBOutlet UIScrollView*        scrollView;
@property (nonatomic, strong) IBOutlet UITableView*         tblCandidates;
@property (nonatomic, strong) NSMutableArray*               taggedUsers;

@property (nonatomic, strong) id<NRTagPeopleViewControllerDelegate> delegate;

@end
