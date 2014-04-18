//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripOptions.h"

@implementation TripOptions

+(id)initWithDefaults
{
    TripOptions *tripOptions = [[TripOptions alloc] init];

    tripOptions.searchAreaSpan = kOptionsDefaultSearchAreaSpan;
    tripOptions.recordType = RecordType_PRESERVED_SPECIMEN;
    tripOptions.recordSource = RecordSource_ALL;
    tripOptions.speciesFilter = SpeciesFilter_ALL;
    tripOptions.collectorName = @"";
    tripOptions.year = @"";
    tripOptions.yearFrom = @"";
    tripOptions.yearTo = @"";
    
    tripOptions.displayPoints = kOptionsDefaultDisplayPoints;
    tripOptions.uniqueSpecies = kOptionsDefaultUniqueSpecies;
    tripOptions.uniqueLocations = kOptionsDefaultUniqueLocations;
    tripOptions.fullSpeciesNames = kOptionsDefaultFullSpeciesNames;

    tripOptions.testGBIFData = NO;
    
    return tripOptions;
    
}

@end
