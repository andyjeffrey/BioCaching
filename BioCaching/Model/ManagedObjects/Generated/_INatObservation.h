// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatObservation.h instead.

#import <CoreData/CoreData.h>


extern const struct INatObservationAttributes {
	__unsafe_unretained NSString *dateRecorded;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *notes;
	__unsafe_unretained NSString *taxonId;
} INatObservationAttributes;

extern const struct INatObservationRelationships {
	__unsafe_unretained NSString *tripTaxaAttribute;
} INatObservationRelationships;

extern const struct INatObservationFetchedProperties {
} INatObservationFetchedProperties;

@class INatTripTaxaAttribute;







@interface INatObservationID : NSManagedObjectID {}
@end

@interface _INatObservation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatObservationID*)objectID;





@property (nonatomic, strong) NSDate* dateRecorded;



//- (BOOL)validateDateRecorded:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* notes;



//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* taxonId;



@property int32_t taxonIdValue;
- (int32_t)taxonIdValue;
- (void)setTaxonIdValue:(int32_t)value_;

//- (BOOL)validateTaxonId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) INatTripTaxaAttribute *tripTaxaAttribute;

//- (BOOL)validateTripTaxaAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _INatObservation (CoreDataGeneratedAccessors)

@end

@interface _INatObservation (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDateRecorded;
- (void)setPrimitiveDateRecorded:(NSDate*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveNotes;
- (void)setPrimitiveNotes:(NSString*)value;




- (NSNumber*)primitiveTaxonId;
- (void)setPrimitiveTaxonId:(NSNumber*)value;

- (int32_t)primitiveTaxonIdValue;
- (void)setPrimitiveTaxonIdValue:(int32_t)value_;





- (INatTripTaxaAttribute*)primitiveTripTaxaAttribute;
- (void)setPrimitiveTripTaxaAttribute:(INatTripTaxaAttribute*)value;


@end
