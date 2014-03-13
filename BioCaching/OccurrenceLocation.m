//
//  OccurrenceLocation.m
//  BioCaching
//
//  Created by Andy Jeffrey on 13/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OccurrenceLocation.h"

@implementation OccurrenceLocation {
    NSString *_mainTitle;
    NSString *_subTitle;
    NSString *_mapMarkerImageFile;
}

- (id)initWithGBIFOccurrence:(GBIFOccurrence *)occurrence {
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake(occurrence.Latitude.doubleValue, occurrence.Longitude.doubleValue);
        _mainTitle = occurrence.MainTitle;
        _subTitle = occurrence.SubTitle;
/*
        if ([occurrence.Kingdom isEqualToString:@"Animalia"]) {
            _mapMarkerImageFile = @"mapannotation_orange_black_solid";
        } else if ([occurrence.Kingdom isEqualToString:@"Plantae"]) {
            _mapMarkerImageFile = @"mapannotation_grey_black_solid";
        } else {
            _mapMarkerImageFile = @"mapannotation_grey_black_solid";
        }
 */
        if ([occurrence.Kingdom isEqualToString:@"Plantae"]) {
            _mapMarkerImageFile = @"mapannotation_green_white_solid";
        } else if ([occurrence.Clazz isEqualToString:@"Aves"]) {
            _mapMarkerImageFile = @"mapannotation_blue_white_solid";
        } else if ([occurrence.Clazz isEqualToString:@"Reptilia"]) {
            _mapMarkerImageFile = @"mapannotation_orange_white_solid";
        } else {
            _mapMarkerImageFile = @"mapannotation_grey_white_solid";
        }
        
        _mapMarkerImageFile = [_mapMarkerImageFile stringByReplacingOccurrencesOfString:@"white" withString:@"black"];
        
    }
    return self;
}

- (NSString *)title {
    return _mainTitle;
}

- (NSString *)subtitle {
    return _subTitle;
}


@end
