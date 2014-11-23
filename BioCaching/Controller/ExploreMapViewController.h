//
//  ExploreMapViewController.+
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DropDownViewController.h"
#import "ExploreOptionsDelegate.h"
#import "ExploreDataManagerDelegate.h"
#import "TripsDataManagerDelegate.h"
#import "INatTrip.h"

@interface ExploreMapViewController : UIViewController <
    MKMapViewDelegate,
    CLLocationManagerDelegate,
    UIGestureRecognizerDelegate,
    ExploreOptionsDelegate,
    DropDownViewDelegate,
    ExploreDataManagerDelegate,
    TripsDataManagerExploreDelegate
>

@end
