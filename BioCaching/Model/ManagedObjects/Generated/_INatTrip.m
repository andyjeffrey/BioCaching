// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTrip.m instead.

#import "_INatTrip.h"

const struct INatTripAttributes INatTripAttributes = {
	.body = @"body",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.placeId = @"placeId",
	.positionalAccuracy = @"positionalAccuracy",
	.startTime = @"startTime",
	.status = @"status",
	.stopTime = @"stopTime",
	.title = @"title",
	.userId = @"userId",
};

const struct INatTripRelationships INatTripRelationships = {
	.taxaAttributes = @"taxaAttributes",
	.taxaPurposes = @"taxaPurposes",
};

const struct INatTripFetchedProperties INatTripFetchedProperties = {
};

@implementation INatTripID
@end

@implementation _INatTrip

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatTrip" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatTrip";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatTrip" inManagedObjectContext:moc_];
}

- (INatTripID*)objectID {
	return (INatTripID*)[super objectID];
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
	if ([key isEqualToString:@"placeIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"placeId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"positionalAccuracyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"positionalAccuracy"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"userIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic body;






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





@dynamic placeId;



- (int32_t)placeIdValue {
	NSNumber *result = [self placeId];
	return [result intValue];
}

- (void)setPlaceIdValue:(int32_t)value_ {
	[self setPlaceId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePlaceIdValue {
	NSNumber *result = [self primitivePlaceId];
	return [result intValue];
}

- (void)setPrimitivePlaceIdValue:(int32_t)value_ {
	[self setPrimitivePlaceId:[NSNumber numberWithInt:value_]];
}





@dynamic positionalAccuracy;



- (int32_t)positionalAccuracyValue {
	NSNumber *result = [self positionalAccuracy];
	return [result intValue];
}

- (void)setPositionalAccuracyValue:(int32_t)value_ {
	[self setPositionalAccuracy:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePositionalAccuracyValue {
	NSNumber *result = [self primitivePositionalAccuracy];
	return [result intValue];
}

- (void)setPrimitivePositionalAccuracyValue:(int32_t)value_ {
	[self setPrimitivePositionalAccuracy:[NSNumber numberWithInt:value_]];
}





@dynamic startTime;






@dynamic status;



- (int32_t)statusValue {
	NSNumber *result = [self status];
	return [result intValue];
}

- (void)setStatusValue:(int32_t)value_ {
	[self setStatus:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusValue {
	NSNumber *result = [self primitiveStatus];
	return [result intValue];
}

- (void)setPrimitiveStatusValue:(int32_t)value_ {
	[self setPrimitiveStatus:[NSNumber numberWithInt:value_]];
}





@dynamic stopTime;






@dynamic title;






@dynamic userId;



- (int32_t)userIdValue {
	NSNumber *result = [self userId];
	return [result intValue];
}

- (void)setUserIdValue:(int32_t)value_ {
	[self setUserId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveUserIdValue {
	NSNumber *result = [self primitiveUserId];
	return [result intValue];
}

- (void)setPrimitiveUserIdValue:(int32_t)value_ {
	[self setPrimitiveUserId:[NSNumber numberWithInt:value_]];
}





@dynamic taxaAttributes;

	
- (NSMutableSet*)taxaAttributesSet {
	[self willAccessValueForKey:@"taxaAttributes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"taxaAttributes"];
  
	[self didAccessValueForKey:@"taxaAttributes"];
	return result;
}
	

@dynamic taxaPurposes;

	
- (NSMutableSet*)taxaPurposesSet {
	[self willAccessValueForKey:@"taxaPurposes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"taxaPurposes"];
  
	[self didAccessValueForKey:@"taxaPurposes"];
	return result;
}
	






@end
