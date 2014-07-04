#import "_OccurrenceRecord.h"

@class GBIFOccurrence;

@interface OccurrenceRecord : _OccurrenceRecord<MKAnnotation> {}

#pragma mark - MKAnnotation Properties
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *locationString;

+ (id)createFromGBIFOccurrence:(GBIFOccurrence *)gbifOccurrence;

#pragma mark - Additional/Convenience Methods
- (NSString *)getINatIconicTaxaMapMarkerImageFile:(BOOL)highlighted;
- (NSString *)getINatIconicTaxaMainImageFile;

@end
