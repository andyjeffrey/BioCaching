//
//  GBIFCommunicator.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFCommunicator.h"
#import "GBIFCommunicatorDelegate.h"

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
    
    NSLog(@"GBIFCommunicator Request: %@", requestString);
    
    NSURL *url = [[NSURL alloc] initWithString:requestString];

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
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
                             searchOptions.recordType.queryStringValueGBIF,
                             searchOptions.recordSource.queryStringValueGBIF,
                             searchOptions.speciesFilter.queryStringValueGBIF,
//                             [OptionsRecordType queryStringValue:searchOptions.recordType],
//                             [OptionsRecordSource queryStringValue:searchOptions.recordSource],
//                             [OptionsSpeciesFilter queryStringValue:searchOptions.speciesFilter],
                             searchOptions.collectorName,
                             searchOptions.year,
                             searchOptions.yearFrom,
                             searchOptions.yearTo,
                             [searchOptions.searchAreaPolygon convertToWKT]];
    
    NSString *requestString;
    if (searchOptions.testGBIFAPI) {
        requestString = [NSString stringWithFormat:@"%@%@", kGBIFTestAPIBaseURL, queryString];
    } else {
        requestString = [NSString stringWithFormat:@"%@%@", kGBIFBaseURL, queryString];
    }
    
    return requestString;
}

@end
