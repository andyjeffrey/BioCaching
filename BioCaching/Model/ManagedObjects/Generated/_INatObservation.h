// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatObservation.h instead.

#import <CoreData/CoreData.h>


extern const struct INatObservationAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *dateRecorded;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *localCreatedAt;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *recordId;
	__unsafe_unretained NSString *syncedAt;
	__unsafe_unretained NSString *taxonId;
	__unsafe_unretained NSString *updatedAt;
} INatObservationAttributes;

extern const struct INatObservationRelationships {
	__unsafe_unretained NSString *obsPhotos;
	__unsafe_unretained NSString *taxaAttribute;
} INatObservationRelationships;

extern const struct INatObservationFetchedProperties {
} INatObservationFetchedProperties;

@class INatObservationPhoto;
@class INatTripTaxaAttribute;












@interface INatObservationID : NSManagedObjectID {}
@end

@interface _INatObservation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatObservationID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* dateRecorded;



//- (BOOL)validateDateRecorded:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recordId;



@property int32_t recordIdValue;
- (int32_t)recordIdValue;
- (void)setRecordIdValue:(int32_t)value_;

//- (BOOL)validateRecordId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* syncedAt;



//- (BOOL)validateSyncedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* taxonId;



@property int32_t taxonIdValue;
- (int32_t)taxonIdValue;
- (void)setTaxonIdValue:(int32_t)value_;

//- (BOOL)validateTaxonId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *obsPhotos;

- (NSMutableOrderedSet*)obsPhotosSet;




@property (nonatomic, strong) INatTripTaxaAttribute *taxaAttribute;

//- (BOOL)validateTaxaAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _INatObservation (CoreDataGeneratedAccessors)

- (void)addObsPhotos:(NSOrderedSet*)value_;
- (void)removeObsPhotos:(NSOrderedSet*)value_;
- (void)addObsPhotosObject:(INatObservationPhoto*)value_;
- (void)removeObsPhotosObject:(INatObservationPhoto*)value_;

@end

@interface _INatObservation (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSDate*)primitiveDateRecorded;
- (void)setPrimitiveDateRecorded:(NSDate*)value;




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




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSNumber*)primitiveRecordId;
- (void)setPrimitiveRecordId:(NSNumber*)value;

- (int32_t)primitiveRecordIdValue;
- (void)setPrimitiveRecordIdValue:(int32_t)value_;




- (NSDate*)primitiveSyncedAt;
- (void)setPrimitiveSyncedAt:(NSDate*)value;




- (NSNumber*)primitiveTaxonId;
- (void)setPrimitiveTaxonId:(NSNumber*)value;

- (int32_t)primitiveTaxonIdValue;
- (void)setPrimitiveTaxonIdValue:(int32_t)value_;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;





- (NSMutableOrderedSet*)primitiveObsPhotos;
- (void)setPrimitiveObsPhotos:(NSMutableOrderedSet*)value;



- (INatTripTaxaAttribute*)primitiveTaxaAttribute;
- (void)setPrimitiveTaxaAttribute:(INatTripTaxaAttribute*)value;


@end
