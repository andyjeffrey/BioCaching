//
//  CLLocation+Formatting.m
//  BioCaching
//
//  Created by Andy Jeffrey on 04/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "CLLocation+Formatting.h"

@implementation CLLocation (Formatting)

+ (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

+ (NSString *)latLongStringFromCoordinate:(CLLocationCoordinate2D)coordinate {
    return [NSString stringWithFormat:@"Lat: %.6f Long: %.6f", coordinate.latitude, coordinate.longitude];
}

- (NSString *)latLongVerbose {
    return [NSString stringWithFormat:@"Lat: %.6f Long: %.6f", self.coordinate.latitude, self.coordinate.longitude];
}

- (NSString *)latCommaLong {
    return [NSString stringWithFormat:@"%.6f,%.6f", self.coordinate.latitude, self.coordinate.longitude];
}

- (NSString *)latCommaLongWithTitle {
    return [NSString stringWithFormat:@"Location: %.6f,%.6f", self.coordinate.latitude, self.coordinate.longitude];
}

@end
