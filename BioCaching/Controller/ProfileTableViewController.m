//
//  ProfileTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 22/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "BCWebViewController.h"

@interface ProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UILabel *labelSignInOut;
@property (weak, nonatomic) IBOutlet BCButtonRounded *buttonSignInOut;


@property (weak, nonatomic) IBOutlet UILabel *labelUserID;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthToken;

- (IBAction)buttonActionSignInOut:(id)sender;
- (IBAction)buttonActionSignUp:(id)sender;

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
    if ([LoginManager sharedInstance].loggedIn)
    {
        self.textFieldUsername.text = [_userDefaults valueForKey:kINatAuthUsernamePrefKey];
        self.textFieldPassword.text = [_userDefaults valueForKey:kINatAuthPasswordPrefKey];

        self.textFieldUsername.backgroundColor = [UIColor lightGrayColor];
        self.textFieldPassword.backgroundColor = [UIColor lightGrayColor];
        
        self.labelSignInOut.text = @"Sign Out";
        [self.buttonSignInOut setTitle:@"Sign Out" forState:UIControlStateNormal];
        self.labelUserID.text = [[_userDefaults valueForKey:kINatAuthUserIDPrefKey] stringValue];
        self.labelAuthToken.text = [_userDefaults valueForKey:kINatAuthTokenPrefKey];
    } else {
#ifdef TESTING
        self.textFieldUsername.text = kINatTestAccountId;
        self.textFieldPassword.text = kINatTestAccountPassword;
#endif
        self.textFieldUsername.backgroundColor = [UIColor whiteColor];
        self.textFieldPassword.backgroundColor = [UIColor whiteColor];

        self.labelSignInOut.text = @"Sign In";
        [self.buttonSignInOut setTitle:@"Sign In" forState:UIControlStateNormal];
        self.labelUserID.text = @"Not Signed In";
        self.labelAuthToken.text = @"";
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Include extra details for testing
#ifdef TESTING
    return 4;
#else
    return 3;
#endif
}

#pragma-mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
    if (section == 2 && ([LoginManager sharedInstance].loggedIn)) {
        rows = 0;
    }
    return rows;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor kColorHeaderBackground];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
}

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

#pragma mark - LoginManagerDelegate
- (void)loginSuccess {
    [self updateUI];
}

- (void)loginFailure {
    [self updateUI];
}

- (void)logoutCompleted {
    [self updateUI];
}

- (IBAction)buttonActionSignUp:(id)sender
{
    NSURL *signupUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kINatBaseURL, kINatSignupURL]];
    NSLog(@"Loading URL:%@", signupUrl);

    BCWebViewController *webVC = [[BCWebViewController alloc] initWithURL:signupUrl fixedTitle:@"iNaturalist SignUp"];
    BCWebViewController * __weak weakWebVC = webVC;
    webVC.didFinishLoadBlock = ^{
        NSLog(@"webVC.didFinishLoadBlock Called, URL:%@", weakWebVC.URL.description);
        if ([weakWebVC.URL.lastPathComponent isEqualToString:@"home"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [BCAlerts displayDefaultInfoAlert:@"Welcome to iNaturalist!" message:@"Now that you've signed up you can sign in with the username and password you just created.  Don't forget to check for your confirmation email as well."];
        }
    };
    [self.navigationController pushViewController:webVC animated:TRUE];
    
//    [self presentViewController:webVC animated:YES completion:^{
//        NSLog(@"SignUp Completion Block");
//    }];
}

- (IBAction)buttonActionSignInOut:(id)sender
{
    NSLog(@"SignInOut Selected");
    if ([_userDefaults objectForKey:kINatAuthTokenPrefKey]) {
        [[LoginManager sharedInstance] logout];
    } else {
        [self performLogin];
    }
}


@end
