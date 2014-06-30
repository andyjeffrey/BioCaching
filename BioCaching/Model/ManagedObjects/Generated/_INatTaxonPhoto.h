// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTaxonPhoto.h instead.

#import <CoreData/CoreData.h>


extern const struct INatTaxonPhotoAttributes {
	__unsafe_unretained NSString *attribution;
	__unsafe_unretained NSString *largeUrl;
	__unsafe_unretained NSString *licenseCode;
	__unsafe_unretained NSString *mediumUrl;
	__unsafe_unretained NSString *nativeRealname;
	__unsafe_unretained NSString *nativeUsername;
	__unsafe_unretained NSString *smallUrl;
	__unsafe_unretained NSString *squareUrl;
	__unsafe_unretained NSString *thumbUrl;
} INatTaxonPhotoAttributes;

extern const struct INatTaxonPhotoRelationships {
	__unsafe_unretained NSString *taxon;
} INatTaxonPhotoRelationships;

extern const struct INatTaxonPhotoFetchedProperties {
} INatTaxonPhotoFetchedProperties;

@class INatTaxon;











@interface INatTaxonPhotoID : NSManagedObjectID {}
@end

@interface _INatTaxonPhoto : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTaxonPhotoID*)objectID;





@property (nonatomic, strong) NSString* attribution;



//- (BOOL)validateAttribution:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* largeUrl;



//- (BOOL)validateLargeUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* licenseCode;



//- (BOOL)validateLicenseCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mediumUrl;



//- (BOOL)validateMediumUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nativeRealname;



//- (BOOL)validateNativeRealname:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nativeUsername;



//- (BOOL)validateNativeUsername:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* smallUrl;



//- (BOOL)validateSmallUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* squareUrl;



//- (BOOL)validateSquareUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thumbUrl;



//- (BOOL)validateThumbUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *taxon;

- (NSMutableSet*)taxonSet;





@end

@interface _INatTaxonPhoto (CoreDataGeneratedAccessors)

- (void)addTaxon:(NSSet*)value_;
- (void)removeTaxon:(NSSet*)value_;
- (void)addTaxonObject:(INatTaxon*)value_;
- (void)removeTaxonObject:(INatTaxon*)value_;

@end

@interface _INatTaxonPhoto (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAttribution;
- (void)setPrimitiveAttribution:(NSString*)value;




- (NSString*)primitiveLargeUrl;
- (void)setPrimitiveLargeUrl:(NSString*)value;




- (NSString*)primitiveLicenseCode;
- (void)setPrimitiveLicenseCode:(NSString*)value;




- (NSString*)primitiveMediumUrl;
- (void)setPrimitiveMediumUrl:(NSString*)value;




- (NSString*)primitiveNativeRealname;
- (void)setPrimitiveNativeRealname:(NSString*)value;




- (NSString*)primitiveNativeUsername;
- (void)setPrimitiveNativeUsername:(NSString*)value;




- (NSString*)primitiveSmallUrl;
- (void)setPrimitiveSmallUrl:(NSString*)value;




- (NSString*)primitiveSquareUrl;
- (void)setPrimitiveSquareUrl:(NSString*)value;




- (NSString*)primitiveThumbUrl;
- (void)setPrimitiveThumbUrl:(NSString*)value;





- (NSMutableSet*)primitiveTaxon;
- (void)setPrimitiveTaxon:(NSMutableSet*)value;


@end
