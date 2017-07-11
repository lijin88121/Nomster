//
//  NRCategoriesViewController.h
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRBaseViewController.h"
@protocol NRCategoriesViewControllerDelegate <NSObject>
- (void) categorySelected: (NRCategory*) category;
@end

@interface NRCategoriesViewController : NRBaseViewController
@property (nonatomic, strong) IBOutlet UITableView*             tblCategories;
@property (nonatomic, strong) NSMutableArray*                   categories;
@property (nonatomic, strong) id<NRCategoriesViewControllerDelegate>    delegate;
@end
