#import "_INatObservation.h"

@class INatTaxon;
@class OccurrenceRecord;

@interface INatObservation : _INatObservation {}

@property (nonatomic, readonly, assign) BOOL needsSyncing;
@property (nonatomic, readonly) OccurrenceRecord *occurrenceRecord;
@property (nonatomic, readonly) INatTaxon *iNatTaxon;
@property (nonatomic, readonly, copy) NSString *taxonSpecies;
@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, strong) NSString *dateRecordedString;

+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence;
+ (id)createNewObservationFromOccurrence:(OccurrenceRecord *)occurrence dateRecorded:(NSDate *)dateRecorded location:(CLLocation *)location notes:(NSString *)notes;

+(void)setupMapping;

@end
