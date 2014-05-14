#import "_INatTrip.h"

typedef enum {
    TripStatusCreated = 0,
    TripStatusInProgress = 1,
    TripStatusPaused = 2,
    TripStatusFinished = 3,
    TripStatusCompleted = 4
} INatTripStatus;

@interface INatTrip : _INatTrip {}
// Custom logic goes here.
@end
