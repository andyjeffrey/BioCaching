//
//  OptionsStaticTableViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 14/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCOptions.h"
#import "DropDownViewController.h"
#import "ExploreOptionsDelegate.h"

@interface ExploreOptionsViewController : UITableViewController <DropDownViewDelegate>

@property (nonatomic, weak) BCOptions *bcOptions;
@property (nonatomic, weak) id <ExploreOptionsDelegate> delegate;

@end
