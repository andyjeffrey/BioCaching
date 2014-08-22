//
//  BCLoggingHelper.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCLoggingHelper.h"
//#import "Flurry.h"
//#import "LocalyticsSession.h"
#import <Crashlytics/Crashlytics.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface BCLoggingHelper()
+(instancetype)sharedInstance;
@end

@implementation BCLoggingHelper

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static BCLoggingHelper *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BCLoggingHelper sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        // Private Inititalisation
    }
    return self;
}

+ (NSString *)getDebugLabel
{
#ifdef DEBUG
    return ([NSString stringWithFormat:@"DEBUG%@", [LoginManager sharedInstance].currentUserID]);
#else
    return ([LoginManager sharedInstance].currentUserID);
#endif
}

+ (void)stopAnalyticsIfRequired
{
//    [self stopLocalytics];
}
+ (void)resumeAnalyticsIfRequired
{
//    [self resumeLocalytics];
}


/*
+ (void)configureFlurryAnalytics
{
#ifdef BC_ANALYTICS
    if (kUseFlurryErrorLogging) {
        [Flurry setCrashReportingEnabled:YES];
    }
    [Flurry startSession:kFlurryAPIKey];
#endif
}

+ (void)startLocalytics
{
#ifdef BC_ANALYTICS
    [[LocalyticsSession shared] startSession:kLocalyticsAPIKey];
#endif
}

+ (void)stopLocalytics
{
#ifdef BC_ANALYTICS
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
#endif
}

+ (void)resumeLocalytics
{
#ifdef BC_ANALYTICS
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
#endif
}

+ (void)configureParse:(NSDictionary *)launchOptions
{
    //#ifdef BC_ANALYTICS
    //    [Parse setApplicationId:kParseAppId clientKey:kParseClientKey];
    //    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //#endif
}
*/

+ (void)configureCrashlytics
{
    if (kUseCrashlyticsLogging) {
        [Crashlytics startWithAPIKey:kCrashlyticsAPIKey];
        [self addCrashlyticsUserIDObserver];
        [[LoginManager sharedInstance] loggedIn];
    }
}

+ (void)addCrashlyticsUserIDObserver
{
    [[LoginManager sharedInstance] addObserver:[BCLoggingHelper sharedInstance] forKeyPath:@"currentUserID" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentUserID"]) {
        [self updateCrashlyticsUserID];
    }
}

- (void)updateCrashlyticsUserID
{
    [Crashlytics setUserIdentifier:[BCLoggingHelper getDebugLabel]];
//    [Crashlytics setUserName:[[NSUserDefaults standardUserDefaults] objectForKey:kINatAuthUsernamePrefKey]];
}

+ (void)configureGoogleAnalytics
{
#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#endif
    
#ifdef BC_ANALYTICS
    if (kUseGoogleErrorLogging) {
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    }
    // Optional: set Google Analytics dispatch interval
    [GAI sharedInstance].dispatchInterval = 60;
    
    // Initialize tracker. Replace with your tracking ID.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleTrackingID];
    [tracker set:kGAIAppVersion value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
#endif
}

+ (void)recordGoogleScreen:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action
{
    [self recordGoogleEvent:category action:action label:nil value:nil];
}

+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action label:(NSString *)label
{
    [self recordGoogleEvent:category action:action label:label value:nil];
}

+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action value:(NSNumber *)value
{
    [self recordGoogleEvent:category action:action label:nil value:value];
}

+ (void)recordGoogleEvent:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
    if (!label) {
        label = [self getDebugLabel];
    }
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:value] build]];
}


+ (void)recordGoogleTiming:(NSString *)category name:(NSString *)name timing:(NSTimeInterval)timing
{
    NSNumber *timeInterval = @((int)(timing * 1000));
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category interval:timeInterval name:name label:[LoginManager sharedInstance].currentUserID] build]];
}



@end