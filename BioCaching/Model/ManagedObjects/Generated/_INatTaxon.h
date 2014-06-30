// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTaxon.h instead.

#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

extern const struct INatTaxonAttributes {
	__unsafe_unretained NSString *commonName;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *searchName;
	__unsafe_unretained NSString *squareImageUrl;
	__unsafe_unretained NSString *summaryText;
} INatTaxonAttributes;

extern const struct INatTaxonRelationships {
	__unsafe_unretained NSString *occurrences;
	__unsafe_unretained NSString *taxonPhotos;
} INatTaxonRelationships;

extern const struct INatTaxonFetchedProperties {
} INatTaxonFetchedProperties;

@class OccurrenceRecord;
@class INatTaxonPhoto;







@interface INatTaxonID : NSManagedObjectID {}
@end

@interface _INatTaxon : BCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTaxonID*)objectID;





@property (nonatomic, strong) NSString* commonName;



//- (BOOL)validateCommonName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* searchName;



//- (BOOL)validateSearchName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* squareImageUrl;



//- (BOOL)validateSquareImageUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* summaryText;



//- (BOOL)validateSummaryText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *occurrences;

- (NSMutableSet*)occurrencesSet;




@property (nonatomic, strong) NSOrderedSet *taxonPhotos;

- (NSMutableOrderedSet*)taxonPhotosSet;





@end

@interface _INatTaxon (CoreDataGeneratedAccessors)

- (void)addOccurrences:(NSSet*)value_;
- (void)removeOccurrences:(NSSet*)value_;
- (void)addOccurrencesObject:(OccurrenceRecord*)value_;
- (void)removeOccurrencesObject:(OccurrenceRecord*)value_;

- (void)addTaxonPhotos:(NSOrderedSet*)value_;
- (void)removeTaxonPhotos:(NSOrderedSet*)value_;
- (void)addTaxonPhotosObject:(INatTaxonPhoto*)value_;
- (void)removeTaxonPhotosObject:(INatTaxonPhoto*)value_;

@end

@interface _INatTaxon (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCommonName;
- (void)setPrimitiveCommonName:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveSearchName;
- (void)setPrimitiveSearchName:(NSString*)value;




- (NSString*)primitiveSquareImageUrl;
- (void)setPrimitiveSquareImageUrl:(NSString*)value;




- (NSString*)primitiveSummaryText;
- (void)setPrimitiveSummaryText:(NSString*)value;





- (NSMutableSet*)primitiveOccurrences;
- (void)setPrimitiveOccurrences:(NSMutableSet*)value;



- (NSMutableOrderedSet*)primitiveTaxonPhotos;
- (void)setPrimitiveTaxonPhotos:(NSMutableOrderedSet*)value;


@end
