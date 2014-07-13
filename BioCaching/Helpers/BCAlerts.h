//
//  BCAlerts.h
//  BioCaching
//
//  Created by Andy Jeffrey on 16/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCAlerts : NSObject<UIAlertViewDelegate>

+ (void)displayDefaultInfoAlert:(NSString *)title message:(NSString *)message;
+ (void)displayOKorCancelAlert:(NSString *)title message:(NSString *)message okBlock:(void (^)(void))okBlock cancelBlock:(void (^)(void))cancelBlock;

+ (void)displayDefaultSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle;
+ (void)displayDefaultFailureNotification:(NSString *)title subtitle:(NSString *)subtitle;
+ (void)displayDefaultInfoNotification:(NSString *)title subtitle:(NSString *)subtitle;

@end
