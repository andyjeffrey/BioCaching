//
//  ExploreListViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BCOptions.h"
#import "INatTrip.h"
#import "TaxonListCell.h"

@interface ExploreListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TaxonListCellDelegate>

//@property (nonatomic, strong) BCOptions *bcOptions;

@end
