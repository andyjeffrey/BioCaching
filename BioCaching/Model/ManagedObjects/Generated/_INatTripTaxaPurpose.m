// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTripTaxaPurpose.m instead.

#import "_INatTripTaxaPurpose.h"

const struct INatTripTaxaPurposeAttributes INatTripTaxaPurposeAttributes = {
	.complete = @"complete",
	.resourceId = @"resourceId",
	.resourceType = @"resourceType",
};

const struct INatTripTaxaPurposeRelationships INatTripTaxaPurposeRelationships = {
	.trip = @"trip",
};

const struct INatTripTaxaPurposeFetchedProperties INatTripTaxaPurposeFetchedProperties = {
};

@implementation INatTripTaxaPurposeID
@end

@implementation _INatTripTaxaPurpose

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxaPurpose" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatTripTaxaPurpose";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatTripTaxaPurpose" inManagedObjectContext:moc_];
}

- (INatTripTaxaPurposeID*)objectID {
	return (INatTripTaxaPurposeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"completeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"complete"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"resourceIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"resourceId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic complete;



- (BOOL)completeValue {
	NSNumber *result = [self complete];
	return [result boolValue];
}

- (void)setCompleteValue:(BOOL)value_ {
	[self setComplete:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveCompleteValue {
	NSNumber *result = [self primitiveComplete];
	return [result boolValue];
}

- (void)setPrimitiveCompleteValue:(BOOL)value_ {
	[self setPrimitiveComplete:[NSNumber numberWithBool:value_]];
}





@dynamic resourceId;



- (int32_t)resourceIdValue {
	NSNumber *result = [self resourceId];
	return [result intValue];
}

- (void)setResourceIdValue:(int32_t)value_ {
	[self setResourceId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveResourceIdValue {
	NSNumber *result = [self primitiveResourceId];
	return [result intValue];
}

- (void)setPrimitiveResourceIdValue:(int32_t)value_ {
	[self setPrimitiveResourceId:[NSNumber numberWithInt:value_]];
}





@dynamic resourceType;






@dynamic trip;

	






@end
