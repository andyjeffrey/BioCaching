// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BCManagedObject.m instead.

#import "_BCManagedObject.h"

const struct BCManagedObjectAttributes BCManagedObjectAttributes = {
	.createdAt = @"createdAt",
	.localCreatedAt = @"localCreatedAt",
	.recordId = @"recordId",
	.synchedAt = @"synchedAt",
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
	
	if ([key isEqualToString:@"recordIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recordId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdAt;






@dynamic localCreatedAt;






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





@dynamic synchedAt;






@dynamic updatedAt;











@end
