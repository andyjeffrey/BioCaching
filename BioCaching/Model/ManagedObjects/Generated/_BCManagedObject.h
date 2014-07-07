// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BCManagedObject.h instead.

#import <CoreData/CoreData.h>


extern const struct BCManagedObjectAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *localCreatedAt;
	__unsafe_unretained NSString *recordId;
	__unsafe_unretained NSString *syncedAt;
	__unsafe_unretained NSString *updatedAt;
} BCManagedObjectAttributes;

extern const struct BCManagedObjectRelationships {
} BCManagedObjectRelationships;

extern const struct BCManagedObjectFetchedProperties {
} BCManagedObjectFetchedProperties;








@interface BCManagedObjectID : NSManagedObjectID {}
@end

@interface _BCManagedObject : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BCManagedObjectID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* localCreatedAt;



//- (BOOL)validateLocalCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recordId;



@property int32_t recordIdValue;
- (int32_t)recordIdValue;
- (void)setRecordIdValue:(int32_t)value_;

//- (BOOL)validateRecordId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* syncedAt;



//- (BOOL)validateSyncedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;






@end

@interface _BCManagedObject (CoreDataGeneratedAccessors)

@end

@interface _BCManagedObject (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSDate*)primitiveLocalCreatedAt;
- (void)setPrimitiveLocalCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveRecordId;
- (void)setPrimitiveRecordId:(NSNumber*)value;

- (int32_t)primitiveRecordIdValue;
- (void)setPrimitiveRecordIdValue:(int32_t)value_;




- (NSDate*)primitiveSyncedAt;
- (void)setPrimitiveSyncedAt:(NSDate*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;




@end
