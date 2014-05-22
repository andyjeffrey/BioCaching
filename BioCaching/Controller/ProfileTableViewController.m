//
//  ProfileTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 22/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "LoginManager.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelAccountName;
@property (weak, nonatomic) IBOutlet UILabel *labelSignInOut;
@property (weak, nonatomic) IBOutlet UILabel *labelPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthToken;
@end

static int const kTableCellTagSignInOut = 100;
static int const kTableCellTagResetAuth = 200;

@implementation ProfileTableViewController {
    NSUserDefaults *defaults;
}

#pragma-mark UI Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:kINatTestAccountId forKey:kINatAuthUsernamePrefKey];
    [defaults setValue:kINatTestAccountPassword forKey:kINatAuthPasswordPrefKey];
    [defaults synchronize];
    [LoginManager sharedInstance].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUI];
}


#pragma-mark Setup Methods

- (void)setupUI
{
    self.labelAccountName.text = [defaults objectForKey:kINatAuthUsernamePrefKey];
    self.labelPassword.text = [defaults objectForKey:kINatAuthPasswordPrefKey];
    
    if ([defaults objectForKey:kINatAuthTokenPrefKey]) {
        self.labelAuthToken.text = [defaults objectForKey:kINatAuthTokenPrefKey];
        self.labelSignInOut.text = @"Sign Out";
    } else {
        self.labelAuthToken.text = @"";
        self.labelSignInOut.text = @"Sign In";
    }
    
}


#pragma-mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    switch (selectedCell.tag) {
        case kTableCellTagSignInOut:
            NSLog(@"SignInOut Selected");
            if ([defaults objectForKey:kINatAuthTokenPrefKey]) {
                [[LoginManager sharedInstance] logout];
            } else {
                [[LoginManager sharedInstance] loginToINat];
            }
            break;
        case kTableCellTagResetAuth:
            NSLog(@"ResetAuth Selected");
            [[LoginManager sharedInstance] logout];
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // View Refreshed After Login/Out attempt by delegate
}

#pragma-mark LoginManagerDelegate
- (void)loginSuccess {
    [self setupUI];
}

- (void)loginFailure {
    [self setupUI];
}

- (void)logoutCompleted {
    [self setupUI];
}


@end
