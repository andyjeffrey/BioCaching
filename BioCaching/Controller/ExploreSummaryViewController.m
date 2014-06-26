//
//  ExploreSummaryViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryViewController.h"
#import "ExploreSummaryTableViewController.h"
#import "ExploreDataManager.h"

@interface ExploreSummaryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalResults;

@end

@implementation ExploreSummaryViewController {
    ExploreSummaryTableViewController *summaryTableVC;
    GBIFOccurrenceResults *_occurrenceResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    _occurrenceResults = [ExploreDataManager sharedInstance].occurrenceResults;
    [self setupLabels];
    summaryTableVC.bcOptions = _bcOptions;
    summaryTableVC.occurrenceResults = _occurrenceResults;
}

#pragma mark - Init/Setup Methods

- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    //    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    [self setupSidebar];
}

- (void)setupSidebar
{
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    // Change button color
    //    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
}

- (void)setupLabels
{    
    [self.labelLocation setTextWithColor:[NSString stringWithFormat:@"Location: %f,%f",
                               self.bcOptions.searchOptions.searchAreaCentre.latitude,
                                             self.bcOptions.searchOptions.searchAreaCentre.longitude] color:[UIColor kColorHeaderText]];
    
    [self.labelAreaSpan setTextWithColor:[NSString stringWithFormat:@"Area Span: %lum",
                                             (unsigned long)self.bcOptions.searchOptions.searchAreaSpan] color:[UIColor kColorHeaderText]];
    
    [self.labelTotalResults setTextWithColor:[NSString stringWithFormat:@"Record Count: %d",
                                                 (int)[_occurrenceResults getFilteredResults:YES].count] color:[UIColor kColorHeaderText]];
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
