//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripOptions.h"

#define kDefaultSearchAreaSpan 1000
#define kDefaultDisplayPoints 50
#define kDefaultFullSpeciesNames FALSE
#define kDefaultUniqueSpecies FALSE
#define kDefaultUniqueLocations FALSE

@implementation TripOptions

+(id)initWithDefaults
{
    TripOptions *tripOptions = [[TripOptions alloc] init];
    
    tripOptions.searchAreaSpan = kDefaultSearchAreaSpan;
    tripOptions.displayPoints = kDefaultDisplayPoints;
    
    tripOptions.recordType = RecordType_ALL;
    tripOptions.recordSource = RecordSource_ALL;
    tripOptions.speciesFilter = SpeciesFilter_ALL;
    tripOptions.collectorName = @"";
    tripOptions.year = @"";
    tripOptions.yearFrom = @"";
    tripOptions.yearTo = @"";
    tripOptions.fullSpeciesNames = kDefaultFullSpeciesNames;
    tripOptions.uniqueSpecies = kDefaultUniqueSpecies;
    tripOptions.uniqueLocations = kDefaultUniqueLocations;
    
    return tripOptions;
    
}

@end
