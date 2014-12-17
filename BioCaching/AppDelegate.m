//
//  AppDelegate.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "AppDelegate.h"
#import "BCLoggingHelper.h"
#import "BCDatabaseHelper.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation AppDelegate {
    NSDecimalNumber *lastVersion;
    NSDecimalNumber *currVersion;
    BOOL clearUserDefaults;
    BOOL clearDatabase;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLocalVariables];
    [self clearUserDefaultsIfReq];
    
    [self configureAppearanceSettings];

    [BCLoggingHelper configureDDLogger];
//    [BCLoggingHelper configureFlurryAnalytics];
//    [BCLoggingHelper startLocalytics];
//    [BCLoggingHelper configureParse:launchOptions];
    [BCLoggingHelper configureGoogleAnalytics];
    [self configureRestKitDebugging];
    [self configureRestKit];
    [[LoginManager sharedInstance] configureOAuth2Client];
    [BCLoggingHelper configureCrashlytics];

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [BCLoggingHelper stopAnalyticsIfRequired];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [BCLoggingHelper stopAnalyticsIfRequired];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [BCLoggingHelper resumeAnalyticsIfRequired];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [BCLoggingHelper resumeAnalyticsIfRequired];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [BCLoggingHelper stopAnalyticsIfRequired];
}


#pragma-mark Custom Configuration Methods

- (void)initLocalVariables
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLastVersionPrefKey] isKindOfClass:[NSNumber class]]) {
        lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kLastVersionPrefKey];
    } else {
        lastVersion = [NSDecimalNumber decimalNumberWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kLastVersionPrefKey]];
    }
    
    // CFBundleShortVersionString = "Version" setting in active target Info.plist
    // CFBundleVersion = "Build" setting
    NSString *currentVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if ([[currentVer componentsSeparatedByString:@"."] count] > 2) {
        NSRange releaseVer = [currentVer rangeOfString:@"." options:NSBackwardsSearch];
        if (releaseVer.location != NSNotFound) {
            currentVer = [currentVer stringByReplacingCharactersInRange:releaseVer withString:@""];
        }
    }
    currVersion = [NSDecimalNumber decimalNumberWithString:currentVer];
    
    BOOL newVersion = ([lastVersion compare:currVersion] == NSOrderedAscending);
    BOOL preVersion1 = (!([[NSDecimalNumber one] compare:currVersion] == NSOrderedAscending));
    BOOL preVersion1pt1 = (!([[NSDecimalNumber decimalNumberWithString:@"1.1"] compare:currVersion] == NSOrderedAscending));

    // Default is to clear UserDefaults on version change upto v1.0, and clear Database on version change, up to v1.1
    if (newVersion && preVersion1) {
        clearUserDefaults = YES;
    }
    if (newVersion && preVersion1pt1) {
        clearDatabase = YES;
/*
#if DEBUG
        clearDatabase = NO;
#endif
*/
    }
    
// Override flags during testing
#ifdef kClearUserDefaults
    clearUserDefaults = kClearUserDefaults;
#endif
#ifdef kClearDataStore
    clearDatabase = kClearDataStore;
#endif
    
}

- (void)clearUserDefaultsIfReq
{
    if (clearUserDefaults)
    {
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:currVersion forKey:kLastVersionPrefKey];
}

- (void)configureAppearanceSettings
{
    if IS_IOS_7_OR_LATER {
        [[UINavigationBar appearance] setBarTintColor:[UIColor kColorHeaderBackground]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor kColorHeaderText]}];
        [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    } else {
        [[UINavigationBar appearance] setBackgroundColor:[UIColor kColorHeaderBackground]];
    }
}


- (void)configureRestKitDebugging
{
    RKLogConfigureByName("RestKit", RKLogLevelOff);
    RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
    RKLogConfigureByName("RestKit/Network/Core Data", RKLogLevelOff);
    RKLogConfigureByName("RestKit/Core Data", RKLogLevelOff);
    RKLogConfigureByName("RestKit/Core Data/Cache", RKLogLevelOff);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
}


- (void)configureRestKit
{
    [BCDatabaseHelper initDataStore:clearDatabase];

    // Reset AuthKey
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kINatAuthTokenPrefKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:nil];
    
    // If Previously Logged In to iNat, set Authentication Key in HTTP Client
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:[[NSUserDefaults standardUserDefaults] objectForKey:kINatAuthTokenPrefKey]];
    
    // Create HTTP Client User-Agent and save to UserDefaults
    UIDevice *d = [UIDevice currentDevice];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"BioCaching/%@ (iOS %@ %@ %@)",
                           appVersion,
                           d.systemName,
                           d.systemVersion,
                           d.model];
//    [RKClient.sharedClient setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"User-Agent" value:userAgent];
    NSDictionary *userAgentDict = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userAgentDict];
    
    // Add Entity Mappings
    [INatTrip setupMapping];
    [INatTaxon setupMapping];
    [INatObservation setupMapping];
    [INatObservationPhoto setupMapping];
    
    // Show Network Activity Indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Register Custom JsonParser for RestKit, to modify responses before mapping
    [RKMIMETypeSerialization registerClass:[BCRestKitJsonParser class] forMIMEType:@"application/json"];
}

@end
