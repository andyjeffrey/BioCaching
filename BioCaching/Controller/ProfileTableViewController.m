//
//  ProfileTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 22/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ProfileTableViewController.h"

@interface ProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelSignInOut;

@property (weak, nonatomic) IBOutlet UILabel *labelUserID;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthToken;

@end

static int const kTableCellTagSignInOut = 100;
static int const kTableCellTagResetAuth = 200;

@implementation ProfileTableViewController {
    NSUserDefaults *_userDefaults;
}

#pragma-mark UI Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    [LoginManager sharedInstance].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}


#pragma-mark Setup Methods

- (void)updateUI
{
    if ([_userDefaults objectForKey:kINatAuthUserIDPrefKey])
    {
        self.textFieldUsername.text = [_userDefaults valueForKey:kINatAuthUsernamePrefKey];
        self.textFieldPassword.text = [_userDefaults valueForKey:kINatAuthPasswordPrefKey];
    } else {
#ifdef DEBUG
        self.textFieldUsername.text = kINatTestAccountId;
        self.textFieldPassword.text = kINatTestAccountPassword;
#endif
    }

    if ([_userDefaults objectForKey:kINatAuthTokenPrefKey]) {
        self.labelSignInOut.text = @"Sign Out";
        self.labelUserID.text = [[_userDefaults valueForKey:kINatAuthUserIDPrefKey] stringValue];
        self.labelAuthToken.text = [_userDefaults valueForKey:kINatAuthTokenPrefKey];
    } else {
        self.labelSignInOut.text = @"Sign In";
        self.labelUserID.text = @"Not Signed In";
        self.labelAuthToken.text = @"";
    }
    
}


#pragma-mark TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyBoard];
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    switch (selectedCell.tag) {
        case kTableCellTagSignInOut:
            NSLog(@"SignInOut Selected");
            if ([_userDefaults objectForKey:kINatAuthTokenPrefKey]) {
                [[LoginManager sharedInstance] logout];
            } else {
                [self performLogin];
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

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.textFieldUsername) {
        [self.textFieldPassword becomeFirstResponder];
    }
    return YES;
}

-(void)hideKeyBoard {
    [self.textFieldUsername resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
}

#pragma mark - LoginManager Methods
- (void)performLogin
{
    [[LoginManager sharedInstance] loginToINat:self.textFieldUsername.text password:self.textFieldPassword.text];
}

#pragma-mark LoginManagerDelegate
- (void)loginSuccess {
    [self updateUI];
}

- (void)loginFailure {
    [self updateUI];
}

- (void)logoutCompleted {
    [self updateUI];
}


@end
