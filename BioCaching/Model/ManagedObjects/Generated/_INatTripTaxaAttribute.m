// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTripTaxaAttribute.m instead.

#import "_INatTripTaxaAttribute.h"

const struct INatTripTaxaAttributeAttributes INatTripTaxaAttributeAttributes = {
	.observed = @"observed",
	.taxonId = @"taxonId",
};

const struct INatTripTaxaAttributeRelationships INatTripTaxaAttributeRelationships = {
	.observation = @"observation",
	.occurrence = @"occurrence",
	.trip = @"trip",
};

const struct INatTripTaxaAttributeFetchedProperties INatTripTaxaAttributeFetchedProperties = {
};

@implementation INatTripTaxaAttributeID
@end

@implementation _INatTripTaxaAttribute

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxaAttribute" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatTripTaxaAttribute";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatTripTaxaAttribute" inManagedObjectContext:moc_];
}

- (INatTripTaxaAttributeID*)objectID {
	return (INatTripTaxaAttributeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"observedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"observed"];
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




@dynamic observed;



- (BOOL)observedValue {
	NSNumber *result = [self observed];
	return [result boolValue];
}

- (void)setObservedValue:(BOOL)value_ {
	[self setObserved:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveObservedValue {
	NSNumber *result = [self primitiveObserved];
	return [result boolValue];
}

- (void)setPrimitiveObservedValue:(BOOL)value_ {
	[self setPrimitiveObserved:[NSNumber numberWithBool:value_]];
}





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





@dynamic observation;

	

@dynamic occurrence;

	

@dynamic trip;

	






@end
