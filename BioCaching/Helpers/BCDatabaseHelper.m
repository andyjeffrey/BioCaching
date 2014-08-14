//
//  BCDatabaseHelper.m
//  BioCaching
//
//  Created by Andy Jeffrey on 13/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCDatabaseHelper.h"

@implementation BCDatabaseHelper

+ (NSManagedObjectContext *)sharedMOC {
        return [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
}

+ (void)clearDownDatabase
{
    NSError *error = nil;
    
//    NSString *dataStorePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"BioCaching.sqlite"];

    [[self sharedMOC] reset];
/*
    [[NSFileManager defaultManager] removeItemAtPath:dataStorePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@-shm", dataStorePath] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@-wal", dataStorePath] error:nil];
*/
    if (![[[RKObjectManager sharedManager] managedObjectStore] resetPersistentStores:&error]) {
        RKLogError(@"Error Resetting Database: %@", error);
    }
}

+ (NSUInteger)rowCountForEntity:(NSString *)entityName
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSUInteger count = [[self sharedMOC] countForFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error Performing Database Request:%@", error);
    }
    return count;
}

@end
