//
//  BCLocationManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 03/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCLocationManager.h"
#import "TripsDataManager.h"

static double desiredAccurary = 10;
static double updateDistance = 20;

static BOOL recordingTrack;
static BOOL gettingCurrentLocation;

@implementation BCLocationManager

+ (BCLocationManager *)sharedInstance
{
    static dispatch_once_t once;
    static BCLocationManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LocationController sharedInstance]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = locations.lastObject;
    NSLog(@"BCLocationManager: %@", lastLocation.latCommaLong);
    if (lastLocation.horizontalAccuracy > desiredAccurary) {
        return;
    } else {
        self.lastLocation = lastLocation;
        if (gettingCurrentLocation) {
            [self.delegate currentLocationUpdated:self.lastLocation];
            gettingCurrentLocation = FALSE;
        }

        if (recordingTrack) {
            [[TripsDataManager sharedInstance] addLocationToCurrentTripTrack:locations.lastObject];
        } else {
            [self.locationManager stopUpdatingLocation];
        }
    }
}

+ (void)getCurrentLocationWithDelegate:(id)delegate {
    gettingCurrentLocation = YES;
    [[[self sharedInstance] locationManager] setDesiredAccuracy:desiredAccurary];
    [[[self sharedInstance] locationManager] startUpdatingLocation];
    [[self sharedInstance] setDelegate:delegate];
}


+ (void)startRecordingTrack {
    recordingTrack = YES;
    [[[self sharedInstance] locationManager] setDesiredAccuracy:desiredAccurary];
    [[[self sharedInstance] locationManager] setDistanceFilter:updateDistance];
    [[[self sharedInstance] locationManager] startUpdatingLocation];
}

+ (void)stopRecordingTrack {
    [[[self sharedInstance] locationManager] stopUpdatingLocation];
    recordingTrack = NO;
}

@end
