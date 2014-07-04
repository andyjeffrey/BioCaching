//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "SearchOptions.h"
#import "OptionsRecordType.h"
#import "OptionsRecordSource.h"
#import "OptionsSpeciesFilter.h"

#define kOptionsKeyGBIFTestAPI      @"OptionsGBIFTestAPI"
#define kOptionsKeyGBIFTestData     @"OptionsGBIFTestData"

@implementation SearchOptions

+(id)initWithDefaults
{
    SearchOptions *searchOptions = [[SearchOptions alloc] init];

    searchOptions.searchAreaSpan = kOptionsDefaultSearchAreaSpan;
    searchOptions.searchLocationName = @"";
    searchOptions.recordType = [OptionsRecordType defaultOption];
    searchOptions.recordSource = [OptionsRecordSource defaultOption];
    searchOptions.speciesFilter = [OptionsSpeciesFilter defaultOption];
//    RecordType_PRESERVED_SPECIMEN;
//    searchOptions.recordSource = RecordSource_ALL;
//    searchOptions.speciesFilter = SpeciesFilter_ALL;
    searchOptions.collectorName = @"";
    searchOptions.year = @"";
    searchOptions.yearFrom = @"";
    searchOptions.yearTo = @"";
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kOptionsKeyGBIFTestAPI]) {
        searchOptions.testGBIFAPI = NO;
        searchOptions.testGBIFData = NO;
    }
    
    return searchOptions;
}

- (BOOL)testGBIFAPI {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kOptionsKeyGBIFTestAPI] boolValue];
}

- (void)setTestGBIFAPI:(BOOL)testGBIFAPI
{
    [[NSUserDefaults standardUserDefaults] setBool:testGBIFAPI forKey:kOptionsKeyGBIFTestAPI];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)testGBIFData {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kOptionsKeyGBIFTestData] boolValue];
}

- (void)setTestGBIFData:(BOOL)testGBIFData
{
    [[NSUserDefaults standardUserDefaults] setBool:testGBIFData forKey:kOptionsKeyGBIFTestData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
