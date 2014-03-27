//
//  LocationsArray.h
//  BioCaching
//
//  Created by Andy Jeffrey on 23/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationsArray : NSObject

+ (NSUInteger)count;
+ (NSArray *)displayStringsArray;

+ (NSString *)displayString:(NSInteger)arrayIndex;
+ (NSString *)locationString:(NSInteger)arrayIndex;
+ (int)locationSearchAreaSpan:(NSInteger)arrayIndex;
+ (int)locationViewSpan:(NSInteger)arrayIndex;

+ (CLLocationCoordinate2D)locationCoordinate:(NSInteger)arrayIndex;
+ (CLLocationCoordinate2D)defaultLocation;

@end
