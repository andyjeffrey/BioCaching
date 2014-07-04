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
#import "TripsDataManagerDelegate.h"
#import "GBIFOccurrenceResults.h"
#import "BCOptions.h"

@interface TripsDataManager : NSObject

@property (weak, nonatomic) id<TripsDataManagerDelegate> delegate;
@property (weak, nonatomic) id<TripsDataManagerTableDelegate> tableDelegate;

@property (nonatomic, readonly, strong) NSArray *createdTrips;
@property (nonatomic, readonly, strong) NSArray *savedTrips;
@property (nonatomic, readonly, strong) NSArray *inProgressTrips;
@property (nonatomic, readonly, strong) NSArray *finishedTrips;
@property (nonatomic, readonly, strong) NSArray *publishedTrips;

@property (nonatomic, strong) INatTrip *currentTrip;

+ (instancetype)sharedInstance;

- (void)saveChanges;

- (INatTrip *)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus;
- (INatTrip *)createNewTrip:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions;
- (NSString *)getDefaultNewTripName:(BCOptions *)bcOptions;

- (void)loadTripsFromINat:(NSDictionary *)parameters success:(void (^)(NSArray *trips))success;
- (void)saveTripToINat:(INatTrip *)trip;
- (void)deleteTripFromINat:(INatTrip *)trip;

- (void)loadTripsFromLocalStore;
- (void)discardCurrentTrip;
- (void)removeOccurrenceFromTrip:(INatTrip *)trip occurrence:(OccurrenceRecord *)occurrenceRecord;

- (void)addObservationToTripOccurrence:(INatObservation *)observation occurrence:(OccurrenceRecord *)occurrence;

@end
