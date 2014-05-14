//
//  TripsDataManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

// Temporary Data Manager Class
// TODO: Replace with CoreData/RestKit Managed Objects

#import <Foundation/Foundation.h>
#import "GBIFOccurrenceResults.h"
#import "BCOptions.h"
#import "INatTrip.h"

@interface TripsDataManager : NSObject

@property NSMutableArray *createdTrips;
@property NSMutableArray *inProgressTrips;

+ (TripsDataManager *)sharedInstance;

- (void)CreateTripFromOccurrenceResults:(GBIFOccurrenceResults *)occurrenceResults bcOptions:(BCOptions *)bcOptions tripStatus:(INatTripStatus)tripStatus;

@end
