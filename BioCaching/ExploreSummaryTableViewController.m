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
    
    filteredResults = [self.occurrenceResults getFilteredResults:self.bcOptions.displayOptions limitToMapPoints:NO];
    
    self.labelRetrieved.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.Results.count];
    self.labelFiltered.text = [NSString stringWithFormat:@"%lu", (unsigned long)filteredResults.count];
    self.labelDisplayed.text = [NSString stringWithFormat:@"%lu", (unsigned long)(MIN(_bcOptions.displayOptions.displayPoints, filteredResults.count))];
    
    self.labelUniqueSpecies.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonSpecies.count];
    self.labelKingdoms.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonKingdom.count];
    self.labelPhylums.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonPhylum.count];
    self.labelClasses.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictTaxonClass.count];
    
    self.labelRecordTypes.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordType.count];
    self.labelRecordSources.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordSource.count];
    self.labelUniqueLocations.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.occurrenceResults.dictRecordLocation.count];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
