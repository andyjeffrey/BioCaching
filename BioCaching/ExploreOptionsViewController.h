//
//  ExploreOptionsViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "TripOptions.h"
//#import "OptionsRecordType.h"


@protocol ExploreOptionsDelegate <NSObject>
- (void) saveOptions:(TripOptions *)savedTripOptions;
@end


@interface ExploreOptionsViewController : UIViewController <
    //UIPickerViewDelegate, UIPickerViewDataSource,
    DropDownViewDelegate>

@property (nonatomic, weak) TripOptions *tripOptions;
@property (nonatomic, weak) id <ExploreOptionsDelegate> delegate;

@end
