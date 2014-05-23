//
//  TripsDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsDataManager.h"
#import "INatTrip.h"

@interface TripsDataManager ()

@property (nonatomic) NSMutableArray *privateTrips;

@end

@implementation TripsDataManager {
    NSManagedObjectContext *managedObjectContext;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static TripsDataManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[TripsDataManager sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.createdTrips = [[NSMutableArray alloc] init];
        self.inProgressTrips = [[NSMutableArray alloc] init];
        self.completedTrips = [[NSMutableArray alloc] init];
        
        managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    }
    return self;
}

- (INatTrip *)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus
{
//    INatTrip *trip = [[INatTrip alloc] init];
    INatTrip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
    
    NSInteger tripCounter = 0;
    if (tripStatus == TripStatusCreated) {
        tripCounter = [TripsDataManager sharedInstance].createdTrips.count + 1;
    } else if (tripStatus == TripStatusInProgress) {
        tripCounter = [TripsDataManager sharedInstance].inProgressTrips.count + 1;
    }
    
    trip.title = [NSString stringWithFormat:@"Test Trip %ld - %.3f,%.3f", (long)tripCounter, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.createdAt = [NSDate date];
    
    if (tripStatus == TripStatusCreated) {
        [[TripsDataManager sharedInstance].createdTrips addObject:trip];
    } else if (tripStatus == TripStatusInProgress) {
        [[TripsDataManager sharedInstance].inProgressTrips addObject:trip];
    }
    
    return trip;
}

- (void)loadAllTrips:(NSDictionary *)parameters success:(void (^)(NSArray *trips))success;
{
    [[RKObjectManager sharedManager] getObjectsAtPath:kINatTripsPathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        for (INatTrip *trip in mappingResult.array) {
            trip.status = [NSNumber numberWithInteger:TripStatusCompleted];
            [self.completedTrips addObject:trip];
            
            NSLog(@"loading TripDetails for TripId : %@", trip.objectId);
/*
            [[RKObjectManager sharedManager] getObject:trip path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                NSLog(@"Loading mapping result: %@", mappingResult);
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(@"Error mapping result: %@", error);
            }];
*/
        }
        success(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Trips: %@", error);
    }];
    
/*
    [[RKObjectManager sharedManager] getObjectsAtPath:kINatTripsPathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Success: %@", mappingResult);
        _trips = mappingResult.array;
        [self.tableTrips reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Trips: %@", error);
    }];
*/
}

- (void)saveTrip:(INatTrip *)trip
{
    NSDictionary *queryParams = @{@"publish" : @"Publish"};
    
    [[RKObjectManager sharedManager] postObject:trip path:kINatTripsPathPattern parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"saveTrip Success: %@", mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"saveTrip Error: %@", error);
    }];
}

@end
