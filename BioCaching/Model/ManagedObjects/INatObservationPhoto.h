#import "_INatObservationPhoto.h"

@interface INatObservationPhoto : _INatObservationPhoto {}

@property (nonatomic, readonly, assign) BOOL needsSyncing;
@property (nonatomic, readonly, strong) NSNumber *observationId;
@property (nonatomic, readonly, strong) NSString *localAssetFilename;

+ (id)createNewObservationPhoto:(NSString *)photoAssetUrl;

@end
