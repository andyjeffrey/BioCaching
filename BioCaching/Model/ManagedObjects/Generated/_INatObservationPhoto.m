// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatObservationPhoto.m instead.

#import "_INatObservationPhoto.h"

const struct INatObservationPhotoAttributes INatObservationPhotoAttributes = {
};

const struct INatObservationPhotoRelationships INatObservationPhotoRelationships = {
};

const struct INatObservationPhotoFetchedProperties INatObservationPhotoFetchedProperties = {
};

@implementation INatObservationPhotoID
@end

@implementation _INatObservationPhoto

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"INatObservationPhoto" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"INatObservationPhoto";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"INatObservationPhoto" inManagedObjectContext:moc_];
}

- (INatObservationPhotoID*)objectID {
	return (INatObservationPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
