//
//  BCLoggingHelper.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCLoggingHelper.h"
#import <Crashlytics/Crashlytics.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation BCLoggingHelper

+ (void)updateCrashlyticsUserID
{
    [Crashlytics setUserIdentifier:[LoginManager sharedInstance].currentUserID];
//    [Crashlytics setUserName:[[NSUserDefaults standardUserDefaults] objectForKey:kINatAuthUsernamePrefKey]];
}

+ (void)recordGoogleScreen:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action
{
    [self recordGoogleEvent:category action:action value:nil];
}

+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action value:(NSNumber *)value
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category action:action label:[LoginManager sharedInstance].currentUserID value:value] build]];
}


+ (void)recordGoogleTiming:(NSString *)category name:(NSString *)name timing:(NSTimeInterval)timing
{
    NSNumber *timeInterval = @((int)(timing * 1000));
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category interval:timeInterval name:name label:[LoginManager sharedInstance].currentUserID] build]];
}

@end