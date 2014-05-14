//
//  ExploreSummaryViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryViewController.h"
#import "ExploreSummaryTableViewController.h"

@interface ExploreSummaryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalResults;

@end

@implementation ExploreSummaryViewController {
    ExploreSummaryTableViewController *summaryTableVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupLabels];
    summaryTableVC.bcOptions = _bcOptions;
    summaryTableVC.occurrenceResults = _occurrenceResults;
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)setupLabels
{    
    [self.labelLocation setTextWithColor:[NSString stringWithFormat:@"Location: %f,%f",
                               self.bcOptions.searchOptions.searchAreaCentre.latitude,
                                             self.bcOptions.searchOptions.searchAreaCentre.longitude] color:[UIColor kColorHeaderText]];
    
    [self.labelAreaSpan setTextWithColor:[NSString stringWithFormat:@"Area Span: %lum",
                                             (unsigned long)self.bcOptions.searchOptions.searchAreaSpan] color:[UIColor kColorHeaderText]];
    
    [self.labelTotalResults setTextWithColor:[NSString stringWithFormat:@"Total Record Count: %d",
                                                 self.occurrenceResults.Count.intValue] color:[UIColor kColorHeaderText]];
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
