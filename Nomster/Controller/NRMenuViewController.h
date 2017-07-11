//
//  NRMenuViewController.h
//  Nomster
//
//  Created by Li Jin on 11/1/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"

@interface NRMenuViewController : NRBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView*         tblMenu;
@property (nonatomic, strong) NSMutableArray*               menuSections;
@end
