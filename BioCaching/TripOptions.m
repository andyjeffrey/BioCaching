//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripOptions.h"

#define kDefaultSearchAreaSpan 1000
#define kDefaultDisplayPoints 20
#define kDefaultFullSpeciesNames YES
#define kDefaultUniqueSpecies YES
#define kDefaultUniqueLocations YES

@implementation TripOptions

+(id)initWithDefaults
{
    TripOptions *tripOptions = [[TripOptions alloc] init];

    tripOptions.searchAreaSpan = kDefaultSearchAreaSpan;
    tripOptions.recordType = RecordType_PRESERVED_SPECIMEN;
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

    tripOptions.testGBIFData = NO;
    
    return tripOptions;
    
}

@end
