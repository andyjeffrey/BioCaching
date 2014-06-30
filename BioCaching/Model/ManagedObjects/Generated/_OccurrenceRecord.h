// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OccurrenceRecord.h instead.

#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

extern const struct OccurrenceRecordAttributes {
	__unsafe_unretained NSString *dateRecorded;
	__unsafe_unretained NSString *gbifId;
	__unsafe_unretained NSString *institutionCode;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *recordSource;
	__unsafe_unretained NSString *recordType;
	__unsafe_unretained NSString *recordedBy;
	__unsafe_unretained NSString *taxonClass;
	__unsafe_unretained NSString *taxonFamily;
	__unsafe_unretained NSString *taxonGenus;
	__unsafe_unretained NSString *taxonKingdom;
	__unsafe_unretained NSString *taxonOrder;
	__unsafe_unretained NSString *taxonPhylum;
	__unsafe_unretained NSString *taxonSpecies;
} OccurrenceRecordAttributes;

extern const struct OccurrenceRecordRelationships {
	__unsafe_unretained NSString *iNatTaxon;
	__unsafe_unretained NSString *taxaAttribute;
} OccurrenceRecordRelationships;

extern const struct OccurrenceRecordFetchedProperties {
} OccurrenceRecordFetchedProperties;

@class INatTaxon;
@class INatTripTaxaAttribute;

















@interface OccurrenceRecordID : NSManagedObjectID {}
@end

@interface _OccurrenceRecord : BCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OccurrenceRecordID*)objectID;





@property (nonatomic, strong) NSDate* dateRecorded;



//- (BOOL)validateDateRecorded:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* gbifId;



@property int32_t gbifIdValue;
- (int32_t)gbifIdValue;
- (void)setGbifIdValue:(int32_t)value_;

//- (BOOL)validateGbifId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* institutionCode;



//- (BOOL)validateInstitutionCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* latitude;



//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* longitude;



//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recordSource;



//- (BOOL)validateRecordSource:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recordType;



//- (BOOL)validateRecordType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recordedBy;



//- (BOOL)validateRecordedBy:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonClass;



//- (BOOL)validateTaxonClass:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonFamily;



//- (BOOL)validateTaxonFamily:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonGenus;



//- (BOOL)validateTaxonGenus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonKingdom;



//- (BOOL)validateTaxonKingdom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonOrder;



//- (BOOL)validateTaxonOrder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonPhylum;



//- (BOOL)validateTaxonPhylum:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxonSpecies;



//- (BOOL)validateTaxonSpecies:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) INatTaxon *iNatTaxon;

//- (BOOL)validateINatTaxon:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) INatTripTaxaAttribute *taxaAttribute;

//- (BOOL)validateTaxaAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _OccurrenceRecord (CoreDataGeneratedAccessors)

@end

@interface _OccurrenceRecord (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDateRecorded;
- (void)setPrimitiveDateRecorded:(NSDate*)value;




- (NSNumber*)primitiveGbifId;
- (void)setPrimitiveGbifId:(NSNumber*)value;

- (int32_t)primitiveGbifIdValue;
- (void)setPrimitiveGbifIdValue:(int32_t)value_;




- (NSString*)primitiveInstitutionCode;
- (void)setPrimitiveInstitutionCode:(NSString*)value;




- (NSDecimalNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSDecimalNumber*)value;




- (NSDecimalNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSDecimalNumber*)value;




- (NSString*)primitiveRecordSource;
- (void)setPrimitiveRecordSource:(NSString*)value;




- (NSString*)primitiveRecordType;
- (void)setPrimitiveRecordType:(NSString*)value;




- (NSString*)primitiveRecordedBy;
- (void)setPrimitiveRecordedBy:(NSString*)value;




- (NSString*)primitiveTaxonClass;
- (void)setPrimitiveTaxonClass:(NSString*)value;




- (NSString*)primitiveTaxonFamily;
- (void)setPrimitiveTaxonFamily:(NSString*)value;




- (NSString*)primitiveTaxonGenus;
- (void)setPrimitiveTaxonGenus:(NSString*)value;




- (NSString*)primitiveTaxonKingdom;
- (void)setPrimitiveTaxonKingdom:(NSString*)value;




- (NSString*)primitiveTaxonOrder;
- (void)setPrimitiveTaxonOrder:(NSString*)value;




- (NSString*)primitiveTaxonPhylum;
- (void)setPrimitiveTaxonPhylum:(NSString*)value;




- (NSString*)primitiveTaxonSpecies;
- (void)setPrimitiveTaxonSpecies:(NSString*)value;





- (INatTaxon*)primitiveINatTaxon;
- (void)setPrimitiveINatTaxon:(INatTaxon*)value;



- (INatTripTaxaAttribute*)primitiveTaxaAttribute;
- (void)setPrimitiveTaxaAttribute:(INatTripTaxaAttribute*)value;


@end
