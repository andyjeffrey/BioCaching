//
//  INatTrip.h
//  BioCaching
//
//  Created by Andy Jeffrey on 16/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TripStatusCreated = 0,
    TripStatusInProgress = 1,
    TripStatusPaused = 2,
    TripStatusFinished = 3,
    TripStatusCompleted = 4
} INatTripStatus;

@interface INatTrip : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end
