// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTripTaxon.h instead.

#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

extern const struct INatTripTaxonAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *observed;
} INatTripTaxonAttributes;

extern const struct INatTripTaxonRelationships {
	__unsafe_unretained NSString *trip;
} INatTripTaxonRelationships;

extern const struct INatTripTaxonFetchedProperties {
} INatTripTaxonFetchedProperties;

@class INatTrip;




@interface INatTripTaxonID : NSManagedObjectID {}
@end

@interface _INatTripTaxon : BCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTripTaxonID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* observed;



@property BOOL observedValue;
- (BOOL)observedValue;
- (void)setObservedValue:(BOOL)value_;

//- (BOOL)validateObserved:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) INatTrip *trip;

//- (BOOL)validateTrip:(id*)value_ error:(NSError**)error_;





@end

@interface _INatTripTaxon (CoreDataGeneratedAccessors)

@end

@interface _INatTripTaxon (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveObserved;
- (void)setPrimitiveObserved:(NSNumber*)value;

- (BOOL)primitiveObservedValue;
- (void)setPrimitiveObservedValue:(BOOL)value_;





- (INatTrip*)primitiveTrip;
- (void)setPrimitiveTrip:(INatTrip*)value;


@end
