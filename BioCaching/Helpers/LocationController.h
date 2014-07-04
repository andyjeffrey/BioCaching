//
//  LocationController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 03/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationControllerDelegate
@required
- (void)locationUpdated:(CLLocation *)location;
@end


@interface LocationController : NSObject<CLLocationManagerDelegate>

@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

+ (instancetype)sharedInstance;

@end
