// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BCManagedObject.h instead.

#import <CoreData/CoreData.h>


extern const struct BCManagedObjectAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *objectId;
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





@property (nonatomic, strong) NSNumber* objectId;



@property int32_t objectIdValue;
- (int32_t)objectIdValue;
- (void)setObjectIdValue:(int32_t)value_;

//- (BOOL)validateObjectId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;






@end

@interface _BCManagedObject (CoreDataGeneratedAccessors)

@end

@interface _BCManagedObject (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveObjectId;
- (void)setPrimitiveObjectId:(NSNumber*)value;

- (int32_t)primitiveObjectIdValue;
- (void)setPrimitiveObjectIdValue:(int32_t)value_;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;




@end
