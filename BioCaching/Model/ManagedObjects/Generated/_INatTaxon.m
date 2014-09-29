// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTaxon.m instead.

#import "_INatTaxon.h"

const struct INatTaxonAttributes INatTaxonAttributes = {
	.commonName = @"commonName",
	.createdAt = @"createdAt",
	.localCreatedAt = @"localCreatedAt",
	.name = @"name",
	.recordId = @"recordId",
	.searchName = @"searchName",
	.squareImageUrl = @"squareImageUrl",
	.summaryText = @"summaryText",
	.updatedAt = @"updatedAt",
};

const struct INatTaxonRelationships INatTaxonRelationships = {
	.occurrences = @"occurrences",
	.taxonPhotos = @"taxonPhotos",
};

const struct INatTaxonFetchedProperties INatTaxonFetchedProperties = {
};

@implementation INatTaxonID
@end

@implementation _INatTaxon

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatTaxon" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatTaxon";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatTaxon" inManagedObjectContext:moc_];
}

- (INatTaxonID*)objectID {
	return (INatTaxonID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"recordIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recordId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic commonName;






@dynamic createdAt;






@dynamic localCreatedAt;






@dynamic name;






@dynamic recordId;



- (int32_t)recordIdValue {
	NSNumber *result = [self recordId];
	return [result intValue];
}

- (void)setRecordIdValue:(int32_t)value_ {
	[self setRecordId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRecordIdValue {
	NSNumber *result = [self primitiveRecordId];
	return [result intValue];
}

- (void)setPrimitiveRecordIdValue:(int32_t)value_ {
	[self setPrimitiveRecordId:[NSNumber numberWithInt:value_]];
}





@dynamic searchName;






@dynamic squareImageUrl;






@dynamic summaryText;






@dynamic updatedAt;






@dynamic occurrences;

	
- (NSMutableSet*)occurrencesSet {
	[self willAccessValueForKey:@"occurrences"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"occurrences"];
  
	[self didAccessValueForKey:@"occurrences"];
	return result;
}
	

@dynamic taxonPhotos;

	
- (NSMutableOrderedSet*)taxonPhotosSet {
	[self willAccessValueForKey:@"taxonPhotos"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"taxonPhotos"];
  
	[self didAccessValueForKey:@"taxonPhotos"];
	return result;
}
	






@end
