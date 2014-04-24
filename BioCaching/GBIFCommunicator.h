//
//  GBIFCommunicator.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SearchOptions.h"

@protocol GBIFCommunicatorDelegate;

@interface GBIFCommunicator : NSObject
@property (weak, nonatomic) id<GBIFCommunicatorDelegate> delegate;

- (void)getOccurrencesWithinPolygon:(MKPolygon *)polygon;
- (void)getOccurrencesWithTripOptions:(SearchOptions *)searchOptions;

+ (NSString *)buildOccurrencesRequestString:(SearchOptions *)searchOptions;

@end
