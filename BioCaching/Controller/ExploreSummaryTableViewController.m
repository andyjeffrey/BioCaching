//
//  ExploreSummaryTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 06/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryTableViewController.h"
#import "ExploreContainerViewController.h"

@interface ExploreSummaryTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTotalResults;
@property (weak, nonatomic) IBOutlet UILabel *labelRetrieved;
@property (weak, nonatomic) IBOutlet UILabel *labelFiltered;
@property (weak, nonatomic) IBOutlet UILabel *labelRemoved;
@property (weak, nonatomic) IBOutlet UILabel *labelDisplayed;

@property (weak, nonatomic) IBOutlet UILabel *labelUniqueSpecies;
@property (weak, nonatomic) IBOutlet UILabel *labelKingdoms;
@property (weak, nonatomic) IBOutlet UILabel *labelPhylums;
@property (weak, nonatomic) IBOutlet UILabel *labelClasses;

@property (weak, nonatomic) IBOutlet UILabel *labelRecordTypes;
@property (weak, nonatomic) IBOutlet UILabel *labelRecordSources;
@property (weak, nonatomic) IBOutlet UILabel *labelUniqueLocations;

@end

@implementation ExploreSummaryTableViewController {
    ExploreContainerViewController *_exploreContVC;
    BCOptions *_bcOptions;
    NSArray *_filteredResults;
    NSArray *_tableData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _bcOptions = [BCOptions sharedInstance];
    [self setupUI];
    [self setupTableData];
}

- (void)viewWillAppear:(BOOL)animated
{
    _filteredResults = self.occurrenceResults.filteredResults;
    [self setupLabels];
    [self.tableView reloadData];
    
    _exploreContVC = (ExploreContainerViewController *)self.parentViewController.parentViewController;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _exploreContVC.viewButtonsPanel.frame.size.width, _exploreContVC.viewButtonsPanel.frame.size.height) ];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
}

- (void)setupTableData
{
    _tableData = @[@5, @3, @4];
}

- (void)setupLabels
{
    if (self.occurrenceResults) {
        [self.labelTotalResults setTextWithDefaults:[NSString stringWithFormat:@"%@", self.occurrenceResults.Count]];
        [self.labelRetrieved setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.Results.count]];
        NSUInteger removedCount = self.occurrenceResults.removedResults.count + self.currentTrip.removedRecords.count;
        [self.labelFiltered setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)_filteredResults.count]];
        [self.labelRemoved setTextWithDefaults:[NSString stringWithFormat:@"%lu", removedCount]];
        [self.labelDisplayed setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)(MIN(_bcOptions.displayOptions.displayPoints, self.currentTrip.occurrenceRecords.count))]];
        
        [self.labelUniqueSpecies setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonSpecies.count]];
        [self.labelKingdoms setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonKingdom.count]];
        [self.labelPhylums setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonPhylum.count]];
        [self.labelClasses setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonClass.count]];
        
        [self.labelRecordTypes setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordType.count]];
        [self.labelRecordSources setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordSource.count]];
        [self.labelUniqueLocations setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordLocation.count]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.occurrenceResults) {
        return 0;
    } else {
        return _tableData.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData[section] integerValue];
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    header.contentView.backgroundColor = [UIColor kColorTableHeaderBackgroundColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
