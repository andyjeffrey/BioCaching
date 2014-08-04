//
//  BCLocationManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 03/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCLocationManagerDelegate
@required
- (void)currentLocation:(CLLocation *)location;
@end


@interface BCLocationManager : NSObject<CLLocationManagerDelegate>

@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

+ (instancetype)sharedInstance;

+ (void)getCurrentLocationWithDelegate:(id)delegate;
+ (void)startRecordingTrack;
+ (void)stopRecordingTrack;

@end
