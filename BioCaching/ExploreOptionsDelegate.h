//
//  ExploreOptionsDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 29/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExploreOptionsDelegate <NSObject>
- (void) saveOptions:(TripOptions *)savedTripOptions;
@end

