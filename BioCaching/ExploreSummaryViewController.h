//
//  ExploreSummaryViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBIFOccurrenceResults.h"
#import "BCOptions.h"

@interface ExploreSummaryViewController : UIViewController

@property (nonatomic, strong) GBIFOccurrenceResults *occurrenceResults;
@property (nonatomic, strong) BCOptions *bcOptions;

@end
