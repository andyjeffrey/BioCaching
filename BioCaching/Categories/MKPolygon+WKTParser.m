//
//  MKPolygon+WKTParser.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "MKPolygon+WKTParser.h"

static const int ddLogLevel = LOG_LEVEL_INFO;
static const int kNoOfPolygonPoints = 16;

@implementation MKPolygon (WKTParser)

- (NSString *)convertToWKT
{
    NSString *wktPolygonFormat = @"POLYGON((%@))";
    NSMutableString *wktPoints = [NSMutableString string];
    
    for (int i = 0; i < self.pointCount; i++) {
        CLLocationCoordinate2D coord = MKCoordinateForMapPoint(self.points[i]);
        if (i > 0) {
            [wktPoints appendString:@","];
        }
        [wktPoints appendFormat:@"%f%%20%f", coord.longitude, coord.latitude];
        //NSLog(@"MKPolygon.convertToWKT: %f %f", coord.longitude, coord.latitude);
    }
    
    NSString *wktPolygon = [NSString stringWithFormat:wktPolygonFormat, wktPoints];
    DDLogDebug(@"MKPolygon.convertToWKT: %@", wktPolygon);
    
    return wktPolygon;
}

- (NSString *)description
{
    NSMutableString *descString = [NSMutableString string];
    
    for (int i = 0; i < self.pointCount; i++) {
        CLLocationCoordinate2D coord = MKCoordinateForMapPoint(self.points[i]);
        [descString appendFormat:@"%f,%f ", coord.latitude, coord.longitude];
    }
    
    return descString;
}

+ (MKPolygon *)approximatedPolygonFromCircle:(MKCircle *)circle points:(NSUInteger)numberOfPoints
{
    CLLocationCoordinate2D *polygonPoints = malloc(sizeof(CLLocationCoordinate2D) * numberOfPoints+1);
    
    for (int i = 0; i <= numberOfPoints; i++) {
        double angle = 360.0/numberOfPoints * i;
        CLLocationCoordinate2D polyonPoint = [LocationUtils coordinateFromCoord:circle.coordinate distanceKm:circle.radius/1000.0 bearingDegrees:angle];
        polygonPoints[i] = polyonPoint;
    }
    MKPolygon *approxPolygon = [MKPolygon polygonWithCoordinates:polygonPoints count:numberOfPoints+1];

    return approxPolygon;
}

+ (MKPolygon *)approximatedPolygonFromCircle:(MKCircle *)circle
{
    return [self approximatedPolygonFromCircle:circle points:[BCOptions sharedInstance].searchOptions.approxCirclePoints];
}

@end
