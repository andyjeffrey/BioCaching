//
//  TripsDataManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripsDataManagerDelegate.h"
#import "ImageManager.h"
#import "GBIFOccurrenceResults.h"
#import "BCOptions.h"

@interface TripsDataManager : NSObject<ImageManagerDelegate>

@property (weak, nonatomic) id<TripsDataManagerDelegate> delegate;
@property (weak, nonatomic) id<TripsDataManagerExploreDelegate> exploreDelegate;

// Conveniece properties for TripsVC table sections
// TODO: Replace with FetchedResultsController?
@property (nonatomic, readonly, strong) NSArray *createdTrips;
@property (nonatomic, readonly, strong) NSArray *savedTrips;
@property (nonatomic, readonly, strong) NSArray *inProgressTrips;
@property (nonatomic, readonly, strong) NSArray *finishedTrips;
@property (nonatomic, readonly, strong) NSArray *publishedTrips;

@property (nonatomic, strong) INatTrip *currentTrip;
@property (nonatomic, readonly, strong) NSArray *uploadQueue;

+ (instancetype)sharedInstance;

- (BOOL)saveChanges;
- (void)rollbackChanges;

- (INatTrip *)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus;
- (INatTrip *)createNewTrip:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions;
- (NSString *)getDefaultNewTripName:(BCOptions *)bcOptions;

- (void)loadTripsFromINat:(NSString *)iNatUsername;
- (void)loadAllTripsFromINat;

- (void)addTripToUploadQueue:(INatTrip *)trip;
- (void)initiateUploads;
- (void)saveTripToINat:(INatTrip *)trip;

- (void)deleteTripFromINat:(INatTrip *)trip;

- (void)loadTripsFromLocalStore;
- (void)deleteTripFromLocalStore:(INatTrip *)trip;
- (void)discardCurrentTrip;

- (void)addNewTaxaAttributeFromOccurrence:(OccurrenceRecord *)occurrenceRecord;

- (void)removeOccurrenceFromTrip:(INatTrip *)trip occurrence:(OccurrenceRecord *)occurrenceRecord;

- (void)addObservationToTripOccurrence:(INatObservation *)observation occurrence:(OccurrenceRecord *)occurrence;
- (void)removeObservationFromTripOccurrence:(INatObservation *)observation occurrence:(OccurrenceRecord *)occurrence;
- (void)addNewPhotoToTripObservation:(NSString *)localAssetUrlString observation:(INatObservation *)observation;

- (void)addLocationToCurrentTripTrack:(CLLocation *)location;

@end
