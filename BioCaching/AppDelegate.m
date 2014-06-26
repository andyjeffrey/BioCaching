//
//  AppDelegate.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"
#import "LocalyticsSession.h"
#import "LoginManager.h"

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

    [self configureDebugging];
    [self configureFlurryAnalytics];
    [self startLocalytics];
    [self configureRestKit];
    [[LoginManager sharedInstance] configureOAuth2Client];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [self stopLocalytics];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self stopLocalytics];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self resumeLocalytics];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self resumeLocalytics];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self stopLocalytics];
}


#pragma-mark Custom Configuration Methods

- (void)initLocalVariables
{
    lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kLastVersionPrefKey];

    // CFBundleShortVersionString = "Version" setting in active target Info.plist
    // CFBundleVersion = "Build" setting
    currVersion = [NSDecimalNumber decimalNumberWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    // Default is to completely clear UserDefaults and Database on version change, up to v1.0
    BOOL newVersion = ([lastVersion compare:currVersion] == NSOrderedAscending);
    BOOL preVersion1 = (!([[NSDecimalNumber one] compare:currVersion] == NSOrderedAscending));

    //    if ([currVersion <= 1.0) && (lastVersion  < currVersion ))
    if (newVersion && preVersion1)
    {
        clearUserDefaults = YES;
        clearDatabase = YES;
    }
    
// Force clearing during testing
#ifdef DEBUG
//    clearUserDefaults = YES;
//    clearDatabase = YES;
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

- (void)configureDebugging
{
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network/Core Data", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Core Data", RKLogLevelInfo);
//    RKLogConfigureByName("RestKit/Core Data/Cache", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelInfo);
}

- (void)configureFlurryAnalytics
{
#ifdef BIOC_ANALYTICS
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:kFlurryAPIKey];
#endif
}

- (void)startLocalytics
{
#ifdef BIOC_ANALYTICS
    [[LocalyticsSession shared] startSession:kLocalyticsAPIKey];
#endif
}

- (void)stopLocalytics
{
#ifdef BIOC_ANALYTICS
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
#endif
}

- (void)resumeLocalytics
{
#ifdef BIOC_ANALYTICS
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
#endif
}

- (void)configureRestKit
{
    NSError *error = nil;

    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kINatBaseURL]];
//    objectManager.requestSerializationMIMEType=RKMIMETypeJSON;

    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BioCaching" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Create In-Memory Date Store
//    [managedObjectStore createPersistentStoreCoordinator];
//    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
//    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    // Create On-disk SQLite Data Store
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (!success) {
        RKLogError(@"Failed To Create Application Data Directory At Path: %@ : %@", RKApplicationDataDirectory(), error);
    }
    NSString *dataStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"BioCaching.sqlite"];
#ifdef DEBUG
    NSLog(@"Data Store Path: %@", dataStorePath);
#endif
    
    //Completely Remove Old Data Store Files If Required (during testing)
    if (clearDatabase)
    {
        [[NSFileManager defaultManager] removeItemAtPath:dataStorePath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@-shm", dataStorePath] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@-wal", dataStorePath] error:nil];
    }
    
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:dataStorePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (!persistentStore) {
        RKLogError(@"Failed To Add Persistent Store At Path: %@ : %@", dataStorePath, error);
    }
    
    [managedObjectStore createManagedObjectContexts];
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    objectManager.managedObjectStore = managedObjectStore;
    [RKObjectManager setSharedManager:objectManager];
    
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
    
}

@end
