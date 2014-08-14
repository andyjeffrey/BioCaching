//
//  BCLoggingHelper.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCLoggingHelper : NSObject

+ (void)updateCrashlyticsUserID;

+ (void)recordGoogleScreen:(NSString *)screenName;
+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action;
+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action value:(NSNumber *)value;
+ (void)recordGoogleTiming:(NSString *)category name:(NSString *)name timing:(NSTimeInterval)timing;

@end
