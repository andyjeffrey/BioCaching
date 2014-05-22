//
//  LoginManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

@property (nonatomic, assign) BOOL loggedIn;

+ (instancetype)sharedInstance;

- (void)configureOAuth2Client;
- (void)loginToINat;
- (void)logout;

@end
