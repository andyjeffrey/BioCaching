#import "_BCManagedObject.h"

@interface BCManagedObject : _BCManagedObject {}

+ (NSManagedObject *)fetchEntityWithRecordId:(NSString *)entityName recordId:(NSNumber *)recordId;

@end
