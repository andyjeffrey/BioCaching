#import "INatObservation.h"


@interface INatObservation ()

// Private interface goes here.

@end


@implementation INatObservation

+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence dateRecorded:(NSDate *)dateRecorded location:(CLLocation *)location notes:(NSString *)notes
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    INatObservation *observation = [NSEntityDescription insertNewObjectForEntityForName:@"INatObservation" inManagedObjectContext:managedObjectContext];

    observation.dateRecorded = dateRecorded;
    observation.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    observation.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    
    observation.notes = [notes copy];
    
    return observation;
}

@end
