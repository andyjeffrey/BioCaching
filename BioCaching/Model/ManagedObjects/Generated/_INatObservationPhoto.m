// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to INatObservationPhoto.m instead.

#import "_INatObservationPhoto.h"

const struct INatObservationPhotoAttributes INatObservationPhotoAttributes = {
	.createdAt = @"createdAt",
	.localAssetUrl = @"localAssetUrl",
	.localCreatedAt = @"localCreatedAt",
	.recordId = @"recordId",
	.syncedAt = @"syncedAt",
	.updatedAt = @"updatedAt",
};

const struct INatObservationPhotoRelationships INatObservationPhotoRelationships = {
	.observation = @"observation",
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
	
	if ([key isEqualToString:@"recordIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recordId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdAt;






@dynamic localAssetUrl;






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





@dynamic syncedAt;






@dynamic updatedAt;






@dynamic observation;

	






@end
