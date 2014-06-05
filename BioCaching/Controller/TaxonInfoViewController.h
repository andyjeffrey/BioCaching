//
//  TaxonInfoViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 01/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBIFOccurrence.h"
#import "INatTrip.h"

@interface TaxonInfoViewController : UIViewController

@property (nonatomic, strong) GBIFOccurrence *occurrence;
@property (nonatomic, assign) BOOL showDetailsButton;
@property (nonatomic, strong) INatTrip *currentTrip;

@end
