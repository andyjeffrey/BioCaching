//
//  TripSummaryTableViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 12/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripSummaryTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) INatTrip *currentTrip;

@end
