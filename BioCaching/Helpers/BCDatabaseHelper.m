//
//  BCDatabaseHelper.m
//  BioCaching
//
//  Created by Andy Jeffrey on 13/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCDatabaseHelper.h"
#import "BCLoggingHelper.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation BCDatabaseHelper

static NSManagedObjectModel *managedObjectModel;
static RKManagedObjectStore *managedObjectStore;
static RKObjectManager *objectManager;
static NSString *dataStorePath;

+ (void)initialize
{
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BioCaching" ofType:@"momd"]];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kINatBaseURL]];
    //    objectManager.requestSerializationMIMEType=RKMIMETypeJSON;
}

+ (void)initDataStore:(BOOL)resetDatabase
{
    NSError *error = nil;

    // Create In-Memory Date Store
    //    [managedObjectStore createPersistentStoreCoordinator];
    //    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    //    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    // Create On-disk SQLite Data Store
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (!success) {
        RKLogError(@"Failed To Create Application Data Directory At Path: %@ : %@", RKApplicationDataDirectory(), error);
    }
    dataStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"BioCaching.sqlite"];
    DDLogInfo(@"Data Store Path: %@", dataStorePath);
    
    if (resetDatabase) {
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
}

+ (void)clearDataStore
{
    NSError *error = nil;
    
    [managedObjectStore.mainQueueManagedObjectContext reset];

//    [[NSFileManager defaultManager] removeItemAtPath:dataStorePath error:nil];
//    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@-shm", dataStorePath] error:nil];
//    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@-wal", dataStorePath] error:nil];

    if (![managedObjectStore resetPersistentStores:&error]) {
        RKLogError(@"Error Resetting Database: %@", error);
    }
}

+ (NSUInteger)rowCountForEntity:(NSString *)entityName
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSUInteger count = [managedObjectStore.mainQueueManagedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error Performing Database Request:%@", error);
    }
    return count;
}

@end
