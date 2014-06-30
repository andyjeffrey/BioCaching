#import "_OccurrenceRecord.h"
#import "GBIFOccurrence.h"

@interface OccurrenceRecord : _OccurrenceRecord<MKAnnotation> {}

#pragma mark - MKAnnotation Properties
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

+ (id)createFromGBIFOccurrence:(GBIFOccurrence *)gbifOccurrence;

@end
