//
//  ExploreSummaryViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryViewController.h"
#import "ExploreContainerViewController.h"
#import "ExploreSummaryTableViewController.h"
#import "TripSummaryTableViewController.h"
#import "TripsDataManager.h"
#import "ExploreDataManager.h"

@interface ExploreSummaryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelResultsCount;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation ExploreSummaryViewController {
    ExploreContainerViewController *_exploreContVC;
    ExploreSummaryTableViewController *exploreSummaryTableVC;
    TripSummaryTableViewController *tripSummaryTableVC;
    UIViewController *currentContainerVC;
    
    ExploreDataManager *_exploreDataManager;
    GBIFOccurrenceResults *_searchResults;
    TripsDataManager *_tripsDataManager;
    INatTrip *_currentTrip;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    _tripsDataManager = [TripsDataManager sharedInstance];

    [self setupContainerViews];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshCurrentData];
    [self refreshContainerViews];
    [self setupLabels];
    [_exploreContVC updateTripButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"ExploreSummary"];
}

#pragma mark Sidebar Methods
- (void)setupSidebar
{
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
}

- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}


#pragma mark - Setup UI/Refresh Methods
- (void)setupContainerViews
{
    exploreSummaryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreSummaryTable"];
    tripSummaryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TripSummaryTable"];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    //    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    [self setupSidebar];
}

- (void)refreshCurrentData
{
    _exploreContVC = (ExploreContainerViewController *)self.parentViewController;
    if (_exploreContVC.currentTrip != _tripsDataManager.currentTrip) {
        _exploreContVC.currentTrip = _tripsDataManager.currentTrip;
    }
    _currentTrip = _exploreContVC.currentTrip;
    
    _searchResults = [ExploreDataManager sharedInstance].currentSearchResults;
}

- (void)refreshContainerViews
{
    if (currentContainerVC) {
        [currentContainerVC.view removeFromSuperview];
        [currentContainerVC removeFromParentViewController];
    }
    
    if (_currentTrip && _currentTrip.status.integerValue > TripStatusCreated) {
        tripSummaryTableVC.currentTrip = _currentTrip;
        currentContainerVC = tripSummaryTableVC;
    } else {
        exploreSummaryTableVC.occurrenceResults = _searchResults;
        exploreSummaryTableVC.currentTrip = _currentTrip;
        currentContainerVC = exploreSummaryTableVC;
    }
    
    [self addChildViewController:currentContainerVC];
    currentContainerVC.view.frame = CGRectMake(0, 0, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height);
    [self.viewContainer addSubview:currentContainerVC.view];
    //    [exploreSummaryTableVC didMoveToParentViewController:self];
}

- (void)setupLabels
{
    [self.labelLocation setTextColor:[UIColor kColorHeaderText]];
    if (_currentTrip) {
        self.labelLocation.font = [UIFont systemFontOfSize:self.labelLocation.font.pointSize];
    } else {
        self.labelLocation.font = [UIFont italicSystemFontOfSize:self.labelLocation.font.pointSize];
        [self.labelLocation setText:@"No Active Search Results/Trip"];
    }

    [self.labelAreaSpan setTextWithColor:@"Area Span: " color:[UIColor kColorHeaderText]];
    [self.labelResultsCount setTextWithColor:@"Record Count: " color:[UIColor kColorHeaderText]];
    
    if (_currentTrip) {
        self.labelLocation.text = [CLLocation latLongStringFromCoordinate:_currentTrip.locationCoordinate];
        self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %@", _currentTrip.searchAreaSpan];
        self.labelResultsCount.text = [NSString stringWithFormat:@"Record Count: %d", (int)_currentTrip.occurrenceRecords.count];
    }
}

@end
