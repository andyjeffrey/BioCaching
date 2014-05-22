//
//  LoginManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginManager;

@protocol LoginManagerDelegate <NSObject>
@optional
- (void)loginSuccess;
- (void)loginFailure;
- (void)logoutCompleted;
@end

@interface LoginManager : NSObject

@property (nonatomic, weak) id <LoginManagerDelegate> delegate;
@property (nonatomic, readonly, assign) BOOL loggedIn;

+ (instancetype)sharedInstance;

- (void)configureOAuth2Client;
- (void)loginToINat;
- (void)logout;

@end
