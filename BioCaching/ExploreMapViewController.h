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
#import "GBIFManagerDelegate.h"
#import "INatManagerDelegate.h"


@interface ExploreMapViewController : UIViewController <
    MKMapViewDelegate,
    UIGestureRecognizerDelegate,
    ExploreOptionsDelegate,
    DropDownViewDelegate,
    GBIFManagerDelegate,
    INatManagerDelegate
>

@property (nonatomic, strong) BCOptions *bcOptions;

@end
