#import "INatObservationPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation INatObservationPhoto

+ (id)createNewObservationPhoto:(NSString *)photoAssetUrl {
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    INatObservationPhoto *obsPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"INatObservationPhoto" inManagedObjectContext:managedObjectContext];
    
    obsPhoto.localCreatedAt = [NSDate date];
    obsPhoto.localAssetUrl = [photoAssetUrl copy];

    return obsPhoto;
}

+(void)setupMapping
{
    NSString *entityPathPattern = @"observation_photos";
    NSString *entityPostReqKeyPath = @"observation_photo";
    NSString *entityPostRespKeyPath = nil;
    
    RKManagedObjectStore *managedObjectStore = [RKManagedObjectStore defaultStore];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *parentMappingDict = @{
                                        @"id" : @"recordId",
                                        @"created_at" : @"createdAt",
                                        @"updated_at" : @"updatedAt",
                                        };
    
    
    NSDictionary *entityMappingDict = @{
                                        @"observation_id" : @"observationId",
                                        };
    
    
    // Entity Post Request Mapping
    RKEntityMapping *entityPostMapping = [RKEntityMapping mappingForEntityForName:@"INatObservationPhoto" inManagedObjectStore:managedObjectStore];
    [entityPostMapping addAttributeMappingsFromDictionary:entityMappingDict];
    
    // Entity Post Response Mapping
    RKEntityMapping *entityGetMapping = [RKEntityMapping mappingForEntityForName:@"INatObservationPhoto" inManagedObjectStore:managedObjectStore];
    [entityGetMapping addAttributeMappingsFromDictionary:parentMappingDict];
//    [entityGetMapping addAttributeMappingsFromDictionary:entityMappingDict];
    entityGetMapping.identificationAttributes = @[@"recordId"];
    
    // Entity POST Request
    RKRequestDescriptor *entityPostReqDesc = [RKRequestDescriptor requestDescriptorWithMapping:entityPostMapping.inverseMapping objectClass:[INatObservationPhoto class] rootKeyPath:entityPostReqKeyPath method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:entityPostReqDesc];
    
    // Entity POST Response
    RKResponseDescriptor *entityPostRespDesc = [RKResponseDescriptor responseDescriptorWithMapping:entityGetMapping method:RKRequestMethodPOST pathPattern:entityPathPattern keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [objectManager addResponseDescriptor:entityPostRespDesc];

//    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[INatObservationPhoto class] pathPattern:@"observation_photos" method:RKRequestMethodPOST]];
    
}


- (BOOL)needsSyncing {
    if (!self.syncedAt || [self.syncedAt timeIntervalSinceDate:self.updatedAt] < 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (NSNumber *)observationId {
    return self.observation.recordId;
}

- (NSString *)localAssetFilename {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSURL *assetUrl = [NSURL URLWithString:self.localAssetUrl];
    [assetsLibrary assetForURL:assetUrl resultBlock: ^(ALAsset *asset){
        ALAssetRepresentation *representation = [asset defaultRepresentation];
    } failureBlock: ^(NSError *error){
        // Error Loading Asset From Asset Library
        NSLog(@"Error Loading Asset: %@ %@", assetUrl, error);
        // Display Error Text (over imageView?)
    }];
    return nil;
}

@end
