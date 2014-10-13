//
//  ExploreSummaryViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryViewController.h"
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

    [self setupContainerViews];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshCurrentData];
    [self refreshContainerViews];
    [self setupLabels];
}

- (void)refreshCurrentData
{
    _searchResults = [ExploreDataManager sharedInstance].currentSearchResults;
    _currentTrip = [TripsDataManager sharedInstance].currentTrip;
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


- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"ExploreSummary"];
}


#pragma mark Sidebar Methods
- (void)setupSidebar
{
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
    [self.buttonSidebar setBackgroundImage:[IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
}

- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}


#pragma mark - Init/Setup Methods
- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    //    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    [self setupSidebar];
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

- (void)setupContainerViews
{
    exploreSummaryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreSummaryTable"];
    tripSummaryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TripSummaryTable"];
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedExploreSummary"]) {
        if ([TripsDataManager sharedInstance].currentTrip) {
            tripSummaryTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TripSummaryTable"];
        } else {
            exploreSummaryTableVC = segue.destinationViewController;
        }
    }
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
