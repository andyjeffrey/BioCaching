#import "INatTaxon.h"


@interface INatTaxon ()

// Private interface goes here.

@end


@implementation INatTaxon

+(void)setupMapping
{
    NSString *entityReqPath = @"taxa/:recordId";
    NSString *entityRespPath = nil;
    NSString *collectionReqPath = @"taxa";
    NSString *collectionRespPath = nil;
    
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *parentObjectMapping = @{
                                          @"id" : @"recordId",
                                          @"created_at" : @"createdAt",
                                          @"updated_at" : @"updatedAt",
                                          };
    
    
    NSDictionary *entityObjectMapping = @{
                                            @"name" : @"name",
                                            @"common_name.name" : @"commonName",
                                            @"image_url" : @"squareImageUrl",
                                            @"wikipedia_summary" : @"summaryText",
                                            };
    
    // Entity Mapping
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"INatTaxon" inManagedObjectStore:managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:parentObjectMapping];
    [entityMapping addAttributeMappingsFromDictionary:entityObjectMapping];
    entityMapping.identificationAttributes = @[@"recordId"];

    // Mappings for Trip Taxa Collections
    NSDictionary *photoEntityObjectMapping = @{
                                                   @"attribution" : @"attribution",
                                                   @"license_code" : @"licenseCode",
                                                   @"thumb_url" : @"thumbUrl",
                                                   @"square_url" : @"squareUrl",
                                                   @"small_url" : @"smallUrl",
                                                   @"medium_url" : @"mediumUrl",
                                                   @"large_url" : @"largeUrl",
                                                   @"native_username" : @"nativeUsername",
                                                   @"native_realname" : @"nativeRealname",
                                                   };
    
    RKEntityMapping *photoEntityMapping = [RKEntityMapping mappingForEntityForName:@"INatTaxonPhoto" inManagedObjectStore:managedObjectStore];
    //    [entityMappingTaxaAtt addAttributeMappingsFromDictionary:parentObjectMapping];
    [photoEntityMapping addAttributeMappingsFromDictionary:photoEntityObjectMapping];
    //    entityMappingTaxaAtt.identificationAttributes = @[@"recordId"];
    
    [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"taxon_photos.photo" toKeyPath:@"taxonPhotos" withMapping:photoEntityMapping]];
    
    // Entity GET Response
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[INatTaxon class] pathPattern:entityReqPath method:RKRequestMethodAny]];
    RKResponseDescriptor *entityRespDesc = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern:entityReqPath keyPath:entityRespPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:entityRespDesc];

    // Entity Collection GET Response
    RKResponseDescriptor *entityCollectionRespDesc = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern:collectionReqPath keyPath:collectionRespPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:entityCollectionRespDesc];
    
}

+ (INatTaxon *)createFromDictionary:(NSDictionary *)dictionary error:(NSError**)error
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    INatTaxon *iNatTaxon = [NSEntityDescription insertNewObjectForEntityForName:@"INatTaxon" inManagedObjectContext:managedObjectContext];
    
    iNatTaxon.recordId = [dictionary objectForKey:@"id"];
    iNatTaxon.name = [[dictionary objectForKey:@"name"] stringValue];
    iNatTaxon.searchName = [[dictionary objectForKey:@"name"] stringValue];
    iNatTaxon.summaryText = [[dictionary objectForKey:@"wikipedia_summary"] stringValue];
    iNatTaxon.squareImageUrl = [[dictionary objectForKey:@"image_url"] stringValue];
    
//    iNatTaxon.taxon_photos = [[NSMutableArray alloc] init];
    
    return iNatTaxon;
}


@end
