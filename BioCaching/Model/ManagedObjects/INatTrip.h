#import "_INatTrip.h"
#import "GBIFOccurrenceResults.h"

#define kINatTripsPathPattern @"trips"
#define kINatTripsKeyPath @"trips"

typedef enum {
    TripStatusCreated = 0,
    TripStatusSaved = 1,
    TripStatusInProgress = 2,
    TripStatusPaused = 3,
    TripStatusFinished = 4,
    TripStatusPublished = 5
} INatTripStatus;

@interface INatTrip : _INatTrip  {}

@property (nonatomic, readonly, assign) BOOL needsSyncing;
@property (nonatomic, readonly) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, strong) NSNumber *radius;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, readonly, strong) NSArray *occurrenceRecords;
@property (nonatomic, strong) NSMutableArray *removedRecords;
@property (nonatomic, readonly, strong) NSArray *observations;
@property (nonatomic, readonly, strong) NSArray *observationPhotos;
@property (nonatomic, assign) BOOL uploading;
@property (nonatomic, strong) NSMutableOrderedSet *locationTrack;

#pragma mark - Convenience Properties
@property (nonatomic, readonly, strong) NSString *timespanText;
@property (nonatomic, readonly, assign) NSUInteger tripAttributesTotal;
@property (nonatomic, readonly, assign) NSUInteger tripAttributesFound;
@property (nonatomic, readonly, assign) NSUInteger tripAttributesToFind;

+(void)setupMapping;

@end
