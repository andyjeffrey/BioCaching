//
//  LoginManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager {
    NSString *AccountType;
    NSString *INatAccessToken;
    BOOL isLoginCompleted;
    NSString *_iNatAccessUsername;
    NSString *_iNatAccessPassword;
    NSUserDefaults *_userDefaults;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static LoginManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[LoginManager sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        AccountType = kINatAuthService;
        [self initOAuth2Service];
    }
    return self;
}

- (BOOL)loggedIn
{
    if ([_userDefaults objectForKey:kINatAuthTokenPrefKey]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)configureOAuth2Client{
    NXOAuth2AccountStore *sharedStore = [NXOAuth2AccountStore sharedStore];
    for (NXOAuth2Account *account in [sharedStore accountsWithAccountType:kINatAuthService]) {
        // Do something with the account
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    };
    //
    NSURL *authorizationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authorize?client_id=%@&redirect_uri=urn%%3Aietf%%3Awg%%3Aoauth%%3A2.0%%3Aoob&response_type=code", kINatBaseURL, kINatClientID ]];
    [[NXOAuth2AccountStore sharedStore] setClientID:kINatClientID
                                             secret:kINatClientSecret
                                   authorizationURL:authorizationURL
                                           tokenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/token", kINatBaseURL]]
                                        redirectURL:[NSURL URLWithString:@"urn:ietf:wg:oauth:2.0:oob"]
                                     forAccountType:kINatAuthService];
    
    for (NXOAuth2Account *account in [sharedStore accountsWithAccountType:kINatAuthServiceExtToken]) {
        // Do something with the account
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    };
    [[NXOAuth2AccountStore sharedStore] setClientID:kINatClientID
                                             secret:kINatClientSecret
                                   authorizationURL:authorizationURL
                                           tokenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/assertion_token.json", kINatBaseURL]]
                                        redirectURL:[NSURL URLWithString:@"urn:ietf:wg:oauth:2.0:oob"]
                                     forAccountType:kINatAuthServiceExtToken];
}

- (void)loginToINat:(NSString *)iNatUsername password:(NSString *)iNatPassword
{
    isLoginCompleted = NO;
    _iNatAccessUsername = iNatUsername;
    _iNatAccessPassword = iNatPassword;
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:AccountType username:iNatUsername password:iNatPassword];
}

- (void)logout
{
    NXOAuth2AccountStore *sharedStore = [NXOAuth2AccountStore sharedStore];
    for (NXOAuth2Account *account in [sharedStore accountsWithAccountType:kINatAuthService]) {
        // Do something with the account
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    };
    [_userDefaults removeObjectForKey:kINatAuthUserIDPrefKey];
    [_userDefaults removeObjectForKey:kINatAuthTokenPrefKey];
    [_userDefaults synchronize];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:nil];
    [self.delegate logoutCompleted];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Logged Out", nil)
                                                 message:NSLocalizedString(@"You are now signed out of iNaturalist.org", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                       otherButtonTitles:nil];
    [av show];
}


#pragma mark - OAuth2 methods

-(void) initOAuth2Service{
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      if (!isLoginCompleted) {
                                                          UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Success", nil)
                                                                                                       message:NSLocalizedString(@"You are now signed in iNaturalist.org", nil)
                                                                                                      delegate:self
                                                                                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                             otherButtonTitles:nil];
                                                          [av show];
                                                          
                                                          [self finishWithAuth2Login];
/*
                                                          [TSMessage showNotificationWithTitle:@"Login Successful" subtitle:[NSString stringWithFormat:@"UserId: %@\nPassword: %@", kINatTestAccountId, kINatTestAccountPassword] type:TSMessageNotificationTypeSuccess];
*/
                                                      }
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      // Do something with the error
                                                      if (!isLoginCompleted) {
                                                          [self.delegate loginFailure];

                                                          UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", nil)
                                                                                              message:NSLocalizedString(@"Authentication credentials were invalid", nil)
                                                                                             delegate:self
                                                                                    cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                                                    otherButtonTitles:nil];
                                                              [av show];
/*
                                                          [TSMessage showNotificationWithTitle:@"Login Failed" subtitle:@"Authentication credentials were invalid" type:TSMessageNotificationTypeError];
*/
                                                      }
                                                  }];
}

-(void) finishWithAuth2Login{
    NXOAuth2AccountStore *sharedStore = [NXOAuth2AccountStore sharedStore];
    BOOL loginSuccessed = NO;
    for (NXOAuth2Account *account in [sharedStore accountsWithAccountType:AccountType]) {
        NSString *accessT = [[account accessToken] accessToken];
        if (accessT && [accessT length]>0){
            INatAccessToken = nil;
            INatAccessToken = [NSString stringWithFormat:@"Bearer %@", accessT ];
            loginSuccessed = YES;
        }
        //NSLog(@"account %@  INatAccessToken %@",account, INatAccessToken);
    }
    if (loginSuccessed){
        isLoginCompleted = YES;
        [_userDefaults setValue:_iNatAccessUsername forKey:kINatAuthUsernamePrefKey];
        [_userDefaults setValue:_iNatAccessPassword forKey:kINatAuthPasswordPrefKey];
        [_userDefaults setValue:INatAccessToken forKey:kINatAuthTokenPrefKey];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:INatAccessToken];
        [self removeOAuth2Observers];
        
        [[RKObjectManager sharedManager].HTTPClient getPath:@"/users/edit.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Login Success, Response: %@", responseObject);
            [_userDefaults setValue:[responseObject valueForKey:@"id"] forKey:kINatAuthUserIDPrefKey];
            [_userDefaults synchronize];
            [self.delegate loginSuccess];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Login Error, Response: %@", error);
            [_userDefaults setValue:nil forKey:kINatAuthUserIDPrefKey];
            [_userDefaults setValue:nil forKey:kINatAuthTokenPrefKey];
            [self.delegate loginFailure];
        }];
    }
    else {
        NSLog(@"finishWithAuth2Login failedLogin");
    }
}

- (void)removeOAuth2Observers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:[NXOAuth2AccountStore sharedStore]];
}

@end
