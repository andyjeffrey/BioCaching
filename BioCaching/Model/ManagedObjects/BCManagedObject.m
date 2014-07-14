#import "BCManagedObject.h"



@implementation BCManagedObject

+ (NSManagedObject *)fetchEntityWithRecordId:(NSString *)entityName recordId:(NSNumber *)recordId {
    
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    NSManagedObject *fetchedEntity = nil;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"recordId = %@", recordId];
    
    NSError *error;
    NSArray *resultsArray = [managedObjectContext executeFetchRequest:request error:&error];
    if (!resultsArray) {
        NSLog(@"Fetch Failed: %@", error);
    } else if (resultsArray.count == 0) {
        NSLog(@"No Results Found, EntityName: %@, RecordId: %@", entityName, recordId);
    } else {
        fetchedEntity = resultsArray[0];
    }
    
    return fetchedEntity;
}

+ (NSArray *)fetchSelectedEntities:(NSString *)entityName filter:(NSString *)filter {
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:managedObjectContext];
    request.entity = entity;
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"localCreatedAt" ascending:NO];
    request.sortDescriptors = @[sortDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:filter];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedEntities = [managedObjectContext executeFetchRequest:request error:&error];
    if (!fetchedEntities) {
        NSLog(@"Fetch Failed: %@", error);
    } else if (fetchedEntities.count == 0) {
        NSLog(@"No Results Found, EntityName: %@, Filter: %@", entityName, filter);
    }
    
    return fetchedEntities;
}

@end
