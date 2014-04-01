//
//  ExploreDetailsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreDetailsViewController.h"
#import "ResultsSummaryViewController.h"

@interface ExploreDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelOccurrenceCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControlContainerView;
@property (weak, nonatomic) IBOutlet UIView *viewSummary;

typedef enum {
    BCDetailsContainerViewSummary,
	BCDetailsContainerViewList,
} BCDetailsContainerView;

@end


@implementation ExploreDetailsViewController {
    NSArray* _filteredResults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _filteredResults = [self.occurrenceResults getFilteredResults:self.tripOptions];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.labelLocation.text = [NSString stringWithFormat:@"Location: %f,%f",
                               self.tripOptions.searchAreaCentre.latitude,
                               self.tripOptions.searchAreaCentre.longitude];

    self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %lum",
                               self.tripOptions.searchAreaSpan];

    self.labelOccurrenceCount.text = [NSString stringWithFormat:@"Total Record Count: %d",
                                      self.occurrenceResults.Count.intValue];
    
    [self indexChangedForSegmentedControl:self.segControlContainerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark IBActions

- (IBAction)returnToMap:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)indexChangedForSegmentedControl:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == BCDetailsContainerViewSummary)
    {
        self.viewSummary.hidden = NO;
    }
    else
    {
        self.viewSummary.hidden = YES;
    }
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    GBIFOccurrence *occurrence = _filteredResults[indexPath.row];

    cell.textLabel.text = occurrence.detailsMainTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%03lu  %@", (long)indexPath.row, occurrence.detailsSubTitle];
    
    return cell;
}

#pragma mark Storyboard Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SummaryEmbed"]) {
        ResultsSummaryViewController *summaryVC = segue.destinationViewController;
        summaryVC.occurrenceResults = self.occurrenceResults;
        summaryVC.tripOptions = self.tripOptions;
    }
    
    
    NSLog(@"ExploreListViewController:prepareForSegue, segue: %@", segue.identifier);
}

@end
