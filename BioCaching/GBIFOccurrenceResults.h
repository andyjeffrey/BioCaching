//
//  GBIFOccurenceResults.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrence.h"

@interface GBIFOccurrenceResults : NSObject

@property(nonatomic,strong) NSNumber * Offset;
@property(nonatomic,strong) NSNumber * Limit;
@property(nonatomic,strong) NSString * EndOfRecords;
@property(nonatomic,strong) NSNumber * Count;
@property(nonatomic,strong) NSMutableArray * Results;

//@property (nonatomic, strong) NSDictionary *speciesDictionary;
@property (nonatomic, readonly, strong) NSCountedSet *recordTypeCounts;
@property (nonatomic, readonly, strong) NSCountedSet *recordSourceCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonSpeciesCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonKingdomCounts;
@property (nonatomic, readonly, strong) NSCountedSet *taxonClassCounts;

@property (nonatomic, readonly, strong) NSMutableSet *fullSpeciesBinomial;
@property (nonatomic, readonly, strong) NSMutableSet *speciesUnique;
@property (nonatomic, readonly, strong) NSMutableSet *locationsUnique;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end


