//
//  TripOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "SearchOptions.h"

#define kOptionsKeySearchAreaSpan   @"OptionsSearchAreaSpan"
#define kOptionsKeyRecordType       @"OptionsRecordType"
#define kOptionsKeyRecordSource     @"OptionsRecordSource"
#define kOptionsKeySpeciesFilter    @"OptionsSpeciesFilter"
#define kOptionsKeyGBIFTestAPI      @"OptionsGBIFTestAPI"
#define kOptionsKeyGBIFTestData     @"OptionsGBIFTestData"

@implementation SearchOptions {
    NSUserDefaults *_userDefaults;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static SearchOptions *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[SearchOptions sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (![_userDefaults objectForKey:kOptionsKeySearchAreaSpan]) {
            self.searchAreaSpan = kDefaultSearchAreaSpan;
            self.enumRecordType = kDefaultOptionRecordType;
            self.enumRecordSource = kDefaultOptionRecordSource;
            self.enumSpeciesFilter = kDefaultOptionSpeciesFilter;
            self.testGBIFAPI = YES;
            self.testGBIFData = NO;
        }
        self.searchLocationName = @"";
        self.collectorName = @"";
        self.year = @"";
        self.yearFrom = @"";
        self.yearTo = @"";
    }
    return self;
}

+(id)initWithDefaults
{
    SearchOptions *searchOptions = [[SearchOptions alloc] initPrivate];

    searchOptions.searchAreaSpan = kDefaultSearchAreaSpan;
    searchOptions.searchLocationName = @"";
    searchOptions.enumRecordType = kDefaultOptionRecordType;
    searchOptions.enumRecordSource = kDefaultOptionRecordSource;
    searchOptions.enumSpeciesFilter = kDefaultOptionSpeciesFilter;
    searchOptions.collectorName = @"";
    searchOptions.year = @"";
    searchOptions.yearFrom = @"";
    searchOptions.yearTo = @"";
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kOptionsKeyGBIFTestAPI]) {
        searchOptions.testGBIFAPI = YES;
        searchOptions.testGBIFData = NO;
    }
    
    return searchOptions;
}

- (instancetype)makeCopy {
    SearchOptions *copy = [[SearchOptions alloc] init];
    
    return nil;
}

- (NSUInteger)searchAreaSpan {
    return [[_userDefaults objectForKey:kOptionsKeySearchAreaSpan] unsignedIntegerValue];
}
- (void)setSearchAreaSpan:(NSUInteger)searchAreaSpan
{
    [_userDefaults setObject:[NSNumber numberWithUnsignedInteger:searchAreaSpan] forKey:kOptionsKeySearchAreaSpan];
    [_userDefaults synchronize];
}

- (RecordType)enumRecordType {
    return (RecordType)[[_userDefaults objectForKey:kOptionsKeyRecordType] unsignedIntegerValue];
}
- (void)setEnumRecordType:(RecordType)enumRecordType
{
    [_userDefaults setObject:@(enumRecordType) forKey:kOptionsKeyRecordType];
    [_userDefaults synchronize];
}

- (RecordSource)enumRecordSource {
    return (RecordSource)[[_userDefaults objectForKey:kOptionsKeyRecordSource] unsignedIntegerValue];
}
- (void)setEnumRecordSource:(RecordSource)enumRecordSource {
    [_userDefaults setObject:@(enumRecordSource) forKey:kOptionsKeyRecordSource];
    [_userDefaults synchronize];
}

- (SpeciesFilter)enumSpeciesFilter {
    return (SpeciesFilter)[[_userDefaults objectForKey:kOptionsKeySpeciesFilter] unsignedIntegerValue];
}
- (void)setEnumSpeciesFilter:(SpeciesFilter)enumSpeciesFilter {
    [_userDefaults setObject:@(enumSpeciesFilter) forKey:kOptionsKeySpeciesFilter];
    [_userDefaults synchronize];
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
