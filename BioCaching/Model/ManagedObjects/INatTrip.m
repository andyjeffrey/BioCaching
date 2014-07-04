#import "INatTrip.h"


@interface INatTrip ()

// Private interface goes here.

@end


@implementation INatTrip

@synthesize locationCoordinate;
@synthesize locationName;
@synthesize occurrenceRecords;
@synthesize removedRecords;

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
                                            @"positional_accuracy" : @"positionalAccuracy",
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
    
    // Trip Collection GET Response
    RKResponseDescriptor *respDescTripsCollection = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodGET pathPattern:kINatTripsPathPattern keyPath:kINatTripsKeyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTripsCollection];
    
    // Trip Entity GET Response
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[INatTrip class] pathPattern:@"trips/:recordId" method:RKRequestMethodAny]];
    RKResponseDescriptor *respDescTrip = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodAny pathPattern:@"trips/:recordId" keyPath:@"trip" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTrip];
    
    // Trip Entity POST Request
    RKRequestDescriptor *reqDescTripPost = [RKRequestDescriptor requestDescriptorWithMapping:[postMappingTrip inverseMapping] objectClass:[INatTrip class] rootKeyPath:@"trip" method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:reqDescTripPost];
    
    // Trip Entity POST Response
    RKResponseDescriptor *respDescTripsPost = [RKResponseDescriptor responseDescriptorWithMapping:entityMappingTrip method:RKRequestMethodAny pathPattern:kINatTripsPathPattern keyPath:@"trip" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:respDescTripsPost];
}

- (CLLocationCoordinate2D)locationCoordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

- (NSArray *)occurrenceRecords {
    return [self.taxaAttributes valueForKeyPath:@"occurrence"];
}

@end
