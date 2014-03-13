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

NSString * const kOccurrenceSearch = @"http://api.gbif.org/v0.9/occurrence/search?limit=%d&offset=%d&geometry=%@";
int const kDefaultLimit = 300;
int const kDefaultOffset = 0;

- (void)getOccurencesWithinPolygon:(MKPolygon *)polygon
{
    NSString *requestString = [NSString stringWithFormat:kOccurrenceSearch,
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

@end
