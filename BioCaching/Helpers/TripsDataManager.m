//
//  TripsDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsDataManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

static NSSortDescriptor *defaultSortDesc;

@implementation TripsDataManager {
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *_privateTrips;
    NSMutableArray *_uploadQueue;
    NSMutableArray *_observationsQueue;
    NSMutableArray *_observationPhotosQueue;
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
        _uploadQueue = [[NSMutableArray alloc] init];
//        [self refreshUploadQueue];
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

- (NSArray *)uploadQueue {
    return _uploadQueue;
}


- (void)loadAllTripsFromINat
{
    [self loadTripsFromINat:nil];
}

- (void)loadTripsFromINat:(NSString *)iNatUsername
{
    NSString *requestPath = [NSString stringWithFormat:@"%@", kINatTripsPathPattern];
    if (iNatUsername) {
        requestPath = [NSString stringWithFormat:@"%@/%@", requestPath, iNatUsername];
    }
    [[RKObjectManager sharedManager] getObjectsAtPath:requestPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
        [self.delegate tripsDataTableUpdated];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Error Loading Trips: %@", error);
    }];
}

- (void)loadTripsFromLocalStore
{
    NSArray *tripsArray = [BCManagedObject fetchSelectedEntities:@"INatTrip" filter:nil];
    if (tripsArray) {
        _privateTrips = [[NSMutableArray alloc] initWithArray:tripsArray];
    }
}

- (void)refreshUploadQueue
{
    for (INatTrip* iNatTrip in _privateTrips) {
        if ((iNatTrip.status.intValue >= TripStatusFinished) && iNatTrip.needsSyncing) {
            [_uploadQueue addObject:iNatTrip];
        }
    }
}

- (NSString *)getDefaultNewTripName:(BCOptions *)bcOptions
{
    return [NSString stringWithFormat:@"Test Trip %d - %.3f,%.3f", (int)_privateTrips.count + 1, bcOptions.searchOptions.searchAreaCentre.latitude, bcOptions.searchOptions.searchAreaCentre.longitude];
}

- (INatTrip *)createNewTrip:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions
{
    INatTrip *trip = [NSEntityDescription insertNewObjectForEntityForName:@"INatTrip" inManagedObjectContext:managedObjectContext];
    
    trip.localCreatedAt = [NSDate date];
    trip.status = [NSNumber numberWithInteger:TripStatusCreated];
    trip.title = [NSString stringWithFormat:@"Trip %d - %@", (int)_privateTrips.count + 1, bcOptions.searchOptions.searchLocationName];
    trip.latitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.latitude];
    trip.longitude = [NSNumber numberWithDouble:bcOptions.searchOptions.searchAreaCentre.longitude];
    trip.searchAreaSpan = [NSNumber numberWithInteger:bcOptions.searchOptions.searchAreaSpan];
//    trip.body = @"This is test Trip created from BioCaching mobile app";
    
    if (![self saveChanges]) {
        return nil;
    }
    
    [_privateTrips addObject:trip];
    trip.removedRecords = [[NSMutableArray alloc] init];

    self.currentTrip = trip;
    return trip;
}

- (INatTrip *)createTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus
{
    [NSException raise:NSInternalInconsistencyException format:@"TripsDataManager:createTripFromOccurrenceResults"];
    
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

- (void)rollbackChanges
{
    if (managedObjectContext.hasChanges) {
        [managedObjectContext rollback];
    }
}

- (void)addTripToUploadQueue:(INatTrip *)trip {
    [_uploadQueue addObject:trip];
}

- (void)initiateUploads
{
    INatTrip *trip = _uploadQueue[0];
    if (trip.uploading) {
        return;
    } else {
        [self uploadNextTripInQueue];
    }
}

- (void)finishUpload:(INatTrip *)trip success:(BOOL)success {
    trip.uploading = NO;
    [_uploadQueue removeObject:trip];
    [self.delegate finishedUpload:trip success:success];
    if (success) {
        [BCLoggingHelper recordGoogleEvent:@"TripStatus" action:[NSString stringWithFormat:@"Published: %d", trip.recordId.intValue] value:[NSNumber numberWithInt:1]];
    } else {
        [BCLoggingHelper recordGoogleEvent:@"TripStatus" action:[NSString stringWithFormat:@"Upload Failure: %d", trip.recordId.intValue] value:[NSNumber numberWithInt:0]];
    }
}

- (void)uploadNextTripInQueue
{
    if (!_uploadQueue || _uploadQueue.count == 0) {
        return;
    }

    INatTrip *trip = _uploadQueue[0];
    trip.uploading = YES;
    [self.delegate startedUpload:trip];
    [BCLoggingHelper recordGoogleEvent:@"INAT" action:@"Upload Request" value:[NSNumber numberWithUnsignedInteger:trip.observations.count]];
    
    // Update Queue Arrays
    _observationsQueue = [[NSMutableArray alloc] init];
    for (INatObservation *observation in trip.observations) {
        [_observationsQueue addObject:observation];
    }
    _observationPhotosQueue = [[NSMutableArray alloc] init];
    for (INatObservation *observation in _observationsQueue) {
        [_observationPhotosQueue addObjectsFromArray:[observation.obsPhotos array]];
    }
    
    // Initiaite Upload With First Observation
    // ObservationPhotos and Trip Uploads Are Chained To Follow On
    [self uploadNextObservationInQueue];
}

- (void)uploadNextObservationInQueue
{
    if (!_observationsQueue || _observationsQueue.count == 0) {
        [self uploadNextObservationPhotoInQueue];
        return;
    }
        
    INatObservation *observation = _observationsQueue[0];
    INatTrip *trip = observation.taxaAttribute.trip;
    int observationsCount = (int)trip.observations.count;
    int observationIndex = (int)[trip.observations indexOfObject:observation] + 1;
    
    if (observation.needsSyncing) {
        NSString *progressString = [NSString stringWithFormat:@"Uploading Observation %d/%d...", observationIndex, observationsCount];
        [self.delegate uploadProgress:trip progressString:progressString success:TRUE];
        [_observationsQueue removeObject:observation];
        [[RKObjectManager sharedManager] postObject:observation path:@"observations" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ DONE", progressString] success:TRUE];
            NSLog(@"INatObservation Upload Success: %@", mappingResult);
            observation.syncedAt = observation.updatedAt;
            [self saveChanges];
            [self uploadNextObservationInQueue];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ ERROR", progressString] success:FALSE];
            NSLog(@"INatObservation Upload Error: %@", error);
            [self finishUpload:trip success:NO];
        }];
    } else {
        NSString *progressString = [NSString stringWithFormat:@"Skipping Observation %d/%d...", observationIndex, observationsCount];
        [self.delegate uploadProgress:trip progressString:progressString success:TRUE];
        [_observationsQueue removeObject:observation];
        [self uploadNextObservationInQueue];
    }
}

- (void)uploadNextObservationPhotoInQueue
{
    if (!_observationPhotosQueue || _observationPhotosQueue.count == 0) {
        [self uploadTripToINat:_uploadQueue[0]];
        return;
    }
    
    INatObservationPhoto *obsPhoto = _observationPhotosQueue[0];
    INatTrip *trip = obsPhoto.observation.taxaAttribute.trip;
    int obsPhotoCount = (int)trip.observationPhotos.count;
    int obsPhotoIndex = (int)[trip.observationPhotos indexOfObject:obsPhoto] + 1;
    
    if (obsPhoto.needsSyncing) {
        NSString *progressString = [NSString stringWithFormat:@"Uploading Observation Photo %d/%d...", obsPhotoIndex, obsPhotoCount];
        [self.delegate uploadProgress:trip progressString:progressString success:TRUE];
        
        NSURL *assetUrl = [NSURL URLWithString:obsPhoto.localAssetUrl];
        // Get image from Asset Library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        __block NSNumber *imageSize = nil;
        __block UIImage *myImage = nil;
        __block INatObservationPhoto *blockImage = nil;
        __block NSData *blockImageData = nil;
        
        [library assetForURL:assetUrl resultBlock:^(ALAsset *asset) {
            myImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage]];
            imageSize = [NSNumber numberWithLongLong:asset.defaultRepresentation.size];
            
            // make the image available on callback
            blockImage = obsPhoto;
            
            NSData *imageData = UIImageJPEGRepresentation(myImage, 0.75);
            blockImageData = imageData;
            
            NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:obsPhoto method:RKRequestMethodPOST path:@"observation_photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:imageData
                                            name:@"file"
                                        fileName:asset.defaultRepresentation.filename
                                        mimeType:@"image/jpeg"];
            }];
            
            [_observationPhotosQueue removeObject:obsPhoto];
            RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager] managedObjectRequestOperationWithRequest:request managedObjectContext:managedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ DONE", progressString] success:TRUE];
                NSLog(@"INatObservationPhoto Upload Success: %@", mappingResult);
                obsPhoto.syncedAt = obsPhoto.updatedAt;
                [self saveChanges];
                [self uploadNextObservationPhotoInQueue];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ ERROR", progressString] success:FALSE];
                NSLog(@"INatObservationPhoto Upload Error: %@", error);
                [self finishUpload:trip success:NO];
            }];
            // Ensure response object is mapped to request object
            operation.targetObject = obsPhoto;
            
            [operation.HTTPRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                int progressPercent = (int)(totalBytesWritten * 100/totalBytesExpectedToWrite);
                [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ %d%%", progressString, progressPercent] success:TRUE];
                NSLog(@"%@\n %d %d %d %%:%d%%", obsPhoto.observationId, (int)bytesWritten, (int)totalBytesWritten, (int)totalBytesExpectedToWrite, progressPercent);
            }];
            
            [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
            
        } failureBlock:^(NSError *error) {
            [self.delegate uploadProgress:trip progressString:@"Error Loading Photo From Device" success:FALSE];
            NSLog(@"Error Loading Asset: %@ %@", assetUrl, error);
            [self finishUpload:trip success:NO];
        }];
    } else {
        NSString *progressString = [NSString stringWithFormat:@"Skipping Observation %d/%d...", obsPhotoIndex, obsPhotoCount];
        [self.delegate uploadProgress:trip progressString:progressString success:TRUE];
        [_observationPhotosQueue removeObject:obsPhoto];
        [self uploadNextObservationPhotoInQueue];
    }
}


- (void)uploadTripToINat:(INatTrip *)trip
{
    if (!_uploadQueue || _uploadQueue.count == 0) {
        return;
    }
    
    if (trip.needsSyncing) {
        NSString *progressString = @"Uploading Trip Details...";
        [self.delegate uploadProgress:trip progressString:progressString success:TRUE];
        
        NSDictionary *queryParams = @{@"publish" : @"Publish"};
        [[RKObjectManager sharedManager] postObject:trip path:kINatTripsPathPattern parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ SUCCESS", progressString] success:TRUE];
            NSLog(@"INatTrip Upload Success: %@", mappingResult);
            trip.status = [NSNumber numberWithInt:TripStatusPublished];
            //TODO: Check trip.createdAt timestamp has been updated from POST response
            trip.syncedAt = trip.updatedAt;
            [self saveChanges];
            [self finishUpload:trip success:YES];
            [self uploadNextTripInQueue];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ ERROR", progressString] success:FALSE];
            NSLog(@"INatTrip Upload Error: %@", error);
            [self finishUpload:trip success:NO];
        }];
    }
}

/*
- (BOOL)uploadObservationsToINat {
    // Upload Observations
    for (int i = 0; i < trip.observations.count; i++) {
        INatObservation *observation = trip.observations[i];
        NSString *progressString = [NSString stringWithFormat:@"Uploading Observation %d/%d...", i+1, (int)trip.observations.count];
        [self.delegate uploadProgress:trip progressString:progressString success:TRUE];
        [[RKObjectManager sharedManager] postObject:observation path:@"observations" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ DONE", progressString] success:TRUE];
            NSLog(@"INatObservation Upload Success: %@", mappingResult);
            observation.syncedAt = observation.updatedAt;
            [self saveChanges];
            if (observation.obsPhotos.count > 0) {
                //                [self postObservationPhotosToINat:observation];
            }
            // TODO: Add Delegate To Send Progress Updates Back to VC
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            // TODO: Update local INatObservation object ??
            [self.delegate uploadProgress:trip progressString:[NSString stringWithFormat:@"%@ ERROR", progressString] success:FALSE];
            NSLog(@"INatObservation Upload Error: %@", error);
        }];
    }
    
}
*/
    // TODO: Only upload ObservationPhotos AFTER all Observations have been uploaded?
    
/*
     // TODO: Only Upload Trip AFTER all Observations and ObservationPhotos?
     // Upload Trip
*/

    
- (void)postObservationPhotosToINat:(INatObservation *)observation {
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    //    NSArray *obsPhotos = [trip.observations valueForKey:@"obsPhotos"];
    NSLog(@"Uploading Observation Photos For Observation: %@", observation.recordId);
    for (INatObservationPhoto *obsPhoto in observation.obsPhotos) {
/*
        UIImage *testImage = [UIImage imageNamed:@"TestImage.jpg"];

        NSMutableURLRequest *request = [objectManager multipartFormRequestWithObject:obsPhoto method:RKRequestMethodPOST path:@"observation_photos" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(testImage, 0.75) name:@"file" fileName:@"TestImage.jpg" mimeType:@"image/jpeg"];
        }];
         RKManagedObjectRequestOperation *operation = [objectManager managedObjectRequestOperationWithRequest:request managedObjectContext:managedObjectContext success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
             NSLog(@"INatObservationPhoto Upload Success: %@", mappingResult);
             obsPhoto.syncedAt = obsPhoto.updatedAt;
             [self saveChanges];
         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         NSLog(@"INatObservationPhoto Upload Error: %@", error);
         }];
        // Ensure response object is mapped to request object
        operation.targetObject = obsPhoto;
        [objectManager enqueueObjectRequestOperation:operation];
*/
    }
}

- (BOOL)postTripToINat:(INatTrip *)trip {
    return TRUE;
}


- (void)deleteTripFromINat:(INatTrip *)trip
{
    [[RKObjectManager sharedManager] deleteObject:trip path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"delete Success: %@", mappingResult);
        [_privateTrips removeObject:trip];
        if(_currentTrip == trip) {
            _currentTrip = nil;
        }
        [BCAlerts displayDefaultInfoNotification:@"Trip Deleted From iNaturalist" subtitle:nil];
        [self.delegate tripsDataTableUpdated];
        
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
    [self.delegate tripsDataTableUpdated];
}

- (void)removeOccurrenceFromTrip:(INatTrip *)trip occurrence:(OccurrenceRecord *)occurrence
{
    //TODO: Should check Trip contains OccurrenceRecord to be deleted?
    if (occurrence.managedObjectContext) {
        [managedObjectContext deleteObject:occurrence.taxaAttribute];
    } else {
        NSString *reasonString = [NSString stringWithFormat:@"Attempting to delete OccurrenceRecord MO that does not exist:%@", occurrence];
        @throw [NSException exceptionWithName:@"TripsDataManager"
                                       reason:reasonString
                                     userInfo:nil];
    }
    
    if ([self saveChanges]) {
        [trip.removedRecords addObject:occurrence];
        [self.exploreDelegate occurrenceRemovedFromTrip:occurrence];
    }
}

- (void)addNewTaxaAttributeFromOccurrence:(OccurrenceRecord *)occurrenceRecord
{
    INatTripTaxaAttribute *taxaAttribute = [INatTripTaxaAttribute createFromINatTaxon:occurrenceRecord.iNatTaxon];
    taxaAttribute.occurrence = occurrenceRecord;
    
    [self.currentTrip.taxaAttributesSet addObject:taxaAttribute];
    [self saveChanges];

    [self.exploreDelegate occurrenceAddedToTrip:occurrenceRecord];
}

- (void)addObservationToTripOccurrence:(INatObservation *)observation occurrence:(OccurrenceRecord *)occurrence
{
    occurrence.taxaAttribute.observation = observation;
    occurrence.taxaAttribute.observedValue = YES;
    [self saveChanges];
}

- (void)removeObservationFromTripOccurrence:(INatObservation *)observation occurrence:(OccurrenceRecord *)occurrence
{
    //TODO: Should check Occurrence contains Observation to be deleted?
    if (observation.managedObjectContext) {
        [managedObjectContext deleteObject:observation];
    } else {
        NSString *reasonString = [NSString stringWithFormat:@"Attempting to delete Observation MO that does not exist:%@", occurrence];
        @throw [NSException exceptionWithName:@"TripsDataManager"
                                       reason:reasonString
                                     userInfo:nil];
    }
}

- (void)addNewPhotoToTripObservation:(NSString *)localAssetUrlString observation:(INatObservation *)observation
{
    INatObservationPhoto *obsPhoto = [INatObservationPhoto createNewObservationPhoto:localAssetUrlString];
    [observation.obsPhotosSet addObject:obsPhoto];
}

- (void)addLocationToCurrentTripTrack:(CLLocation *)location {
    if (!_currentTrip.locationTrack) {
        _currentTrip.locationTrack = [[NSMutableOrderedSet alloc] init];
    }
    [_currentTrip.locationTrack addObject:location];
    [self.exploreDelegate locationTrackUpdated:_currentTrip];
}


@end
