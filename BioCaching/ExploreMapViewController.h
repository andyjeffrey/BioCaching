//
//  ExploreMapViewController.+
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "ExploreListViewController.h"
#import "GBIFManager.h"
#import "GBIFOccurrenceResults.h"

@interface ExploreMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate, GBIFManagerDelegate>
{
    GBIFOccurrenceResults *_occurrenceResults;
    GBIFManager *_manager;
}

@end
