// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTrip.h instead.

#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

extern const struct INatTripAttributes {
	__unsafe_unretained NSString *body;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *userId;
} INatTripAttributes;

extern const struct INatTripRelationships {
	__unsafe_unretained NSString *taxa;
} INatTripRelationships;

extern const struct INatTripFetchedProperties {
} INatTripFetchedProperties;

@class INatTripTaxon;







@interface INatTripID : NSManagedObjectID {}
@end

@interface _INatTrip : BCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (INatTripID*)objectID;





@property (nonatomic, strong) NSString* body;



//- (BOOL)validateBody:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userId;



@property int16_t userIdValue;
- (int16_t)userIdValue;
- (void)setUserIdValue:(int16_t)value_;

//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *taxa;

- (NSMutableSet*)taxaSet;





@end

@interface _INatTrip (CoreDataGeneratedAccessors)

- (void)addTaxa:(NSSet*)value_;
- (void)removeTaxa:(NSSet*)value_;
- (void)addTaxaObject:(INatTripTaxon*)value_;
- (void)removeTaxaObject:(INatTripTaxon*)value_;

@end

@interface _INatTrip (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBody;
- (void)setPrimitiveBody:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSNumber*)primitiveUserId;
- (void)setPrimitiveUserId:(NSNumber*)value;

- (int16_t)primitiveUserIdValue;
- (void)setPrimitiveUserIdValue:(int16_t)value_;





- (NSMutableSet*)primitiveTaxa;
- (void)setPrimitiveTaxa:(NSMutableSet*)value;


@end
