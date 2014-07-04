//
//  CLLocation+Formatting.h
//  BioCaching
//
//  Created by Andy Jeffrey on 04/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Formatting)

- (NSString *)latLongVerbose;
- (NSString *)latCommaLong;
- (NSString *)latCommaLongWithTitle;

@end
