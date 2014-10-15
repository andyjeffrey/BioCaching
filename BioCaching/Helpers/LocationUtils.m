//
//  LocationUtils.m
//  BioCaching
//
//  Created by Andy Jeffrey on 15/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "LocationUtils.h"

// Earth's Radius (in Km)
static const double kLatLongEarthRadius = 6371.0;

@implementation LocationUtils

+ (double)radiansFromDegrees:(double)degrees
{
    return degrees * (M_PI/180.0);
}

+ (double)degreesFromRadians:(double)radians
{
    return radians * (180.0/M_PI);
}

+ (CLLocationCoordinate2D) coordinateFromCoord:(CLLocationCoordinate2D)originCoord distanceKm:(double)distanceKm bearingDegrees:(double)bearingDegrees
{
    double distanceRadians = distanceKm / kLatLongEarthRadius;
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:originCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:originCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D destCoord;
    destCoord.latitude = [self degreesFromRadians:toLatRadians];
    destCoord.longitude = [self degreesFromRadians:toLonRadians];

    return destCoord;
}

@end
