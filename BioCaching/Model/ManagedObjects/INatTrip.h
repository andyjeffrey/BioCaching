#import "_INatTrip.h"
#import "GBIFOccurrenceResults.h"

typedef enum {
    TripStatusCreated = 0,
    TripStatusSaved = 1,
    TripStatusInProgress = 2,
    TripStatusPaused = 3,
    TripStatusFinished = 4,
    TripStatusPublished = 5
} INatTripStatus;

@interface INatTrip : _INatTrip  {}

@property (nonatomic, readonly) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, readonly, strong) NSArray *occurrenceRecords;
@property (nonatomic, strong) NSMutableArray *removedRecords;

+(void)setupMapping;

@end
