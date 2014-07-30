#import "INatTrip.h"

@implementation INatTrip

@synthesize needsSyncing;
@synthesize locationCoordinate;
@synthesize radius = _radius;
@synthesize locationName;
@synthesize occurrenceRecords;
@synthesize removedRecords;
@synthesize observations;
@synthesize observationPhotos;
@synthesize uploading;

+(void)setupMapping
{
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *parentObjectMapping = @{
                                          @"id" : @"recordId",
                                          @"created_at" : @"createdAt",
                                          @"updated_at" : @"updatedAt",
                                          };
    
    
    NSDictionary *iNatTripObjectMapping = @{
                                            @"title" : @"title",
                                            @"body" : @"body",
                                            @"latitude" : @"latitude",
                                            @"longitude" : @"longitude",
                                            @"radius" : @"radius",
                                            @"place_id" : @"placeId",
                                            @"user_id" : @"userId",
                                            @"start_time" : @"startTime",
                                            @"stop_time" : @"stopTime"
                                            };
    
    // Trip Entity Mapping
    RKEntityMapping *entityMappingTrip = [RKEntityMapping mappingForEntityForName:@"INatTrip" inManagedObjectStore:managedObjectStore];
    [entityMappingTrip addAttributeMappingsFromDictionary:parentObjectMapping];
    [entityMappingTrip addAttributeMappingsFromDictionary:iNatTripObjectMapping];
    entityMappingTrip.identificationAttributes = @[@"recordId"];
    
    
    // Trip Entity POST Mapping
    RKEntityMapping *postMappingTrip = [RKEntityMapping mappingForEntityForName:@"INatTrip" inManagedObjectStore:managedObjectStore];
    [postMappingTrip addAttributeMappingsFromDictionary:iNatTripObjectMapping];
    
    
    // Mappings for Trip Taxa Collections
    NSDictionary *iNatTripTaxaAttObjectMapping = @{
                                                   @"taxon_id" : @"taxonId",
                                                   @"observed" : @"observed"
                                                   };
    
    RKEntityMapping *entityMappingTaxaAtt = [RKEntityMapping mappingForEntityForName:@"INatTripTaxaAttribute" inManagedObjectStore:managedObjectStore];
    //    [entityMappingTaxaAtt addAttributeMappingsFromDictionary:parentObjectMapping];
    [entityMappingTaxaAtt addAttributeMappingsFromDictionary:iNatTripTaxaAttObjectMapping];
    //    entityMappingTaxaAtt.identificationAttributes = @[@"recordId"];
    
    [postMappingTrip addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"trip_taxa_attributes" toKeyPath:@"taxaAttributes" withMapping:entityMappingTaxaAtt]];
    
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[INatTrip class] pathPattern:@"trips/:recordId" method:RKRequestMethodAny]];

    // Trip Collection GET Response
    RKResponseDescriptor *respDescTripsCollection = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodGET pathPattern:kINatTripsPathPattern keyPath:kINatTripsKeyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTripsCollection];
    
    // Trip Entity GET Response
    RKResponseDescriptor *respDescTrip = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodGET pathPattern:@"trips/:recordId" keyPath:kINatTripsKeyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTrip];
    
    // Trip Entity POST Request
    RKRequestDescriptor *reqDescTripPost = [RKRequestDescriptor requestDescriptorWithMapping:[postMappingTrip inverseMapping] objectClass:[INatTrip class] rootKeyPath:@"trip" method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:reqDescTripPost];
    
    // Trip Entity POST Response
    RKResponseDescriptor *respDescTripsPost = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodPOST pathPattern:kINatTripsPathPattern keyPath:@"trip" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTripsPost];
}

- (BOOL)needsSyncing {
    if (!self.syncedAt || [self.syncedAt timeIntervalSinceDate:self.updatedAt] < 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (CLLocationCoordinate2D)locationCoordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (NSNumber *)radius {
    return [NSNumber numberWithInt:self.searchAreaSpan.intValue / 2];
}

- (void)setRadius:(NSNumber *)radius {
    // Correct way for CoreData/KVC?
//    [self willChangeValueForKey:@"searchAreaSpan"];
//    [self setPrimitiveValue:radius forKey:@"searchAreaSpan"];
//    [self didChangeValueForKey:@"searchAreaSpan"];
    _radius = radius;
    [self setSearchAreaSpan:[NSNumber numberWithInt:radius.intValue * 2]];
}

- (NSArray *)occurrenceRecords {
    return [self.taxaAttributes valueForKeyPath:@"occurrence"];
}

- (NSArray *)observations {
    return [self.taxaAttributes valueForKeyPath:@"observation"];
}

- (NSArray *)observationPhotos {
    NSMutableArray *obsPhotos = [[NSMutableArray alloc] init];
    for (INatObservation *observation in self.observations) {
        [obsPhotos addObjectsFromArray:[observation.obsPhotos array]];
    }
    return obsPhotos;
}

@end
