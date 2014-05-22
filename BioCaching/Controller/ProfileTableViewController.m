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


@implementation ProfileTableViewController {
    NSUserDefaults *defaults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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


#pragma-mark UI Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:kINatTestAccountId forKey:kINatAuthUsernamePrefKey];
    [defaults setValue:kINatTestAccountPassword forKey:kINatAuthPasswordPrefKey];
    [defaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupUI];
    
}


#pragma-mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];

    if (selectedCell.tag == kTableCellTagSignInOut) {
        NSLog(@"SignInOut Selected");
        if ([defaults objectForKey:kINatAuthTokenPrefKey]) {
            [[LoginManager sharedInstance] logout];
        } else {
            [[LoginManager sharedInstance] loginToINat];
        }
//        [self setupUI];
    }
    
}


@end
