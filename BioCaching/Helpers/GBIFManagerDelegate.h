//
//  GBIFManagerDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GBIFOccurrenceResults;

@protocol GBIFManagerDelegate

- (void)didReceiveOccurences:(GBIFOccurrenceResults *)occurrenceResults;
- (void)fetchingResultsFailedWithError:(NSError *)error;

@end
