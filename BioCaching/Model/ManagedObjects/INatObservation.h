#import "_INatObservation.h"

@class INatTaxon;
@class OccurrenceRecord;

@interface INatObservation : _INatObservation {}

@property (nonatomic, readonly) OccurrenceRecord *occurrenceRecord;
@property (nonatomic, readonly) INatTaxon *iNatTaxon;
@property (nonatomic, readonly, copy) NSString *taxonSpecies;
@property (nonatomic, readonly, strong) NSString *dateRecordedString;

+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence dateRecorded:(NSDate *)dateRecorded location:(CLLocation *)location notes:(NSString *)notes;

+(void)setupMapping;

@end
