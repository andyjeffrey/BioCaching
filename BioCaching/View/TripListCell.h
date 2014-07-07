//
//  TripListCell.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripListCell;
@protocol TripListCellDelegate
- (void)actionButtonSelected:(TripListCell *)cell;
@end

@interface TripListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tripImageIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTripTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTripSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTripSummaryStats;
@property (weak, nonatomic) IBOutlet UILabel *labelBackground;
@property (weak, nonatomic) IBOutlet UIButton *buttonAction;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) id<TripListCellDelegate> delegate;

- (IBAction)performAction:(id)sender;

@end
