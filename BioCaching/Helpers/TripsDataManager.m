//
//  TripsDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsDataManager.h"

static NSSortDescriptor *defaultSortDesc;

@implementation TripsDataManager {
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *_privateTrips;
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
    defaultSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"localCreatedAt" ascending:NO];

    self = [super init];
    if (self) {
        managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
        [self loadTripsFromLocalStore];
    }
    
    return self;
}

- (NSArray *)createdTrips {
    [self loadTripsFromLocalStore];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusCreated];
    return [[NSArray alloc] initWithArray:
                         [[_privateTrips filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[defaultSortDesc]]];
}

- (NSArray *)savedTrips {
    [self loadTripsFromLocalStore];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusSaved];
    return [[NSArray alloc] initWithArray:
            [[_privateTrips filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[defaultSortDesc]]];
}

- (NSArray *)inProgressTrips {
    [self loadTripsFromLocalStore];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusInProgress];
    return [[NSArray alloc] initWithArray:
            [[_privateTrips filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[defaultSortDesc]]];
}

- (NSArray *)finishedTrips {
    [self loadTripsFromLocalStore];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusFinished];
    return [[NSArray alloc] initWithArray:
            [[_privateTrips filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[defaultSortDesc]]];
}

- (NSArray *)publishedTrips {
    [self loadTripsFromLocalStore];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusPublished];
    return [[NSArray alloc] initWithArray:
            [[_privateTrips filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[defaultSortDesc]]];
}


/*
 - (NSArray *)fetchSelectedTripsFromLocalStorage:(NSString *)filter {
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 NSEntityDescription *entity = [NSEntityDescription entityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
 request.entity = entity;
 NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"localCreatedAt" ascending:NO];
 request.sortDescriptors = @[sortDesc];
 NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
 [request setPredicate:predicate];
 
 NSError *error;
 NSArray *resultsArray = [managedObjectContext executeFetchRequest:request error:&error];
 if (!resultsArray) {
 NSLog(@"Fetch Failed: %@", error);
 }
 
 self.savedTrips = [[NSMutableArray alloc] initWithArray:resultsArray];
 
 return nil;
 }
 */

- (void)loadAllTripsFromINat
{
    [[RKObjectManager sharedManager] getObjectsAtPath:kINatTripsPathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        for (INatTrip *trip in mappingResult.array) {
            
            trip.status = [NSNumber numberWithInteger:TripStatusPublished];
            
            // Update Trip Status On Local Storage
            NSError *error = nil;
            if (![managedObjectContext saveToPersistentStore:&error]) {
                RKLogError(@"Error Saving New Entities To Store: %@", error);
            }
            
            // TODO: Check if trip already exists before adding
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId = %@", trip.recordId];
            NSArray *existingTrip = [self.publishedTrips filteredArrayUsingPredicate:predicate];
            if (!existingTrip.count) {
                [_privateTrips addObject:trip];
            }
        }
        [self.tableDelegate tripsTableUpdated];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Trips: %@", error);
    }];
}

- (void)loadTripsFromINat:(NSDictionary *)parameters success:(void (^)(NSArray *trips))success;
{
    [[RKObjectManager sharedManager] getObjectsAtPath:kINatTripsPathPattern parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        for (INatTrip *trip in mappingResult.array) {
            
            trip.status = [NSNumber numberWithInteger:TripStatusPublished];
            
            // Update Trip Status On Local Storage
            NSError *error = nil;
            if (![managedObjectContext saveToPersistentStore:&error]) {
                RKLogError(@"Error Saving New Entities To Store: %@", error);
            }
            
            // TODO: Check if trip already exists before adding
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordId = %@", trip.recordId];
            NSArray *existingTrip = [self.publishedTrips filteredArrayUsingPredicate:predicate];
            if (!existingTrip.count) {
                [_privateTrips addObject:trip];
            }
        }
        [self.tableDelegate tripsTableUpdated];
        success(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Trips: %@", error);
    }];
}

- (void)loadTripsFromLocalStore
{
    // Load Trips From Local Storage
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
    request.entity = entity;
    request.sortDescriptors = @[defaultSortDesc];
    
    NSError *error;
    NSArray *resultsArray = [managedObjectContext executeFetchRequest:request error:&error];
    if (!resultsArray) {
        NSLog(@"Fetch Failed: %@", error);
    } else {
        _privateTrips = [[NSMutableArray alloc] initWithArray:resultsArray];
    }
}

- (NSString *)getDefaultNewTripName:(BCOptions *)bcOptions
{
    return [NSString stringWithFormat:@"Test Trip %d - %.3f,%.3f", (int)_privateTrips.count + 1, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
}

- (INatTrip *)createNewTrip:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions
{
    INatTrip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
    
    trip.status = [NSNumber numberWithInteger:TripStatusCreated];
//    trip.title = [NSString stringWithFormat:@"Test Trip %d - %.3f,%.3f", (int)_privateTrips.count + 1, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.title = [NSString stringWithFormat:@"Trip %d - %@", (int)_privateTrips.count + 1, bcOptions.searchOptions.searchLocationName];
    trip.localCreatedAt = [NSDate date];
    trip.latitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.latitude];
    trip.longitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.searchAreaSpan = [NSNumber numberWithInteger:bcOptions.searchOptions.searchAreaSpan];
    trip.body = @"This is test Trip created from BioCaching mobile app";
    
    if (![self saveChanges]) {
        return nil;
    }
    
    [_privateTrips addObject:trip];
    trip.removedRecords = [[NSMutableArray alloc] init];

    self.currentTrip = trip;
    return trip;
}

- (INatTrip *)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus
{
    NSError *error = nil;
    
    INatTrip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
    
    //    int arrayIndex = 0;
    for (GBIFOccurrence *occurrence in [occurrenceResults getFilteredResults:YES]) {
        if (occurrence.iNatTaxon) {
            [trip.taxaAttributesSet addObject:[INatTripTaxaAttribute createFromINatTaxon:occurrence.iNatTaxon]];
            [trip.taxaPurposesSet addObject:[INatTripTaxaPurpose createFromINatTaxon:occurrence.iNatTaxon]];
        } else {
            [occurrenceResults.Results removeObject:occurrence];
            NSLog(@"No iNatTaxon found for %@, occurrence removed from Trip", occurrence.speciesBinomial);
        }
        
        //        arrayIndex++;
    }
    
    trip.status = [NSNumber numberWithInteger:tripStatus];
    
    trip.title = [NSString stringWithFormat:@"Test Trip %d - %.3f,%.3f", (int)_privateTrips.count + 1, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.localCreatedAt = [NSDate date];
    trip.latitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.latitude];
    trip.longitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.body = @"This is test Trip created from BioCaching mobile app";
    
    if (![managedObjectContext saveToPersistentStore:&error]) {
        RKLogError(@"Error Saving New Entities To Store: %@", error);
    } else {
        [_privateTrips addObject:trip];
    }
    
    self.currentTrip = trip;
    
    return trip;
}

- (BOOL)saveChanges
{
    NSError *error = nil;
    if (managedObjectContext.hasChanges) {
//        if (![managedObjectContext save:&error]) {
        if (![managedObjectContext saveToPersistentStore:&error]) {
            RKLogError(@"Error Saving Updates To Store: %@", error);
            return FALSE;
        }
    }
    return TRUE;
}

- (void)saveTripToINat:(INatTrip *)trip
{
    // TODO: Upload ObservationPhotos

    // Upload Observations
    for (INatObservation *observation in trip.observations) {
        NSLog(@"Uploading Observation: %@", observation.iNatTaxon.name);
        [[RKObjectManager sharedManager] postObject:observation path:@"observations" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"Observation Upload Success: %@", mappingResult);
            // TODO: Update local INatObservation object
            // TODO: Add Delegate To Send Progress Updates Back to VC
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            // TODO: Update local INatObservation object
            NSLog(@"Observation Upload Error: %@", error);
        }];
    }

    // Upload Trip
    NSDictionary *queryParams = @{@"publish" : @"Publish"};
    [[RKObjectManager sharedManager] postObject:trip path:kINatTripsPathPattern parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"save Success: %@", mappingResult);
        trip.status = [NSNumber numberWithInt:TripStatusPublished];
        [self saveChanges];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Published To iNat", nil)
                                                     message:NSLocalizedString(@"Explanatory Message About How To Edit/Delete Trip Through iNat Website", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
        [av show];
        [self.tableDelegate tripsTableUpdated];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"saveTrip Error: %@", error);
    }];
}


- (void)deleteTripFromINat:(INatTrip *)trip
{
    [[RKObjectManager sharedManager] deleteObject:trip path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"delete Success: %@", mappingResult);
        [_privateTrips removeObject:trip];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Deleted From iNat", nil)
                                                     message:NSLocalizedString(@"Refresh screen to update table\n (will be automated)", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
        [av show];
        [self.tableDelegate tripsTableUpdated];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"deleteTrip Error: %@", error);
    }];
}

- (void)discardCurrentTrip
{
    [self deleteTripFromLocalStore:_currentTrip];
    _currentTrip = nil;
}

- (void)deleteTripFromLocalStore:(INatTrip *)trip
{
    if (trip.managedObjectContext) {
        [managedObjectContext deleteObject:trip];
    } else {
        NSString *reasonString = [NSString stringWithFormat:@"Attempting to delete Trip MO that does not exist:%@", trip];
        @throw [NSException exceptionWithName:@"TripsDataManager"
                                       reason:reasonString
                                     userInfo:nil];
    }
    
    if ([self saveChanges]) {
        [_privateTrips removeObject:trip];
    }
    if(_currentTrip == trip) {
        _currentTrip = nil;
    }
    [self.tableDelegate tripsTableUpdated];
}

- (void)removeOccurrenceFromTrip:(INatTrip *)trip occurrence:(OccurrenceRecord *)occurrence
{
    //TODO: Should check Trip contains OccurrenceRecord to be deleted?
    if (occurrence.managedObjectContext) {
        [managedObjectContext deleteObject:occurrence];
    } else {
        NSString *reasonString = [NSString stringWithFormat:@"Attempting to delete OccurrenceRecord MO that does not exist:%@", occurrence];
        @throw [NSException exceptionWithName:@"TripsDataManager"
                                       reason:reasonString
                                     userInfo:nil];
    }
    
    if ([self saveChanges]) {
        [trip.removedRecords addObject:occurrence];
        [self.delegate occurrenceRemovedFromTrip:occurrence];
    }
}

- (void)addNewTaxaAttributeFromOccurrence:(OccurrenceRecord *)occurrenceRecord
{
    INatTripTaxaAttribute *taxaAttribute = [INatTripTaxaAttribute createFromINatTaxon:occurrenceRecord.iNatTaxon];
    taxaAttribute.occurrence = occurrenceRecord;
    
    [self.currentTrip.taxaAttributesSet addObject:taxaAttribute];
    [self saveChanges];

    [self.delegate occurrenceAddedToTrip:occurrenceRecord];
}

- (void)addObservationToTripOccurrence:(INatObservation *)observation occurrence:(OccurrenceRecord *)occurrence trip:(INatTrip *)trip
{
    occurrence.taxaAttribute.observation = observation;
    occurrence.taxaAttribute.observedValue = YES;
    [self saveChanges];
}

@end
