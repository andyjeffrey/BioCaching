//
//  GBIFCommunicatorMock.m
//  BioCaching
//
//  Created by Andy Jeffrey on 12/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFCommunicatorMock.h"
#import "GBIFCommunicatorDelegate.h"

#define kMockOccurrenceResultsFile @"OccurrenceResultsCAS.json"
#define kMockFilteredOccurrenceResultsFile @"OccurrenceResultsCASFilter.json"

@implementation GBIFCommunicatorMock

- (void)getOccurrencesWithinPolygon:(MKPolygon *)polygon
{
    NSLog(@"GBIFCommunicatorMock.getOccurrencesWithinPolygon");
    
    NSData *mockResponseData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMockOccurrenceResultsFile ofType:nil]];
    [self.delegate receivedResultsJSON:mockResponseData];
}

- (void)getOccurrencesWithTripOptions:(TripOptions *)tripOptions
{
    NSLog(@"GBIFCommunicatorMock.getOccurrencesWithTripOptions");
    
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
    
    NSLog(@"GBIFCommunicatorMock RequestString: %@", requestString);
    
    NSData *mockResponseData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMockFilteredOccurrenceResultsFile ofType:nil]];
    [self.delegate receivedResultsJSON:mockResponseData];
}


@end
