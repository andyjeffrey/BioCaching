//
//  ExploreListViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCOptions.h"
#import "GBIFOccurrenceResults.h"
#import "INatTrip.h"

@interface ExploreListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BCOptions *bcOptions;
@property (nonatomic, strong) GBIFOccurrenceResults *occurrenceResults;
@property (nonatomic, strong) INatTrip *iNatTrip;

@end