//
//  TripsListCell.h
//  BioCaching
//
//  Created by Andy Jeffrey on 13/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tripImageIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTripTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTripSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTripSummaryStats;
@property (weak, nonatomic) IBOutlet UILabel *labelBackground;

@end
