//
//  GBIFOccurenceResultsBuilder.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFOccurenceResultsBuilder.h"

@implementation GBIFOccurenceResultsBuilder

+ (GBIFOccurrenceResults *)occurenceResultsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    GBIFOccurrenceResults *occurenceResults = [GBIFOccurrenceResults objectWithDictionary:parsedObject];
    
    NSLog(@"GBIFOccurenceResultsBuilder TotalResults: %d", occurenceResults.Count.intValue);
    NSLog(@"GBIFOccurenceResultsBuilder OccurenceRecords: %lu", (unsigned long)occurenceResults.Results.count);
    
    return occurenceResults;
    
}
@end
