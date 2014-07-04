// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatObservation.m instead.

#import "_INatObservation.h"

const struct INatObservationAttributes INatObservationAttributes = {
	.dateRecorded = @"dateRecorded",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.notes = @"notes",
	.taxonId = @"taxonId",
};

const struct INatObservationRelationships INatObservationRelationships = {
	.tripTaxaAttribute = @"tripTaxaAttribute",
};

const struct INatObservationFetchedProperties INatObservationFetchedProperties = {
};

@implementation INatObservationID
@end

@implementation _INatObservation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatObservation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatObservation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatObservation" inManagedObjectContext:moc_];
}

- (INatObservationID*)objectID {
	return (INatObservationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"taxonIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"taxonId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic dateRecorded;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic notes;






@dynamic taxonId;



- (int32_t)taxonIdValue {
	NSNumber *result = [self taxonId];
	return [result intValue];
}

- (void)setTaxonIdValue:(int32_t)value_ {
	[self setTaxonId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTaxonIdValue {
	NSNumber *result = [self primitiveTaxonId];
	return [result intValue];
}

- (void)setPrimitiveTaxonIdValue:(int32_t)value_ {
	[self setPrimitiveTaxonId:[NSNumber numberWithInt:value_]];
}





@dynamic tripTaxaAttribute;

	






@end
