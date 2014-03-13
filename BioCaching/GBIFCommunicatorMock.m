//
//  GBIFCommunicatorMock.m
//  BioCaching
//
//  Created by Andy Jeffrey on 12/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFCommunicatorMock.h"
#import "GBIFCommunicatorDelegate.h"

@implementation GBIFCommunicatorMock


- (void)getOccurencesWithinPolygon:(MKPolygon *)polygon
{
    NSLog(@"GBIFCommunicatorMock.getOccurrencesWithinPolygon");
    
    NSData *mockResponseData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMockOccurrenceResultsFile ofType:nil]];
    [self.delegate receivedResultsJSON:mockResponseData];
}


@end
