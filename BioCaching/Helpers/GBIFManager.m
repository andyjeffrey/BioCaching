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

@implementation GBIFManager {
    SearchOptions *_bcOptions;
}

- (void)fetchOccurrencesWithinArea:(MKPolygon *)polygonArea
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:TSMessage.defaultViewController title:@"GBIF Search Request Made (Polygon)" subtitle:polygonArea.description type:TSMessageNotificationTypeMessage duration:1];
    });

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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:TSMessage.defaultViewController title:@"GBIF Search Request Made" subtitle:searchOptions.searchAreaPolygon.description type:TSMessageNotificationTypeMessage duration:1];
    });
    
    [self.communicator getOccurrencesWithTripOptions:searchOptions];
}

#pragma mark - GBIFCommunicatorDelegate

- (void)receivedResultsJSON:(NSData *)objectNotation
{
    NSLog(@"GBIFManager receivedResultsJSON");
    NSError *error = nil;
    GBIFOccurrenceResults *occurrenceResults = [self buildOccurrenceResultsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self.delegate fetchingResultsFailedWithError:error];

        // Run NotificationMessage on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [TSMessage showNotificationInViewController:TSMessage.defaultViewController title:@"Error Parsing GBIF Results" subtitle:[NSString stringWithFormat:@"%@", error] type:TSMessageNotificationTypeError duration:2];
        });
    }
    else {
        [self.delegate didReceiveOccurences:occurrenceResults];
        
        // Run NotificationMessage on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [TSMessage showNotificationInViewController:TSMessage.defaultViewController title:@"GBIF Results Received" subtitle:[NSString stringWithFormat:@"%d Occurence Records", occurrenceResults.Count.intValue] type:TSMessageNotificationTypeSuccess duration:2];
        });
        //NSOperation Alternative
        //    [[NSOperationQueue mainQueue] addOperationWithBlock:^ { }];
        
    }
}

- (void)GBIFCommunicatorFailedWithError:(NSError *)error
{
    NSLog(@"GBIFManager Error: %@", error);
    // Run NotificationMessage on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:TSMessage.defaultViewController title:@"GBIF Communication Error" subtitle:[NSString stringWithFormat:@"%@", error] type:TSMessageNotificationTypeError duration:2];
    });
    
    [self.delegate fetchingResultsFailedWithError:error];
}

- (GBIFOccurrenceResults *)buildOccurrenceResultsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        NSLog(@"GBIFManager Error: %@", localError);
        return nil;
    }
    
    GBIFOccurrenceResults *occurrenceResults = [GBIFOccurrenceResults objectWithDictionary:parsedObject];
    
    NSLog(@"GBIFOccurenceResultsBuilder TotalResultsCount: %d", occurrenceResults.Count.intValue);
    NSLog(@"GBIFOccurenceResultsBuilder OccurenceRecordsReceived: %d - %d",
          [occurrenceResults.Offset intValue],
          ([occurrenceResults.Offset intValue] + (int)occurrenceResults.Results.count));
    
    return occurrenceResults;
    
}

@end
