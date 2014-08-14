//
//  ExploreSummaryViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryViewController.h"
#import "ExploreSummaryTableViewController.h"
#import "TripsDataManager.h"
#import "ExploreDataManager.h"

@interface ExploreSummaryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelResultsCount;

@end

@implementation ExploreSummaryViewController {
    ExploreSummaryTableViewController *summaryTableVC;
    ExploreDataManager *_exploreDataManager;
    GBIFOccurrenceResults *_searchResults;
    TripsDataManager *_tripsDataManager;
    INatTrip *_currentTrip;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self setupUI];
    _exploreDataManager = [ExploreDataManager sharedInstance];
    _tripsDataManager = [TripsDataManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    _searchResults = _exploreDataManager.currentSearchResults;
    _currentTrip = _tripsDataManager.currentTrip;
    [self setupLabels];
//    summaryTableVC.bcOptions = _bcOptions;
    summaryTableVC.occurrenceResults = _searchResults;
    summaryTableVC.currrentTrip = _currentTrip;
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
    //    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    // Change button color
    //    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];

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
    [self.labelLocation setTextWithColor:@"No Active Search Results/Trip" color:[UIColor kColorHeaderText]];
    [self.labelAreaSpan setTextWithColor:@"Area Span: " color:[UIColor kColorHeaderText]];
    [self.labelResultsCount setTextWithColor:@"Record Count: " color:[UIColor kColorHeaderText]];
    
    if (_currentTrip) {
        self.labelLocation.text = [CLLocation latLongStringFromCoordinate:_currentTrip.locationCoordinate];
        self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %@", _currentTrip.searchAreaSpan];
        self.labelResultsCount.text = [NSString stringWithFormat:@"Record Count: %d", (int)_currentTrip.occurrenceRecords.count];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedSummaryTable"]) {
        summaryTableVC = segue.destinationViewController;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
