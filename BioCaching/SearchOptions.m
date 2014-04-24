//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "SearchOptions.h"

@implementation SearchOptions

+(id)initWithDefaults
{
    SearchOptions *searchOptions = [[SearchOptions alloc] init];

    searchOptions.searchAreaSpan = kOptionsDefaultSearchAreaSpan;
    searchOptions.recordType = RecordType_PRESERVED_SPECIMEN;
    searchOptions.recordSource = RecordSource_ALL;
    searchOptions.speciesFilter = SpeciesFilter_ALL;
    searchOptions.collectorName = @"";
    searchOptions.year = @"";
    searchOptions.yearFrom = @"";
    searchOptions.yearTo = @"";
    
    searchOptions.testGBIFData = NO;
    
    return searchOptions;
}

@end
