//
//  MKPolygon+WKTParser.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKPolygon (WKTParser)

- (NSString *)convertToWKT;
- (NSString *)description;

+ (MKPolygon *)approximatedPolygonFromCircle:(MKCircle *)circle points:(NSUInteger)numberOfPoints;

@end
