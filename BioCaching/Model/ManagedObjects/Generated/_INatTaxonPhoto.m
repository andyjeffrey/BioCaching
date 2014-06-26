// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatTaxonPhoto.m instead.

#import "_INatTaxonPhoto.h"

const struct INatTaxonPhotoAttributes INatTaxonPhotoAttributes = {
	.attribution = @"attribution",
	.largeUrl = @"largeUrl",
	.licenseCode = @"licenseCode",
	.mediumUrl = @"mediumUrl",
	.nativeRealname = @"nativeRealname",
	.nativeUsername = @"nativeUsername",
	.smallUrl = @"smallUrl",
	.squareUrl = @"squareUrl",
	.thumbUrl = @"thumbUrl",
};

const struct INatTaxonPhotoRelationships INatTaxonPhotoRelationships = {
	.taxon = @"taxon",
};

const struct INatTaxonPhotoFetchedProperties INatTaxonPhotoFetchedProperties = {
};

@implementation INatTaxonPhotoID
@end

@implementation _INatTaxonPhoto

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatTaxonPhoto" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatTaxonPhoto";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatTaxonPhoto" inManagedObjectContext:moc_];
}

- (INatTaxonPhotoID*)objectID {
	return (INatTaxonPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic attribution;






@dynamic largeUrl;






@dynamic licenseCode;






@dynamic mediumUrl;






@dynamic nativeRealname;






@dynamic nativeUsername;






@dynamic smallUrl;






@dynamic squareUrl;






@dynamic thumbUrl;






@dynamic taxon;

	
- (NSMutableSet*)taxonSet {
	[self willAccessValueForKey:@"taxon"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"taxon"];
  
	[self didAccessValueForKey:@"taxon"];
	return result;
}
	






@end
