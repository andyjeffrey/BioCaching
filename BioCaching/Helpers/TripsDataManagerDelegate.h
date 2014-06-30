//
//  TripsDataManagerDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 30/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INatTrip.h"
#import "OccurrenceRecord.h"

@protocol TripsDataManagerDelegate <NSObject>

- (void)occurrenceAddedToTrip:(OccurrenceRecord *)occurrence;
- (void)occurrenceRemovedFromTrip:(OccurrenceRecord *)occurrence;

@end
