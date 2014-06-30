// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTaxon.m instead.

#import "_INatTaxon.h"

const struct INatTaxonAttributes INatTaxonAttributes = {
	.commonName = @"commonName",
	.name = @"name",
	.searchName = @"searchName",
	.squareImageUrl = @"squareImageUrl",
	.summaryText = @"summaryText",
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
	

	return keyPaths;
}




@dynamic commonName;






@dynamic name;






@dynamic searchName;






@dynamic squareImageUrl;






@dynamic summaryText;






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
