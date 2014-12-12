//
//  LoginManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginManagerDelegate <NSObject>
@optional
- (void)loginSuccess;
- (void)loginFailure;
- (void)logoutCompleted;
@end

@interface LoginManager : NSObject

@property (nonatomic, weak) id <LoginManagerDelegate> delegate;
@property (nonatomic, readonly, assign) BOOL loggedIn;
@property (nonatomic, readonly, assign) BOOL isTesting;
@property (nonatomic, readonly) NSString *currentUserID;

+ (instancetype)sharedInstance;

- (void)configureOAuth2Client;
- (void)loginToINat:(NSString *)username password:(NSString *)password;
- (void)logout;

@end
