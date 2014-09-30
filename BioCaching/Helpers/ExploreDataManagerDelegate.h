//
//  ExploreDataManagerDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 05/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrenceResults.h"
#import "GBIFOccurrence.h"

@protocol ExploreDataManagerDelegate <NSObject>

- (void)occurrenceResultsReceived:(GBIFOccurrenceResults *)occurrenceResults;
- (void)errorReceived:(NSError *)error;
- (void)taxonAddedToOccurrence:(GBIFOccurrence *)occurrence;
- (void)occurrenceRemoved:(GBIFOccurrence *)occurrence;

@end

