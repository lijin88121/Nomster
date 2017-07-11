//
//  NRFollowerViewController.h
//  Nomster
//
//  Created by Li Jin on 11/29/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"

@interface NRFollowerViewController : NRBaseViewController
{
    NRUser*     selectedUser;
}

@property (nonatomic, strong) IBOutlet UITableView* tblFollowers;
@property (nonatomic, strong) NSMutableArray*       followers;
@end
