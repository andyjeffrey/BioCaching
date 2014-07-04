#import "_INatObservation.h"

@interface INatObservation : _INatObservation {}

+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence dateRecorded:(NSDate *)dateRecorded location:(CLLocation *)location notes:(NSString *)notes;

@end
