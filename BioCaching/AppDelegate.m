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

#import "INatTrip.h"
#import "INatTripTaxaAttribute.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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

- (void)configureDebugging
{
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network/Core Data", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/Core Data", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Core Data/Cache", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
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

    
/*
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"errorMessage"]];
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:@"error" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [objectManager addResponseDescriptorsFromArray:@[errorDescriptor]];
*/
    
    NSDictionary *parentObjectMapping = @{
                                          @"id" : @"objectId",
                                          @"created_at" : @"createdAt",
                                          @"updated_at" : @"updatedAt",
                                          };


    NSDictionary *iNatTripObjectMapping = @{
                                            @"title" : @"title",
                                            @"body" : @"body",
                                            @"latitude" : @"latitude",
                                            @"longitude" : @"longitude",
                                            @"positional_accuracy" : @"positionalAccuracy",
                                            @"place_id" : @"placeId",
                                            @"user_id" : @"userId"
                                            };
                                            
    // Trip Entity Mapping
    RKEntityMapping *entityMappingTrip = [RKEntityMapping mappingForEntityForName:@"INatTrip" inManagedObjectStore:managedObjectStore];
    [entityMappingTrip addAttributeMappingsFromDictionary:parentObjectMapping];
    [entityMappingTrip addAttributeMappingsFromDictionary:iNatTripObjectMapping];
    entityMappingTrip.identificationAttributes = @[@"objectId"];

    
    // Trip Entity POST Mapping
    RKEntityMapping *postMappingTrip = [RKEntityMapping mappingForEntityForName:@"INatTrip" inManagedObjectStore:managedObjectStore];
    [postMappingTrip addAttributeMappingsFromDictionary:iNatTripObjectMapping];
    
/*
    // Mappings for Trip Taxa Collections
    NSDictionary *iNatTripTaxaAttObjectMapping = @{
                                                   @"index_id" : @"objectId",
                                                   @"taxon_id" : @"taxonId",
                                                   @"observed" : @"observed"
                                                   };
    
    RKEntityMapping *entityMappingTaxaAtt = [RKEntityMapping mappingForEntityForName:@"INatTripTaxaAttribute" inManagedObjectStore:managedObjectStore];
//    [entityMappingTaxaAtt addAttributeMappingsFromDictionary:parentObjectMapping];
    [entityMappingTaxaAtt addAttributeMappingsFromDictionary:iNatTripTaxaAttObjectMapping];
    entityMappingTaxaAtt.identificationAttributes = @[@"objectId"];
    
    [postMappingTrip addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"trip_taxa_attributes" toKeyPath:@"taxaAttributes" withMapping:entityMappingTaxaAtt]];
*/
    
    // Trip Collection GET Response
    RKResponseDescriptor *respDescTripsCollection = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodGET pathPattern:kINatTripsPathPattern keyPath:kINatTripsKeyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTripsCollection];
    
    // Trip Entity GET Response
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[INatTrip class] pathPattern:@"trips/:objectId" method:RKRequestMethodAny]];
    RKResponseDescriptor *respDescTrip = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodAny pathPattern:@"trips/:objectId" keyPath:@"trip" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTrip];
    
    // Trip Entity POST Request
    RKRequestDescriptor *reqDescTripPost = [RKRequestDescriptor requestDescriptorWithMapping:[postMappingTrip inverseMapping] objectClass:[INatTrip class] rootKeyPath:@"trip" method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:reqDescTripPost];

    // Trip Entity POST Response
    RKResponseDescriptor *respDescTripsPost = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodAny pathPattern:kINatTripsPathPattern keyPath:@"trip" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTripsPost];
    


    // TripAttributes Collection GET Response
//    RKResponseDescriptor *responseDescriptorTripAttributes = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTaxaAtt method:RKRequestMethodGET pathPattern:@"trips/:objectId" keyPath:@"trip/trip_taxa" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    [objectManager addResponseDescriptor:responseDescriptorTripAttributes];
    
//    [entityMappingTrip addRelationshipMappingWithSourceKeyPath:@"trip/trip_taxa" mapping:entityMappingTaxaAtt];

//    [entityMappingTrip addConnectionForRelationship:@"taxaAttributes" connectedBy:@{ @"trip_taxa/id" : @""}];
    
//    RKRelationshipMapping *relMappingTaxaAtt = [RKRelationshipMapping relationshipMappingFromKeyPath:@"trip_taxa" toKeyPath:@"taxaAttributes" withMapping:entityMappingTaxaAtt];
//    [entityMappingTrip addPropertyMapping:relMappingTaxaAtt];
//    [entityMappingTrip addRelationshipMappingWithSourceKeyPath:@"trip_taxa" mapping:entityMappingTaxaAtt];
    
    
    
}

@end
