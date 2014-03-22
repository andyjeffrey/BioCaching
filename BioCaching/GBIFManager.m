//
//  GBIFManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 08/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFManager.h"
#import "GBIFOccurenceResultsBuilder.h"
#import "GBIFCommunicator.h"

@implementation GBIFManager

- (void)fetchOccurrencesWithinArea:(MKPolygon *)polygonArea
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController title:@"GBIF Search Request Made (Polygon)" subtitle:polygonArea.description type:TSMessageNotificationTypeMessage duration:1];
    });

    [self.communicator getOccurrencesWithinPolygon:polygonArea];
}

- (void)fetchOccurrencesWithOptions:(TripOptions *)tripOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController title:@"GBIF Search Request Made" subtitle:tripOptions.searchAreaPolygon.description type:TSMessageNotificationTypeMessage duration:1];
    });
    
    [self.communicator getOccurrencesWithTripOptions:tripOptions];
}

#pragma mark - GBIFCommunicatorDelegate

- (void)receivedResultsJSON:(NSData *)objectNotation
{
    NSLog(@"GBIFManager receivedResultsJSON");
    NSError *error = nil;
    GBIFOccurrenceResults *occurenceResults = [GBIFOccurenceResultsBuilder occurenceResultsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        NSLog(@"GBIFManager Error: %@", error);
        [self.delegate fetchingResultsFailedWithError:error];

        // Run NotificationMessage on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController title:@"GBIF Error Received" subtitle:[NSString stringWithFormat:@"%@", error] type:TSMessageNotificationTypeError duration:2];
        });
    }
    else {
        NSLog(@"GBIFManager occurenceResults: %d", occurenceResults.Count.intValue);
        [self.delegate didReceiveOccurences:occurenceResults];
        
        // Run NotificationMessage on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController title:@"Results Received" subtitle:[NSString stringWithFormat:@"%d Occurence Records", occurenceResults.Count.intValue] type:TSMessageNotificationTypeSuccess duration:2];
        });
        //NSOperation Alternative
        //    [[NSOperationQueue mainQueue] addOperationWithBlock:^ { }];
        
    }
}

- (void)fetchingResultsFailedWithError:(NSError *)error
{
    NSLog(@"GBIFManager Error: %@", error);
    // Run NotificationMessage on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController title:@"GBIF Error Received" subtitle:[NSString stringWithFormat:@"%@", error] type:TSMessageNotificationTypeError duration:2];
    });
    
    [self.delegate fetchingResultsFailedWithError:error];
}

@end
