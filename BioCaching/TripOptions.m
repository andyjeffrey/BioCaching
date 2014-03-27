//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripOptions.h"

#define kDefaultDisplayPoints 100
#define kDefaultFullSpeciesNames FALSE
#define kDefaultUniqueSpecies FALSE
#define kDefaultUniqueLocations FALSE

@implementation TripOptions

+(id)initWithDefaults
{
    TripOptions *tripOptions = [[TripOptions alloc] init];

    tripOptions.recordType = RecordType_ALL;
    tripOptions.recordSource = RecordSource_ALL;
    tripOptions.speciesFilter = SpeciesFilter_ALL;
    tripOptions.collectorName = @"";
    tripOptions.year = @"";
    tripOptions.yearFrom = @"";
    tripOptions.yearTo = @"";
    
    tripOptions.displayPoints = kDefaultDisplayPoints;
    tripOptions.uniqueSpecies = kDefaultUniqueSpecies;
    tripOptions.uniqueLocations = kDefaultUniqueLocations;
    tripOptions.fullSpeciesNames = kDefaultFullSpeciesNames;
    
    return tripOptions;
    
}

@end
