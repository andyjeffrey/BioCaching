// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BCManagedObject.m instead.

#import "_BCManagedObject.h"

const struct BCManagedObjectAttributes BCManagedObjectAttributes = {
	.createdAt = @"createdAt",
	.objectId = @"objectId",
	.updatedAt = @"updatedAt",
};

const struct BCManagedObjectRelationships BCManagedObjectRelationships = {
};

const struct BCManagedObjectFetchedProperties BCManagedObjectFetchedProperties = {
};

@implementation BCManagedObjectID
@end

@implementation _BCManagedObject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BCManagedObject" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BCManagedObject";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BCManagedObject" inManagedObjectContext:moc_];
}

- (BCManagedObjectID*)objectID {
	return (BCManagedObjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic createdAt;






@dynamic objectId;






@dynamic updatedAt;











@end
