// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTripTaxaAttribute.h instead.

#import <CoreData/CoreData.h>


extern const struct INatTripTaxaAttributeAttributes {
	__unsafe_unretained NSString *observed;
	__unsafe_unretained NSString *taxonId;
} INatTripTaxaAttributeAttributes;

extern const struct INatTripTaxaAttributeRelationships {
	__unsafe_unretained NSString *observation;
	__unsafe_unretained NSString *occurrence;
	__unsafe_unretained NSString *trip;
} INatTripTaxaAttributeRelationships;

extern const struct INatTripTaxaAttributeFetchedProperties {
} INatTripTaxaAttributeFetchedProperties;

@class INatObservation;
@class OccurrenceRecord;
@class INatTrip;




@interface INatTripTaxaAttributeID : NSManagedObjectID {}
@end

@interface _INatTripTaxaAttribute : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTripTaxaAttributeID*)objectID;





@property (nonatomic, strong) NSNumber* observed;



@property BOOL observedValue;
- (BOOL)observedValue;
- (void)setObservedValue:(BOOL)value_;

//- (BOOL)validateObserved:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* taxonId;



@property int32_t taxonIdValue;
- (int32_t)taxonIdValue;
- (void)setTaxonIdValue:(int32_t)value_;

//- (BOOL)validateTaxonId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) INatObservation *observation;

//- (BOOL)validateObservation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OccurrenceRecord *occurrence;

//- (BOOL)validateOccurrence:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) INatTrip *trip;

//- (BOOL)validateTrip:(id*)value_ error:(NSError**)error_;





@end

@interface _INatTripTaxaAttribute (CoreDataGeneratedAccessors)

@end

@interface _INatTripTaxaAttribute (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveObserved;
- (void)setPrimitiveObserved:(NSNumber*)value;

- (BOOL)primitiveObservedValue;
- (void)setPrimitiveObservedValue:(BOOL)value_;




- (NSNumber*)primitiveTaxonId;
- (void)setPrimitiveTaxonId:(NSNumber*)value;

- (int32_t)primitiveTaxonIdValue;
- (void)setPrimitiveTaxonIdValue:(int32_t)value_;





- (INatObservation*)primitiveObservation;
- (void)setPrimitiveObservation:(INatObservation*)value;



- (OccurrenceRecord*)primitiveOccurrence;
- (void)setPrimitiveOccurrence:(OccurrenceRecord*)value;



- (INatTrip*)primitiveTrip;
- (void)setPrimitiveTrip:(INatTrip*)value;


@end
