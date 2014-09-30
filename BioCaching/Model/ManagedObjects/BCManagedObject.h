@interface BCManagedObject : NSObject

+ (NSManagedObject *)fetchEntityWithRecordId:(NSString *)entityName recordId:(NSNumber *)recordId;
+ (NSArray *)fetchSelectedEntities:(NSString *)entityName filter:(NSString *)filter;

@end
