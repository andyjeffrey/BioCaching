//
//  TripsDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsDataManager.h"

#import "INatTrip.h"
#import "INatTripTaxaAttribute.h"
#import "INatTripTaxaPurpose.h"

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
        managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
        
        // Load Trips From Local Storage
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
        request.entity = entity;
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"localCreatedAt" ascending:NO];
        request.sortDescriptors = @[sortDesc];
        
        NSError *error;
        NSArray *resultsArray = [managedObjectContext executeFetchRequest:request error:&error];
        if (!resultsArray) {
            NSLog(@"Fetch Failed: %@", error);
        } else {
            _privateTrips = [[NSMutableArray alloc] initWithArray:resultsArray];
        }
        
        NSPredicate *predicate;
        
        predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusCreated];
        self.savedTrips = [[NSMutableArray alloc] initWithArray:
                           [[resultsArray filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDesc]]];

        predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusInProgress];
        self.inProgressTrips = [[NSMutableArray alloc] initWithArray:
                                [[resultsArray filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDesc]]];
        
        predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusFinished];
        self.finishedTrips = [[NSMutableArray alloc] initWithArray:
                              [[resultsArray filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDesc]]];
        
        predicate = [NSPredicate predicateWithFormat:@"status = %d", TripStatusPublished];
        self.publishedTrips = [[NSMutableArray alloc] initWithArray:
                               [[resultsArray filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sortDesc]]];
        
    }
    return self;
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

- (void)loadAllTripsFromINat:(NSDictionary *)parameters success:(void (^)(NSArray *trips))success;
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
                [self.publishedTrips addObject:trip];
            }
        }
        success(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Trips: %@", error);
    }];
}

- (INatTrip *)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus
{
    NSError *error = nil;
    
    INatTrip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
    
    NSMutableArray *tripAttributes = [[NSMutableArray alloc] init];
    NSMutableArray *tripPurposes = [[NSMutableArray alloc] init];

//    int arrayIndex = 0;
    for (GBIFOccurrence *occurrence in [occurrenceResults getFilteredResults:YES]) {
        if (occurrence.iNatTaxon) {
            INatTripTaxaAttribute *taxaAttribute = [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxaAttribute" inManagedObjectContext:managedObjectContext];
//            taxaAttribute.indexID = [NSNumber numberWithInt:arrayIndex];
            taxaAttribute.taxonId = occurrence.iNatTaxon.id;
            taxaAttribute.observed = NO;
            [tripAttributes addObject:taxaAttribute];
            
            INatTripTaxaPurpose *taxaPurpose = [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxaPurpose" inManagedObjectContext:managedObjectContext];
            taxaPurpose.resourceType = @"Taxon";
            taxaPurpose.resourceId = occurrence.iNatTaxon.id;
            taxaPurpose.complete = NO;
            [tripPurposes addObject:taxaPurpose];
        } else {
            [occurrenceResults.Results removeObject:occurrence];
            NSLog(@"No iNatTaxon found for %@, occurrence removed from Trip", occurrence.speciesBinomial);
        }
        
//        arrayIndex++;
    }
    
    trip.taxaAttributes = [NSSet setWithArray:tripAttributes];
    trip.taxaPurposes = [NSSet setWithArray:tripPurposes];
    
    trip.status = [NSNumber numberWithInteger:tripStatus];
    
    trip.title = [NSString stringWithFormat:@"Test Trip %ld - %.3f,%.3f", _privateTrips.count + 1, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.localCreatedAt = [NSDate date];
    trip.latitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.latitude];
    trip.longitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.body = @"This is test Trip created from BioCaching mobile app";
    
    if (tripStatus == TripStatusCreated) {
        [[TripsDataManager sharedInstance].savedTrips addObject:trip];
    } else if (tripStatus == TripStatusInProgress) {
        [[TripsDataManager sharedInstance].inProgressTrips addObject:trip];
    }
    
    if (![managedObjectContext saveToPersistentStore:&error]) {
        RKLogError(@"Error Saving New Entities To Store: %@", error);
    }
    
    self.currentTrip = trip;
    return trip;
}

- (void)saveChanges
{
    NSError *error = nil;
    
    if (managedObjectContext.hasChanges) {
        if (![managedObjectContext saveToPersistentStore:&error]) {
            RKLogError(@"Error Saving New Entities To Store: %@", error);
        }
    }
}

- (void)saveTripToINat:(INatTrip *)trip
{
    NSDictionary *queryParams = @{@"publish" : @"Publish"};
    
    [[RKObjectManager sharedManager] postObject:trip path:kINatTripsPathPattern parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"save Success: %@", mappingResult);
        trip.status = [NSNumber numberWithInt:TripStatusPublished];
        [self.finishedTrips removeObject:trip];
        [self.publishedTrips addObject:trip];
        [self saveChanges];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Published To iNat", nil)
                                                     message:NSLocalizedString(@"Explanatory Message About How To Edit/Delete Trip Through iNat Website \n\n n.b. Refresh screen to update table (will be automated)", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
        [av show];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"saveTrip Error: %@", error);
    }];
}


- (void)deleteTripFromINat:(INatTrip *)trip
{
    [[RKObjectManager sharedManager] deleteObject:trip path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"delete Success: %@", mappingResult);
        [self.publishedTrips removeObject:trip];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Deleted From iNat", nil)
                                                     message:NSLocalizedString(@"Refresh screen to update table\n (will be automated)", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
        [av show];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"saveTrip Error: %@", error);
    }];
}




@end
