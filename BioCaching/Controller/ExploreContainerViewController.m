//
//  ExploreContainerViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreContainerViewController.h"
#import "ExploreMapViewController.h"
#import "ExploreListViewController.h"
#import "ExploreSummaryViewController.h"
#import "TripsDataManager.h"
#import "BCLocationManager.h"

static const int ddLogLevel = LOG_LEVEL_DEBUG;

static int const defaultEmbeddedView = 0;

@interface ExploreContainerViewController ()

@property (nonatomic, strong) NSArray *embeddedVCs;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ExploreContainerViewController {
    NSString *_currentEmbeddedSegueId;
    TripsDataManager *_tripsDataManager;
    BCOptions *_bcOptions;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    
    _tripsDataManager = [TripsDataManager sharedInstance];
    _bcOptions = [BCOptions sharedInstance];

    [self initEmbeddedVCs];
    [self setupSegControl];
    [self performSegueWithIdentifier:_currentEmbeddedSegueId sender:nil];
    [self resetTripButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.currentTrip = _tripsDataManager.currentTrip;
}


#pragma mark - Init/Setup Methods

- (void)initEmbeddedVCs
{
    NSMutableArray *embeddedVCs = [[NSMutableArray alloc] initWithCapacity:self.segControlView.numberOfSegments];
    [embeddedVCs addObject:[NSMutableArray arrayWithArray:@[@"embedExploreMap", [NSNull null]]]];
    [embeddedVCs addObject:[NSMutableArray arrayWithArray:@[@"embedExploreList", [NSNull null]]]];
    [embeddedVCs addObject:[NSMutableArray arrayWithArray:@[@"embedExploreSummary", [NSNull null]]]];
    self.embeddedVCs = embeddedVCs;
}

- (void)setupSegControl
{
    // Fix for background color of SegmentedControl
    // http://stackoverflow.com/questions/19138252/uisegmentedcontrol-bounds
    CAShapeLayer* mask = [[CAShapeLayer alloc] init];
    mask.frame = CGRectMake(0, 0, self.segControlView.bounds.size.width, self.segControlView.bounds.size.height);
    mask.path = [[UIBezierPath bezierPathWithRoundedRect:mask.frame cornerRadius:5] CGPath];
    self.segControlView.layer.mask = mask;
    self.segControlView.layer.cornerRadius = 5;

    self.segControlView.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
    self.segControlView.selectedSegmentIndex = defaultEmbeddedView;
    _currentEmbeddedSegueId = self.embeddedVCs[self.segControlView.selectedSegmentIndex][0];
    
    // Each Segment Size = 40x28 pix
    [self.segControlView setTitle:nil forSegmentAtIndex:0];
    [self.segControlView setImage:[IonIcons imageWithIcon:icon_location size:24 color:[UIColor kColorButtonLabel]] forSegmentAtIndex:0];
//    [self.segControlView setImage:[IonIcons imageWithIcon:icon_map size:24 color:[UIColor kColorButtonLabel]] forSegmentAtIndex:0];
    [self.segControlView setTitle:nil forSegmentAtIndex:1];
    [self.segControlView setImage:[IonIcons imageWithIcon:icon_clipboard size:24 color:[UIColor kColorButtonLabel]] forSegmentAtIndex:1];
    [self.segControlView setTitle:nil forSegmentAtIndex:2];
//    [self.segControlView setImage:[IonIcons imageWithIcon:icon_compose size:24 color:[UIColor kColorButtonLabel]] forSegmentAtIndex:2];
    [self.segControlView setImage:[IonIcons imageWithIcon:icon_navicon_round size:24 color:[UIColor kColorButtonLabel]] forSegmentAtIndex:2];
    
}


#pragma mark - IBActions

- (IBAction)segControlChanged:(id)sender
{
    _currentEmbeddedSegueId = self.embeddedVCs[self.segControlView.selectedSegmentIndex][0];
    [self performSegueWithIdentifier:_currentEmbeddedSegueId sender:nil];
}


#pragma mark - Embedded Segues/VCs

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DDLogVerbose(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);
    
    // Keep track of embedded VC instances to save reloading each time
    NSMutableArray *embeddedVC = self.embeddedVCs[self.segControlView.selectedSegmentIndex];
    UIViewController *destVC = [embeddedVC objectAtIndex:1];
    if ([destVC isEqual:[NSNull null]]) {
        destVC = segue.destinationViewController;
        [embeddedVC replaceObjectAtIndex:1 withObject:destVC];
    }

    // If embedded VC already loaded, swap open, else do initial load and add child VC/subview
    if (self.childViewControllers.count > 0) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:destVC];
    }
    else {
        [self addChildViewController:segue.destinationViewController];
        UIView* destView = ((UIViewController *)segue.destinationViewController).view;
        destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.viewExploreContainer addSubview:destView];
        [segue.destinationViewController didMoveToParentViewController:self];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	DDLogVerbose(@"ContainerViewController - swapFromViewController\n from:%@\n to:%@", fromViewController, toViewController);
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}


#pragma mark UI Trip Button Methods

- (void)resetTripButtons
{
    self.labelButtonSave.textColor = [UIColor kColorButtonLabel];
    self.labelButtonSave.font = [UIFont systemFontOfSize:20];
    self.labelButtonSave.text = @"Save";
    self.imageButtonSave.image =
    [IonIcons imageWithIcon:icon_archive iconColor:[UIColor kColorButtonLabel] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
    //    [self.buttonSave setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
    self.viewButtonSave.hidden = YES;
    
    self.labelButtonStart.textColor = [UIColor kColorINatGreen];
    self.labelButtonStart.font = [UIFont systemFontOfSize:20];
    self.labelButtonStart.text = @"Start";
    self.imageButtonStart.image =
    [IonIcons imageWithIcon:icon_play iconColor:[UIColor kColorINatGreen] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
    self.viewButtonStart.hidden = YES;
}

- (void)updateTripButtons {
    [self resetTripButtons];
    if (_currentTrip) {
        if (_currentTrip.status.intValue == TripStatusCreated) {
            self.viewButtonSave.hidden = NO;
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusSaved) {
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusInProgress) {
            self.labelButtonStart.textColor = [UIColor orangeColor];
            self.labelButtonStart.font = [UIFont systemFontOfSize:20];
            self.labelButtonStart.text = @"Stop";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_stop iconColor:[UIColor orangeColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusFinished) {
            self.labelButtonStart.textColor = [UIColor cyanColor];
            self.labelButtonStart.font = [UIFont systemFontOfSize:12];
            self.labelButtonStart.text = @"Completed";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_upload iconColor:[UIColor cyanColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusPublished) {
            self.labelButtonStart.textColor = [UIColor blackColor];
            self.labelButtonStart.font = [UIFont systemFontOfSize:12];
            self.labelButtonStart.text = @"Published";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_checkmark iconColor:[UIColor blackColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
            self.viewButtonStart.hidden = NO;
        }
        self.viewButtonsPanel.hidden = NO;
    } else {
        self.viewButtonsPanel.hidden = YES;
    }
}

- (IBAction)actionSaveButton:(id)sender {
    if (!_currentTrip) {
        _currentTrip = [_tripsDataManager createTripFromOccurrenceResults:_occurrenceResults bcOptions:_bcOptions tripStatus:TripStatusSaved];
    } else {
        _currentTrip.status = [NSNumber numberWithInteger:TripStatusSaved];
        [self displayTripNameDialog];
    }
}

- (IBAction)actionStartButton:(id)sender {
    if (!_currentTrip) {
        if (![self checkUserLocationInsideArea:_currentUserLocation areaCenter:_bcOptions.searchOptions.searchAreaCentre areaSpan:[NSNumber numberWithUnsignedInteger:_bcOptions.searchOptions.searchAreaSpan]]) {
            [BCAlerts displayOKorCancelAlert:@"Location Warning!" message:@"Your Current Location Is Outside\nThe Search Area\n\nDo You Still Want To Start Trip?" okButtonTitle:@"OK" okBlock:^{
                [self finishStartNewTrip];
                return;
            } cancelButtonTitle:@"Cancel" cancelBlock:^{
                return;
            }];
        }
        [self finishStartNewTrip];
    } else {
        if (_currentTrip.status.intValue <= TripStatusSaved) {
            if (![self checkUserLocationInsideArea:_currentUserLocation areaCenter:_currentTrip.locationCoordinate areaSpan:[NSNumber numberWithInt:_currentTrip.searchAreaSpan.intValue]]) {
                [BCAlerts displayOKorCancelAlert:@"Location Warning!" message:@"Your Current Location Is Outside\nThe Search Area\n\nDo You Still Want To Start Trip?" okButtonTitle:@"OK" okBlock:^{
                    [self finishStartSavedTrip];
                    return;
                } cancelButtonTitle:@"Cancel" cancelBlock:^{
                    return;
                }];
            } else {
                [self finishStartSavedTrip];
            }
        } else if (_currentTrip.status.intValue == TripStatusInProgress){
            _currentTrip.status = [NSNumber numberWithInt:TripStatusFinished];
            _currentTrip.stopTime = [NSDate date];
            [BCLoggingHelper recordGoogleEvent:@"TripStatus" action:@"Finished"];
            
#ifdef TESTING
            _currentTrip.stopTime = [_currentTrip.startTime dateByAddingTimeInterval:kDefaultTripDuration];
#endif
        }
        
        if (_currentTrip.status.intValue == TripStatusFinished){
            [BCAlerts displayDefaultInfoAlert:@"Trip Completed" message:@"Please go to Trips screen (from main menu) to publish trip to iNat"];
        }
        
        [_tripsDataManager saveChanges];
    }
    [self finishActionStartButton];
}

- (void)finishStartNewTrip
{
    _currentTrip = [[TripsDataManager sharedInstance] createTripFromOccurrenceResults:_occurrenceResults bcOptions:_bcOptions tripStatus:TripStatusInProgress];
    _currentTrip.startTime = [NSDate date];
    [BCLoggingHelper recordGoogleEvent:@"TripStatus" action:@"Started"];
    [self finishActionStartButton];
}

- (void)finishStartSavedTrip
{
    if (_currentTrip.status.intValue == TripStatusCreated) {
        [self displayTripNameDialog];
    }
    _currentTrip.status = [NSNumber numberWithInt:TripStatusInProgress];
    _currentTrip.startTime = [NSDate date];
    [BCLoggingHelper recordGoogleEvent:@"TripStatus" action:@"Started"];
    [self finishActionStartButton];
}

- (void)finishActionStartButton
{
    if (_bcOptions.displayOptions.trackLocation) {
        if (_currentTrip.statusValue == TripStatusInProgress) {
            [BCLocationManager startRecordingTrack];
        } else if (_currentTrip.statusValue == TripStatusFinished) {
            [BCLocationManager stopRecordingTrack];
        }
    }
    
    [self updateTripButtons];
    [self refreshExploreContainerView];
}

- (BOOL)checkUserLocationInsideArea:(CLLocation *)userLocation areaCenter:(CLLocationCoordinate2D)center areaSpan:(NSNumber *)span
{
    DDLogDebug(@"UserLocation: %.6f, %.6f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    DDLogDebug(@"Search Area: %.6f, %.6f, %d", center.latitude, center.longitude, span.intValue/2);
    
    CLLocationDistance distance = [userLocation distanceFromLocation:[CLLocation initWithCoordinate:center]];
    if (!userLocation || distance > (span.intValue/2)) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (void)displayTripNameDialog {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Creating New Trip..." message:@"Enter name for trip\n(or accept default):" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.text = _currentTrip.title;
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter Trip Name:";
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *tripName = [alertView textFieldAtIndex:0].text;
    if (tripName.length > 0) {
        _currentTrip.title = tripName;
    }
    [_tripsDataManager saveChanges];
    [self updateTripButtons];
    [self refreshExploreContainerView];
    [BCAlerts displayDefaultSuccessNotification:@"New Trip Saved to Trips Page" subtitle:nil];
}

- (void)refreshExploreContainerView
{
    // Refresh Container View If Necessary (i.e. not MapView)
    if (self.segControlView.selectedSegmentIndex != 0) {
        NSMutableArray *embeddedVC = self.embeddedVCs[self.segControlView.selectedSegmentIndex];
        UIViewController *destVC = [embeddedVC objectAtIndex:1];
        [destVC removeFromParentViewController];
        [self segControlChanged:nil];
    }
}


@end
