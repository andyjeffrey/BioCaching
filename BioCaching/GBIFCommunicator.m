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
    NSString *requestString = [NSString stringWithFormat:kOccurrenceSearchPolygon,
                             kDefaultLimit, kDefaultOffset, [polygon convertToWKT]];
    NSLog(@"GBIFCommunicator RequestSent: %@", requestString);

    NSURL *url = [[NSURL alloc] initWithString:requestString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [self.delegate fetchingResultsFailedWithError:connectionError];
        } else {
            [self.delegate receivedResultsJSON:data];
        }
    }];
}

- (void)getOccurrencesWithTripOptions:(TripOptions *)tripOptions
{
    NSString *requestString = [NSString stringWithFormat:kOccurrenceSearch,
                               kDefaultLimit,
                               kDefaultOffset,
                               [OptionsRecordType queryStringValue:tripOptions.recordType],
                               [OptionsRecordSource queryStringValue:tripOptions.recordSource],
                               [OptionsSpeciesFilter queryStringValue:tripOptions.speciesFilter],
                               tripOptions.collectorName,
                               tripOptions.year,
                               tripOptions.yearFrom,
                               tripOptions.yearTo,
                               [tripOptions.searchAreaPolygon convertToWKT]];
    NSLog(@"GBIFCommunicator RequestSent: %@", requestString);
    
    NSURL *url = [[NSURL alloc] initWithString:requestString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            [self.delegate fetchingResultsFailedWithError:connectionError];
        } else {
            [self.delegate receivedResultsJSON:data];
        }
    }];
}

@end
