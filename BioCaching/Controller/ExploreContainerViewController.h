//
//  ExploreContainerViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExploreContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewExploreContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControlView;

@property (weak, nonatomic) IBOutlet UIView *viewButtonsPanel;

@property (weak, nonatomic) IBOutlet UIView *viewButtonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIImageView *imageButtonSave;
@property (weak, nonatomic) IBOutlet UILabel *labelButtonSave;
- (IBAction)actionSaveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewButtonStart;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIImageView *imageButtonStart;
@property (weak, nonatomic) IBOutlet UILabel *labelButtonStart;
- (IBAction)actionStartButton:(id)sender;

@property (nonatomic, strong) INatTrip *currentTrip;
@property (nonatomic, strong) GBIFOccurrenceResults *occurrenceResults;
@property (nonatomic, strong) CLLocation *currentUserLocation;

- (void)updateTripButtons;

@end
