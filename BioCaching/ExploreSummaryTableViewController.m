//
//  ExploreSummaryTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 06/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreSummaryTableViewController.h"

@interface ExploreSummaryTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelRetrieved;
@property (weak, nonatomic) IBOutlet UILabel *labelFiltered;
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
    NSArray *filteredResults;
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
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    filteredResults = [self.occurrenceResults getFilteredResults:self.bcOptions.displayOptions limitToMapPoints:NO];
    [self setupLabels];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
}

- (void)setupLabels
{
    [self.labelRetrieved setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.Results.count]];
    [self.labelFiltered setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)filteredResults.count]];
    [self.labelDisplayed setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)(MIN(_bcOptions.displayOptions.displayPoints, filteredResults.count))]];
    
    [self.labelUniqueSpecies setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonSpecies.count]];
    [self.labelKingdoms setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonKingdom.count]];
    [self.labelPhylums setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonPhylum.count]];
    [self.labelClasses setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonClass.count]];
    
    [self.labelRecordTypes setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordType.count]];
    [self.labelRecordSources setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordSource.count]];
    [self.labelUniqueLocations setTextWithDefaults:[NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordLocation.count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
