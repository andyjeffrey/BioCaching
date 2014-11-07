//
//  GBIFCommunicator.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFCommunicator.h"
#import "GBIFCommunicatorDelegate.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@implementation GBIFCommunicator

- (void)getOccurrencesWithinPolygon:(MKPolygon *)polygon
{
    SearchOptions *tripOptions = [SearchOptions initWithDefaults];
    tripOptions.searchAreaPolygon = polygon;
    
    [self getOccurrencesWithTripOptions:tripOptions];
}

- (void)getOccurrencesWithTripOptions:(SearchOptions *)searchOptions
{
    NSString *requestString = [GBIFCommunicator buildOccurrencesRequestString:searchOptions];
    
    NSDate *requestTime = [NSDate date];
    DDLogInfo(@"GBIFCommunicator Request: %@", requestString);
    
    NSURL *url = [[NSURL alloc] initWithString:requestString];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kDefaultInternetTimeout] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSTimeInterval responseTime = [[NSDate date] timeIntervalSinceDate:requestTime];
        DDLogInfo(@"Response Received, Time Taken: %.3f", responseTime);
        if (connectionError) {
            [self.delegate GBIFCommunicatorFailedWithError:connectionError];
        } else {
            [self.delegate receivedResultsJSON:data];
        }
    }];
}

+ (NSString *)buildOccurrencesRequestString:(SearchOptions *)searchOptions
{
    NSString *queryString = [NSString stringWithFormat:kGBIFOccurrenceSearch,
                             kGBIFOccurrenceDefaultLimit,
                             kGBIFOccurrenceDefaultOffset,
                             [OptionsRecordType queryStringGBIFValueForOption:searchOptions.enumRecordType],
                             [OptionsRecordSource queryStringGBIFValueForOption:searchOptions.enumRecordSource],
                             [OptionsSpeciesFilter queryStringGBIFValueForOption:searchOptions.enumSpeciesFilter],
//                             searchOptions.recordType.queryStringValueGBIF,
//                             searchOptions.recordSource.queryStringValueGBIF,
//                             searchOptions.speciesFilter.queryStringValueGBIF,
                             searchOptions.collectorName,
                             searchOptions.year,
                             searchOptions.yearFrom,
                             searchOptions.yearTo,
                             [searchOptions.searchAreaPolygon convertToWKT]];
    
    NSString *requestString;
    if (searchOptions.testGBIFAPI) {
        requestString = [NSString stringWithFormat:@"%@%@", kGBIFBaseURL, queryString];
    } else {
        requestString = [NSString stringWithFormat:@"%@%@", kGBIFBaseURLPreV1, queryString];
    }
    
    return requestString;
}

@end
