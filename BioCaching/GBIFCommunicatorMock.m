//
//  GBIFCommunicatorMock.m
//  BioCaching
//
//  Created by Andy Jeffrey on 12/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

//#define kMockOccurrenceResultsFile @"OccurrenceResultsCASv1.0.json"
#define kMockOccurrenceResultsFile @"OccurrenceResultsCASFilterv1.0.json"

#import "GBIFCommunicatorMock.h"
#import "GBIFCommunicatorDelegate.h"

@implementation GBIFCommunicatorMock

- (void)getOccurrencesWithinPolygon:(MKPolygon *)polygon
{
    NSLog(@"GBIFCommunicatorMock.getOccurrencesWithinPolygon");
    
    TripOptions *tripOptions = [TripOptions initWithDefaults];
    tripOptions.searchAreaPolygon = polygon;
    
    [self getOccurrencesWithTripOptions:tripOptions];
}

- (void)getOccurrencesWithTripOptions:(TripOptions *)tripOptions
{
    NSLog(@"GBIFCommunicatorMock.getOccurrencesWithTripOptions");

    NSString *requestString = [GBIFCommunicator buildOccurrencesRequestString:tripOptions];
    NSLog(@"GBIFCommunicatorMock RequestString: %@", requestString);
    
    NSData *mockResponseData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMockOccurrenceResultsFile ofType:nil]];
    [self.delegate receivedResultsJSON:mockResponseData];
}


@end
