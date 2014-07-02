//
//  TripsViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripsDataManagerDelegate.h"

@interface TripsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, TripsDataManagerTableDelegate>

@end
