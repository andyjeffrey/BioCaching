//
//  BCLoggingHelper.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCLoggingHelper : NSObject

/*
+ (void)configureFlurryAnalytics;
+ (void)startLocalytics;
+ (void)configureParse:(NSDictionary *)launchOptions;
*/

+ (void)stopAnalyticsIfRequired;
+ (void)resumeAnalyticsIfRequired;

+ (void)configureCrashlytics;

+ (void)configureGoogleAnalytics;
+ (void)recordGoogleScreen:(NSString *)screenName;
+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action;
+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action label:(NSString *)label;
+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action value:(NSNumber *)value;
+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
+ (void)recordGoogleTiming:(NSString *)category name:(NSString *)name timing:(NSTimeInterval)timing;

@end
