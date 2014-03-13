//
//  OccurrenceLocation.h
//  BioCaching
//
//  Created by Andy Jeffrey on 13/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrence.h"


@interface OccurrenceLocation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *mapMarkerImageFile;

- (id)initWithGBIFOccurrence:(GBIFOccurrence *)occurrence;

@end
