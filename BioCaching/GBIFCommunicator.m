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
    TripOptions *tripOptions = [TripOptions initWithDefaults];
    tripOptions.searchAreaPolygon = polygon;
    
    [self getOccurrencesWithTripOptions:tripOptions];
}

- (void)getOccurrencesWithTripOptions:(TripOptions *)tripOptions
{
    NSString *requestString = [GBIFCommunicator buildOccurrencesRequestString:tripOptions];
    
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

+ (NSString *)buildOccurrencesRequestString:(TripOptions *)tripOptions
{
    NSString *queryString = [NSString stringWithFormat:kGBIFOccurrenceSearch,
                             kGBIFOccurrenceDefaultLimit,
                             kGBIFOccurrenceDefaultOffset,
                             [OptionsRecordType queryStringValue:tripOptions.recordType],
                             [OptionsRecordSource queryStringValue:tripOptions.recordSource],
                             [OptionsSpeciesFilter queryStringValue:tripOptions.speciesFilter],
                             tripOptions.collectorName,
                             tripOptions.year,
                             tripOptions.yearFrom,
                             tripOptions.yearTo,
                             [tripOptions.searchAreaPolygon convertToWKT]];
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@",
                               kGBIFBaseURL, queryString];
    
    return requestString;
}

@end
