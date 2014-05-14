// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTrip.m instead.

#import "_INatTrip.h"

const struct INatTripAttributes INatTripAttributes = {
	.body = @"body",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.title = @"title",
	.userId = @"userId",
};

const struct INatTripRelationships INatTripRelationships = {
	.taxa = @"taxa",
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
	if ([key isEqualToString:@"userIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic body;






@dynamic latitude;



- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}





@dynamic longitude;



- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}





@dynamic title;






@dynamic userId;



- (int16_t)userIdValue {
	NSNumber *result = [self userId];
	return [result shortValue];
}

- (void)setUserIdValue:(int16_t)value_ {
	[self setUserId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveUserIdValue {
	NSNumber *result = [self primitiveUserId];
	return [result shortValue];
}

- (void)setPrimitiveUserIdValue:(int16_t)value_ {
	[self setPrimitiveUserId:[NSNumber numberWithShort:value_]];
}





@dynamic taxa;

	
- (NSMutableSet*)taxaSet {
	[self willAccessValueForKey:@"taxa"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"taxa"];
  
	[self didAccessValueForKey:@"taxa"];
	return result;
}
	






@end
