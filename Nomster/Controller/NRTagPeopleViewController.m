//
//  NRTagPeopleViewController.m
//  Nomster
//
//  Created by Li Jin on 11/11/13.
//  Copyright (c) 2013 Li Jin. All rights reserved.
//

#import "NRTagPeopleViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NRTagPeopleViewController ()

@end

@implementation NRTagPeopleViewController

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
    [self loadFollowers];
    if (self.taggedUsers != nil && [self.taggedUsers count] > 0) {
        [self addTagsFromUserArray: self.taggedUsers];
    }
}

- (void) initView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(onBack:)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc] initWithImage: [NRUIManager imageNamed: @"navigation_button_done_green"] style:UIBarButtonItemStyleBordered target:self action:@selector(onDone:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;

    _scrollView.layer.borderColor = RGB(226, 226, 226).CGColor;
    _scrollView.layer.borderWidth = 1.0f;
    [self adjustLayout];
}

- (void) addTagsFromUserArray: (NSMutableArray*) users
{
    [users enumerateObjectsUsingBlock:^(NRUser* user, NSUInteger idx, BOOL *stop) {
        AOTag* tag = [_tagView addTag: user.fullName];
        tag.tagID = user.userID;
    }];
}

- (void) adjustLayout
{
    CGRect rt = _tagView.frame;
    rt.origin.y = 10;
    _tagView.frame = rt;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 20 + _tagView.frame.size.height);
    
    CGRect tblRect = _tblCandidates.frame;
    tblRect.origin.y = CGRectGetMaxY(tblRect);
    tblRect.size = CGSizeMake(_txtUserName.frame.size.width, 300);
    _tblCandidates.frame = tblRect;
}

- (void) onBack: (id) sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) onDone: (id) sender
{
    NSMutableArray* taggedPeople = [NSMutableArray array];
    [_tagView.tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AOTag* tag = obj;
        NRUser* user = [NRUser new];
        user.userID = tag.tagID;
        user.fullName = tag.tTitle;
        [taggedPeople addObject: user];
    }];
    
    if ([taggedPeople count] > 0) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(peopleSelected:)]) {
            [self.delegate peopleSelected: taggedPeople];
        }
    }

    [self.navigationController popViewControllerAnimated: YES];
}

- (void) loadFollowers
{
    self.followers = [NRMaster master].followers;
    if (self.followers && [self.followers count] > 0) {
        [_tblCandidates reloadData];
    }
    else
    {
        [ZAActivityBar showWithStatus: @"Loading Users..."];
        [[NRAPIManager manager] followingUsers: [NRMaster master].user block:^(NSMutableArray *users) {
            [ZAActivityBar dismiss];
            [NRMaster master].followers = [NSMutableArray arrayWithArray: users];
            self.followers = [NRMaster master].followers;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tblCandidates reloadData];
            });
        }];
    }
}

- (void) prepareCandidates: (NSString*) str
{
    if (candidates == nil) {
        candidates = [NSMutableArray array];
    }
    else
    {
        [candidates removeAllObjects];
    }
    
    [self.followers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NRUser* user = obj;
        if ([user.fullName.lowercaseString rangeOfString: str.lowercaseString].length != 0) {
            [candidates addObject: user];
        }
    }];
    [_tblCandidates reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _tblCandidates.hidden = NO;
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self prepareCandidates: textField.text];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _tblCandidates.hidden = YES;
    NSString *string = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length > 0)
    {
        AOTag* tag = [self.tagView addTag:string];
        tag.tagID = @"-1";
        textField.text = @"";
        return NO;
    }
    textField.text = @"";
    [textField resignFirstResponder];
    _tblCandidates.hidden = YES;
    return YES;
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NRUIManager isIPad]) {
        return 50;
    }
    else
        return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [candidates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PeopleCell";
    UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
    
    NRUser* user = [candidates objectAtIndex: indexPath.row];
    cell.textLabel.text = user.fullName;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NRUser* user = [candidates objectAtIndex: indexPath.row];
    _tblCandidates.hidden = YES;
    [_txtUserName resignFirstResponder];
    _txtUserName.text = nil;
    AOTag* tag = [self.tagView addTag: user.fullName];
    tag.tagID = user.userID;
}

/******************************************************************
 *
 * AOTagDelegate
 *
 ******************************************************************/

#pragma mark -
#pragma mark AOTagDelegate

- (void)tagDidRemoveTag:(AOTag *)tag
{
    [self adjustLayout];
}

- (void)tagDidAddTag:(AOTag *)tag
{
    [self adjustLayout];
}

@end
