// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTripTaxon.m instead.

#import "_INatTripTaxon.h"

const struct INatTripTaxonAttributes INatTripTaxonAttributes = {
	.name = @"name",
	.observed = @"observed",
};

const struct INatTripTaxonRelationships INatTripTaxonRelationships = {
	.trip = @"trip",
};

const struct INatTripTaxonFetchedProperties INatTripTaxonFetchedProperties = {
};

@implementation INatTripTaxonID
@end

@implementation _INatTripTaxon

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxon" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatTripTaxon";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatTripTaxon" inManagedObjectContext:moc_];
}

- (INatTripTaxonID*)objectID {
	return (INatTripTaxonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"observedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"observed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






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





@dynamic trip;

	






@end
