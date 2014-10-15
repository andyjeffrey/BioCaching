//
//  LocationUtils.h
//  BioCaching
//
//  Created by Andy Jeffrey on 15/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationUtils : NSObject

+ (double)radiansFromDegrees:(double)degrees;
+ (double)degreesFromRadians:(double)radians;

+ (CLLocationCoordinate2D) coordinateFromCoord:(CLLocationCoordinate2D)originCoord distanceKm:(double)distanceKm bearingDegrees:(double)bearingDegrees;

@end
