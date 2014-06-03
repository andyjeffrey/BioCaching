//
//  TripsDataManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

// Temporary Data Manager Class
// TODO: Replace with CoreData/RestKit Managed Objects

#import <Foundation/Foundation.h>
#import "GBIFOccurrenceResults.h"
#import "BCOptions.h"
#import "INatTrip.h"

@interface TripsDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *savedTrips;
@property (nonatomic, strong) NSMutableArray *inProgressTrips;
@property (nonatomic, strong) NSMutableArray *finishedTrips;
@property (nonatomic, strong) NSMutableArray *publishedTrips;

+ (instancetype)sharedInstance;

- (void)saveChanges;
- (INatTrip *)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus;

- (void)loadAllTripsFromINat:(NSDictionary *)parameters success:(void (^)(NSArray *trips))success;
- (void)saveTripToINat:(INatTrip *)trip;
- (void)deleteTripFromINat:(INatTrip *)trip;

@end
