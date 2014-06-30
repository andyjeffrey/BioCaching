// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OccurrenceRecord.m instead.

#import "_OccurrenceRecord.h"

const struct OccurrenceRecordAttributes OccurrenceRecordAttributes = {
	.dateRecorded = @"dateRecorded",
	.gbifId = @"gbifId",
	.institutionCode = @"institutionCode",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.recordSource = @"recordSource",
	.recordType = @"recordType",
	.recordedBy = @"recordedBy",
	.taxonClass = @"taxonClass",
	.taxonFamily = @"taxonFamily",
	.taxonGenus = @"taxonGenus",
	.taxonKingdom = @"taxonKingdom",
	.taxonOrder = @"taxonOrder",
	.taxonPhylum = @"taxonPhylum",
	.taxonSpecies = @"taxonSpecies",
};

const struct OccurrenceRecordRelationships OccurrenceRecordRelationships = {
	.iNatTaxon = @"iNatTaxon",
	.taxaAttribute = @"taxaAttribute",
};

const struct OccurrenceRecordFetchedProperties OccurrenceRecordFetchedProperties = {
};

@implementation OccurrenceRecordID
@end

@implementation _OccurrenceRecord

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OccurrenceRecord" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OccurrenceRecord";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OccurrenceRecord" inManagedObjectContext:moc_];
}

- (OccurrenceRecordID*)objectID {
	return (OccurrenceRecordID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"gbifIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gbifId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic dateRecorded;






@dynamic gbifId;



- (int32_t)gbifIdValue {
	NSNumber *result = [self gbifId];
	return [result intValue];
}

- (void)setGbifIdValue:(int32_t)value_ {
	[self setGbifId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveGbifIdValue {
	NSNumber *result = [self primitiveGbifId];
	return [result intValue];
}

- (void)setPrimitiveGbifIdValue:(int32_t)value_ {
	[self setPrimitiveGbifId:[NSNumber numberWithInt:value_]];
}





@dynamic institutionCode;






@dynamic latitude;






@dynamic longitude;






@dynamic recordSource;






@dynamic recordType;






@dynamic recordedBy;






@dynamic taxonClass;






@dynamic taxonFamily;






@dynamic taxonGenus;






@dynamic taxonKingdom;






@dynamic taxonOrder;






@dynamic taxonPhylum;






@dynamic taxonSpecies;






@dynamic iNatTaxon;

	

@dynamic taxaAttribute;

	






@end
