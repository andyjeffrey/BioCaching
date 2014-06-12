#import "_INatTrip.h"

typedef enum {
    TripStatusCreated = 0,
    TripStatusInProgress = 1,
    TripStatusPaused = 2,
    TripStatusFinished = 3,
    TripStatusPublished = 4
} INatTripStatus;

@interface INatTrip : _INatTrip {}

+(void)setupMapping;

@end
