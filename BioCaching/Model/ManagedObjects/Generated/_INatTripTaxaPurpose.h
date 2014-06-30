// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTripTaxaPurpose.h instead.

#import <CoreData/CoreData.h>


extern const struct INatTripTaxaPurposeAttributes {
	__unsafe_unretained NSString *complete;
	__unsafe_unretained NSString *resourceId;
	__unsafe_unretained NSString *resourceType;
} INatTripTaxaPurposeAttributes;

extern const struct INatTripTaxaPurposeRelationships {
	__unsafe_unretained NSString *trip;
} INatTripTaxaPurposeRelationships;

extern const struct INatTripTaxaPurposeFetchedProperties {
} INatTripTaxaPurposeFetchedProperties;

@class INatTrip;





@interface INatTripTaxaPurposeID : NSManagedObjectID {}
@end

@interface _INatTripTaxaPurpose : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTripTaxaPurposeID*)objectID;





@property (nonatomic, strong) NSNumber* complete;



@property BOOL completeValue;
- (BOOL)completeValue;
- (void)setCompleteValue:(BOOL)value_;

//- (BOOL)validateComplete:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* resourceId;



@property int32_t resourceIdValue;
- (int32_t)resourceIdValue;
- (void)setResourceIdValue:(int32_t)value_;

//- (BOOL)validateResourceId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* resourceType;



//- (BOOL)validateResourceType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) INatTrip *trip;

//- (BOOL)validateTrip:(id*)value_ error:(NSError**)error_;





@end

@interface _INatTripTaxaPurpose (CoreDataGeneratedAccessors)

@end

@interface _INatTripTaxaPurpose (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveComplete;
- (void)setPrimitiveComplete:(NSNumber*)value;

- (BOOL)primitiveCompleteValue;
- (void)setPrimitiveCompleteValue:(BOOL)value_;




- (NSNumber*)primitiveResourceId;
- (void)setPrimitiveResourceId:(NSNumber*)value;

- (int32_t)primitiveResourceIdValue;
- (void)setPrimitiveResourceIdValue:(int32_t)value_;




- (NSString*)primitiveResourceType;
- (void)setPrimitiveResourceType:(NSString*)value;





- (INatTrip*)primitiveTrip;
- (void)setPrimitiveTrip:(INatTrip*)value;


@end
