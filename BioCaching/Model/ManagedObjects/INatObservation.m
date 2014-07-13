#import "INatObservation.h"

@implementation INatObservation

@synthesize occurrenceRecord;
@synthesize iNatTaxon;
@synthesize taxonSpecies;
@synthesize coordinate;
@synthesize dateRecordedString;

+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    INatObservation *observation = [NSEntityDescription insertNewObjectForEntityForName:@"INatObservation" inManagedObjectContext:managedObjectContext];
    
    observation.localCreatedAt = [NSDate date];
    observation.taxonId = [occurrence.iNatTaxon.recordId copy];
    
    return observation;
}

+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence dateRecorded:(NSDate *)dateRecorded location:(CLLocation *)location notes:(NSString *)notes
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    INatObservation *observation = [NSEntityDescription insertNewObjectForEntityForName:@"INatObservation" inManagedObjectContext:managedObjectContext];
    
    observation.localCreatedAt = [NSDate date];

    observation.taxonId = [occurrence.iNatTaxon.recordId copy];
    observation.dateRecorded = dateRecorded;
    observation.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    observation.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    
    observation.notes = [notes copy];
    
    return observation;
}

+(void)setupMapping
{
    NSString *entityGetReqPath = @"observations/:recordId";
    NSString *entityGetRespPath = nil;
    NSString *collectionReqPath = @"observations";
    NSString *collectionRespPath = nil;
    NSString *entityPostReqKeyPath = @"observation";
    NSString *entityPostRespKeyPath = nil;

    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *parentMappingDict = @{
                                          @"id" : @"recordId",
                                          @"created_at" : @"createdAt",
                                          @"updated_at" : @"updatedAt",
                                          };
    
    
    NSDictionary *entityMappingDict = @{
                                            @"taxon_id" : @"taxonId",
                                            @"species_guess" : @"taxonSpecies",
                                            @"latitude" : @"latitude",
                                            @"longitude" : @"longitude",
                                            @"observed_on_string" : @"dateRecordedString",
                                            @"description" : @"notes",
                                            };

    
    // Entity Post Request Mapping
    RKEntityMapping *entityPostMapping = [RKEntityMapping mappingForEntityForName:@"INatObservation" inManagedObjectStore:managedObjectStore];
    [entityPostMapping addAttributeMappingsFromDictionary:entityMappingDict];

    // Entity Post Response Mapping
    RKEntityMapping *entityGetMapping = [RKEntityMapping mappingForEntityForName:@"INatObservation" inManagedObjectStore:managedObjectStore];
    [entityGetMapping addAttributeMappingsFromDictionary:parentMappingDict];
    [entityGetMapping addAttributeMappingsFromDictionary:entityMappingDict];
    entityGetMapping.identificationAttributes = @[@"recordId"];
    
    // Entity POST Request
    RKRequestDescriptor *entityPostReqDesc = [RKRequestDescriptor requestDescriptorWithMapping:entityPostMapping.inverseMapping objectClass:[INatObservation class] rootKeyPath:@"observation" method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:entityPostReqDesc];
    
    // Entity POST Response
    RKResponseDescriptor *entityPostRespDesc = [RKResponseDescriptor responseDescriptorWithMapping:entityGetMapping method:RKRequestMethodPOST pathPattern:@"observations" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:entityPostRespDesc];
}


- (BOOL)needsSyncing {
    if (!self.syncedAt || [self.syncedAt timeIntervalSinceDate:self.updatedAt] < 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (OccurrenceRecord *)occurrenceRecord {
    return self.taxaAttribute.occurrence;
}

- (INatTaxon *)iNatTaxon {
    return self.taxaAttribute.occurrence.iNatTaxon;
}

- (NSString *)taxonSpecies {
    return self.iNatTaxon.name;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}

/*
- (void)setCoordinate:(CLLocationCoordinate2D)locationCoordinate {
    // Correct way for CoreData/KVC?
    //    [self willChangeValueForKey:@"propertyKey"];
    //    [self setPrimitiveValue:radius forKey:@"propertyKey"];
    //    [self didChangeValueForKey:@"propertyKey"];
    self.latitude = [NSNumber numberWithDouble:locationCoordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:locationCoordinate.longitude];
}
*/

- (NSString *)dateRecordedString {
    return [self.dateRecorded iso8601INatString];
}

@end
