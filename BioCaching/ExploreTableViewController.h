//
//  ExploreTableViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 10/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GBIFOccurrenceResults.h"

@interface ExploreTableViewController : UITableViewController

@property (nonatomic) CLLocationCoordinate2D searchAreaCenter;
@property (nonatomic) int searchAreaSpan;
@property (nonatomic) GBIFOccurrenceResults *occurenceResults;

@end
