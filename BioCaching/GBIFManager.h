//
//  GBIFManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 08/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBIFManagerDelegate.h"
#import "GBIFCommunicatorDelegate.h"
#import "TripOptions.h"

@class GBIFCommunicator;

@interface GBIFManager : NSObject<GBIFCommunicatorDelegate>
@property (strong, nonatomic) GBIFCommunicator *communicator;
@property (weak, nonatomic) id<GBIFManagerDelegate> delegate;

- (void)fetchOccurrencesWithinArea:(MKPolygon *)polygonArea;
- (void)fetchOccurrencesWithOptions:(TripOptions *)tripOptions;

@end
