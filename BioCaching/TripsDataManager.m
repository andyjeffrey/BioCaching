//
//  TripsDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsDataManager.h"
#import "INatTripPreCD.h"

@implementation TripsDataManager

+(TripsDataManager *)sharedInstance {
    static dispatch_once_t once;
    static TripsDataManager *instance;
    dispatch_once(&once, ^{
        instance = [[TripsDataManager alloc] init];
        instance.createdTrips = [[NSMutableArray alloc] init];
        instance.inProgressTrips = [[NSMutableArray alloc] init];
    });
    return instance;
}

- (void)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus
{
//    NSArray *filteredResults = [occurrenceResults getFilteredResults:bcOptions.displayOptions limitToMapPoints:YES];
    INatTripPreCD *trip = [[INatTripPreCD alloc] init];
    NSInteger tripCounter = 0;
    if (tripStatus == TripStatusCreated) {
        tripCounter = [TripsDataManager sharedInstance].createdTrips.count + 1;
    } else if (tripStatus == TripStatusInProgress) {
        tripCounter = [TripsDataManager sharedInstance].inProgressTrips.count + 1;
    }
    
    trip.title = [NSString stringWithFormat:@"Test Trip %ld - %.3f,%.3f", (long)tripCounter, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.created_at = [NSString stringWithFormat:@"%@", [NSDate date]];
    
    if (tripStatus == TripStatusCreated) {
        [[TripsDataManager sharedInstance].createdTrips addObject:trip];
    } else if (tripStatus == TripStatusInProgress) {
        [[TripsDataManager sharedInstance].inProgressTrips addObject:trip];
    }
}

@end
