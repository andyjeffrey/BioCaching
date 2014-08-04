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

@protocol TripsDataManagerExploreDelegate <NSObject>

- (void)newTripCreated:(INatTrip *)trip;
- (void)occurrenceAddedToTrip:(OccurrenceRecord *)occurrence;
- (void)occurrenceRemovedFromTrip:(OccurrenceRecord *)occurrence;
- (void)locationTrackUpdated:(INatTrip *)trip;

@end


@protocol TripsDataManagerDelegate <NSObject>

- (void)tripsDataTableUpdated;
- (void)startedUpload:(INatTrip *)trip;
- (void)finishedUpload:(INatTrip *)trip success:(BOOL)success;
- (void)uploadProgress:(INatTrip *)trip progressString:(NSString *)progressString success:(BOOL)success;

@end
