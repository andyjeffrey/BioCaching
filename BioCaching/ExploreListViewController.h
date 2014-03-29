//
//  ExplorerListViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripOptions.h"
#import "GBIFOccurrenceResults.h"

@interface ExploreListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GBIFOccurrenceResults *occurenceResults;
@property (nonatomic, strong) TripOptions *tripOptions;

@end
