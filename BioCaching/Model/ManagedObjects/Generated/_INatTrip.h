// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTrip.h instead.

#import <CoreData/CoreData.h>


extern const struct INatTripAttributes {
	__unsafe_unretained NSString *body;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *localCreatedAt;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *placeId;
	__unsafe_unretained NSString *recordId;
	__unsafe_unretained NSString *searchAreaSpan;
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *status;
	__unsafe_unretained NSString *stopTime;
	__unsafe_unretained NSString *syncedAt;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
	__unsafe_unretained NSString *userId;
} INatTripAttributes;

extern const struct INatTripRelationships {
	__unsafe_unretained NSString *taxaAttributes;
	__unsafe_unretained NSString *taxaPurposes;
} INatTripRelationships;

extern const struct INatTripFetchedProperties {
} INatTripFetchedProperties;

@class INatTripTaxaAttribute;
@class INatTripTaxaPurpose;

















@interface INatTripID : NSManagedObjectID {}
@end

@interface _INatTrip : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTripID*)objectID;





@property (nonatomic, strong) NSString* body;



//- (BOOL)validateBody:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* localCreatedAt;



//- (BOOL)validateLocalCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* placeId;



@property int32_t placeIdValue;
- (int32_t)placeIdValue;
- (void)setPlaceIdValue:(int32_t)value_;

//- (BOOL)validatePlaceId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recordId;



@property int32_t recordIdValue;
- (int32_t)recordIdValue;
- (void)setRecordIdValue:(int32_t)value_;

//- (BOOL)validateRecordId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* searchAreaSpan;



@property int32_t searchAreaSpanValue;
- (int32_t)searchAreaSpanValue;
- (void)setSearchAreaSpanValue:(int32_t)value_;

//- (BOOL)validateSearchAreaSpan:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startTime;



//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int32_t statusValue;
- (int32_t)statusValue;
- (void)setStatusValue:(int32_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* stopTime;



//- (BOOL)validateStopTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* syncedAt;



//- (BOOL)validateSyncedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userId;



@property int32_t userIdValue;
- (int32_t)userIdValue;
- (void)setUserIdValue:(int32_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *taxaAttributes;

- (NSMutableOrderedSet*)taxaAttributesSet;




@property (nonatomic, strong) NSOrderedSet *taxaPurposes;

- (NSMutableOrderedSet*)taxaPurposesSet;





@end

@interface _INatTrip (CoreDataGeneratedAccessors)

- (void)addTaxaAttributes:(NSOrderedSet*)value_;
- (void)removeTaxaAttributes:(NSOrderedSet*)value_;
- (void)addTaxaAttributesObject:(INatTripTaxaAttribute*)value_;
- (void)removeTaxaAttributesObject:(INatTripTaxaAttribute*)value_;

- (void)addTaxaPurposes:(NSOrderedSet*)value_;
- (void)removeTaxaPurposes:(NSOrderedSet*)value_;
- (void)addTaxaPurposesObject:(INatTripTaxaPurpose*)value_;
- (void)removeTaxaPurposesObject:(INatTripTaxaPurpose*)value_;

@end

@interface _INatTrip (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBody;
- (void)setPrimitiveBody:(NSString*)value;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSDate*)primitiveLocalCreatedAt;
- (void)setPrimitiveLocalCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSNumber*)primitivePlaceId;
- (void)setPrimitivePlaceId:(NSNumber*)value;

- (int32_t)primitivePlaceIdValue;
- (void)setPrimitivePlaceIdValue:(int32_t)value_;




- (NSNumber*)primitiveRecordId;
- (void)setPrimitiveRecordId:(NSNumber*)value;

- (int32_t)primitiveRecordIdValue;
- (void)setPrimitiveRecordIdValue:(int32_t)value_;




- (NSNumber*)primitiveSearchAreaSpan;
- (void)setPrimitiveSearchAreaSpan:(NSNumber*)value;

- (int32_t)primitiveSearchAreaSpanValue;
- (void)setPrimitiveSearchAreaSpanValue:(int32_t)value_;




- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int32_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int32_t)value_;




- (NSDate*)primitiveStopTime;
- (void)setPrimitiveStopTime:(NSDate*)value;




- (NSDate*)primitiveSyncedAt;
- (void)setPrimitiveSyncedAt:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;




- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int32_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int32_t)value_;





- (NSMutableOrderedSet*)primitiveTaxaAttributes;
- (void)setPrimitiveTaxaAttributes:(NSMutableOrderedSet*)value;



- (NSMutableOrderedSet*)primitiveTaxaPurposes;
- (void)setPrimitiveTaxaPurposes:(NSMutableOrderedSet*)value;


@end
