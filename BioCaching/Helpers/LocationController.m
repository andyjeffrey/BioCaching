//
//  LocationController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 03/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "LocationController.h"

@implementation LocationController

+ (LocationController *)sharedInstance
{
    static dispatch_once_t once;
    static LocationController *instance;
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
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.delegate locationUpdated:locations.lastObject];
    self.location = locations.lastObject;
}

@end
