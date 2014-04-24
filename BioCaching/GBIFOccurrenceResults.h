//
//  GBIFOccurenceResults.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrence.h"
#import "DisplayOptions.h"

@interface GBIFOccurrenceResults : NSObject

@property(nonatomic,strong) NSNumber * Offset;
@property(nonatomic,strong) NSNumber * Limit;
@property(nonatomic,strong) NSString * EndOfRecords;
@property(nonatomic,strong) NSNumber * Count;
@property(nonatomic,strong) NSMutableArray * Results;

//@property (nonatomic, strong) TripOptions *tripOptions;
//@property (nonatomic, strong) NSDictionary *speciesDictionary;
/*
@property (nonatomic, readonly, strong) NSCountedSet *recordTypeCounts;
@property (nonatomic, readonly, strong) NSCountedSet *recordSourceCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonSpeciesCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonKingdomCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonPhylumCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonClassCounts;
*/
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
//@property (nonatomic, readonly, strong) NSMutableSet *speciesUnique;
//@property (nonatomic, readonly, strong) NSMutableSet *locationsUnique;

- (NSArray *) getFilteredResults:(DisplayOptions *)displayOptions limitToMapPoints:(BOOL)mapPoints;

+ (id) objectWithDictionary:(NSDictionary *)dictionary;
- (id) initWithDictionary:(NSDictionary *)dictionary;

@end


