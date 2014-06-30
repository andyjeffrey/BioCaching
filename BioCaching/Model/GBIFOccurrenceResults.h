//
//  GBIFOccurenceResults.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrence.h"
#import "BCOptions.h"

@interface GBIFOccurrenceResults : NSObject

// Generated With JsonPack - http://jsonpack.com/ModelGenerators/ObjectiveC
#pragma mark - JsonPack Generated Properties
@property(nonatomic,strong) NSNumber * Offset;
@property(nonatomic,strong) NSNumber * Limit;
@property(nonatomic,strong) NSString * EndOfRecords;
@property(nonatomic,strong) NSNumber * Count;
@property(nonatomic,strong) NSMutableArray * Results;

#pragma mark - Additional Properties
@property (nonatomic, strong) BCOptions *bcOptions;
@property (nonatomic, readonly, strong) NSDictionary *dictRecordSource;
@property (nonatomic, readonly, strong) NSDictionary *dictRecordType;
@property (nonatomic, readonly, strong) NSDictionary *dictTaxonSpecies;
@property (nonatomic, readonly, strong) NSDictionary *dictTaxonKingdom;
@property (nonatomic, readonly, strong) NSDictionary *dictTaxonPhylum;
@property (nonatomic, readonly, strong) NSDictionary *dictTaxonClass;
@property (nonatomic, readonly, strong) NSDictionary *dictRecordLocation;

@property (nonatomic, readonly, strong) NSArray *fullSpeciesBinomial;
@property (nonatomic, readonly, strong) NSArray *uniqueSpecies;
@property (nonatomic, readonly, strong) NSArray *uniqueLocations;

@property (nonatomic, strong) NSMutableSet *removedResults;

@property (nonatomic, strong) NSArray *filteredResults;
@property (nonatomic, strong) NSArray *tripListResults;

#pragma mark - JsonPack Generated Methods
+ (id) objectWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary;

#pragma mark - Additional/Convenience Methods
- (NSArray *) getFilteredResults:(BOOL)limitToDisplayPoints;

@end


