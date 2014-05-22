//
//  INatTrip.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

typedef enum {
    TripStatusCreated = 0,
    TripStatusInProgress = 1,
    TripStatusPaused = 2,
    TripStatusFinished = 3,
    TripStatusCompleted = 4
} INatTripStatus;


@interface INatTrip : BCManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * positionalAccuracy;
@property (nonatomic, retain) NSNumber * placeId;
@property (nonatomic, retain) NSNumber * status;

@end
