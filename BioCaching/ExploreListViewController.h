//
//  ExplorerListViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBIFOccurrenceResults.h"

@interface ExploreListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) MKPolygon *searchArea;
@property (nonatomic) CLLocationCoordinate2D searchAreaCenter;
@property (nonatomic) int searchAreaSpan;
@property (nonatomic) GBIFOccurrenceResults *occurenceResults;

@end
