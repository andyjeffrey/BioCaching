//
//  ExploreSummaryTableViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 06/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBIFOccurrenceResults.h"
#import "INatTrip.h"
#import "BCOptions.h"

@interface ExploreSummaryTableViewController : UITableViewController

@property (nonatomic, strong) GBIFOccurrenceResults *occurrenceResults;
@property (nonatomic, strong) INatTrip *currrentTrip;
@property (nonatomic, strong) BCOptions *bcOptions;

@end
