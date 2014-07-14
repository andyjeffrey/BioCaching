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

@end
