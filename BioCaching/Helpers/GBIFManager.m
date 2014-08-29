//
//  GBIFManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 08/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFManager.h"
#import "GBIFCommunicator.h"
#import "GBIFCommunicatorMock.h"
#import "GBIFOccurrenceResults.h"

static const int ddLogLevel = LOG_LEVEL_DEBUG;

@implementation GBIFManager {
    SearchOptions *_bcOptions;
}

- (void)fetchOccurrencesWithinArea:(MKPolygon *)polygonArea
{
    [BCAlerts displayDefaultInfoNotification:@"GBIF Search Request Made (Polygon)" subtitle:polygonArea.description];
    [self.communicator getOccurrencesWithinPolygon:polygonArea];
}

- (void)fetchOccurrencesWithOptions:(SearchOptions *)searchOptions
{
    if (searchOptions.testGBIFData) {
        self.communicator = [[GBIFCommunicatorMock alloc] init];
    } else {
        self.communicator = [[GBIFCommunicator alloc] init];
    }
    self.communicator.delegate = self;
    
#ifdef TESTING
    [BCAlerts displayDefaultInfoNotification:@"GBIF Search Request Made" subtitle:searchOptions.searchAreaPolygon.description];
#else
    CLLocation *location = [CLLocation initWithCoordinate:searchOptions.searchAreaCentre];
    NSString *searchString = [NSString stringWithFormat:@"%@\nSearch Area: %dm",
                              location.latLongVerbose, (int)searchOptions.searchAreaSpan];
    [BCAlerts displayDefaultInfoNotification:@"Searching For Records..." subtitle:searchString];
#endif
    
    [self.communicator getOccurrencesWithTripOptions:searchOptions];
}

#pragma mark - GBIFCommunicatorDelegate

- (void)receivedResultsJSON:(NSData *)objectNotation
{
    DDLogVerbose(@"GBIFManager receivedResultsJSON");
    NSError *error = nil;
    GBIFOccurrenceResults *occurrenceResults = [self buildOccurrenceResultsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingResultsFailedWithError:error];

        [BCAlerts displayDefaultFailureNotification:@"Error Parsing GBIF Results" subtitle:[NSString stringWithFormat:@"%@", error]];
    }
    else {
        [self.delegate didReceiveOccurences:occurrenceResults];
        //NSOperation Alternative
        //    [[NSOperationQueue mainQueue] addOperationWithBlock:^ { }];
        
    }
}

- (void)GBIFCommunicatorFailedWithError:(NSError *)error
{
    DDLogError(@"GBIFManager Error: %@", error);
    [self.delegate fetchingResultsFailedWithError:error];
}

- (GBIFOccurrenceResults *)buildOccurrenceResultsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        DDLogError(@"GBIFManager Error: %@", localError);
        return nil;
    }
    
    GBIFOccurrenceResults *occurrenceResults = [GBIFOccurrenceResults objectWithDictionary:parsedObject];
    
    DDLogVerbose(@"GBIFManager TotalResultsCount: %d", occurrenceResults.Count.intValue);
    DDLogVerbose(@"GBIFManager OccurenceRecordsReceived: %d - %d",
          [occurrenceResults.Offset intValue],
          ([occurrenceResults.Offset intValue] + (int)occurrenceResults.Results.count));
    
    return occurrenceResults;
    
}

@end
