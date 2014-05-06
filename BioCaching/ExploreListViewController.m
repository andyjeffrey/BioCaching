//
//  ExploreListViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreListViewController.h"
#import "ExploreSummaryViewController.h"
#import "OccurrenceDetailsViewController.h"

@interface ExploreListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelOccurrenceCount;

@property (weak, nonatomic) IBOutlet UITableView *tableViewResults;

typedef enum {
    BCDetailsContainerViewSummary,
	BCDetailsContainerViewList,
} BCDetailsContainerView;

@end


@implementation ExploreListViewController {
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
    
    self.navigationController.navigationBarHidden = YES;
    
    _filteredResults = [self.occurrenceResults getFilteredResults:self.bcOptions.displayOptions limitToMapPoints:YES];
    
    [self setupLabels];
    [self setupTable];
    
}

- (void)setupLabels
{
    self.labelLocation.text = [NSString stringWithFormat:@"Location: %f,%f",
                               self.bcOptions.searchOptions.searchAreaCentre.latitude,
                               self.bcOptions.searchOptions.searchAreaCentre.longitude];
    
    self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %lum",
                               (unsigned long)self.bcOptions.searchOptions.searchAreaSpan];
    
    self.labelOccurrenceCount.text = [NSString stringWithFormat:@"Total Record Count: %d",
                                      self.occurrenceResults.Count.intValue];
    
}

- (void)setupTable
{
    self.tableViewResults.backgroundColor = [UIColor kColorTableBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableViewResults deselectRowAtIndexPath:[self.tableViewResults indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark IBActions


#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#ifdef DEBUG
    if (_bcOptions.displayOptions.displayPoints < _filteredResults.count)
    {
        return _bcOptions.displayOptions.displayPoints;
    }
#endif
    return _filteredResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    GBIFOccurrence *occurrence = _filteredResults[indexPath.row];

    cell.textLabel.text = occurrence.detailsMainTitle;

#ifndef DEBUG
    cell.detailTextLabel.text = occurrence.detailsSubTitle;
#else
//  TableViewCell with row index
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%03lu  %@", (long)indexPath.row, occurrence.detailsSubTitle];
#endif

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Row Selected: %lu", indexPath.row);
//    GBIFOccurrence *occurrence = _filteredResults[indexPath.row];
}


#pragma mark Storyboard Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@:%@ segue=%@", self.class, NSStringFromSelector(_cmd), segue.identifier);
//    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);

    if ([segue.identifier isEqualToString:@"SummaryEmbed"]) {
        ExploreSummaryViewController *summaryVC = segue.destinationViewController;
        summaryVC.occurrenceResults = self.occurrenceResults;
        summaryVC.bcOptions = self.bcOptions;
    } else if ([segue.identifier isEqualToString:@"OccurrenceDetails"]) {
        OccurrenceDetailsViewController *detailsVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableViewResults indexPathForSelectedRow];
//        NSLog(@"%@:%lu", selectedIndexPath, (long)selectedIndexPath.row);
        detailsVC.occurrence = _filteredResults[selectedIndexPath.row];
    }
    
}

@end
