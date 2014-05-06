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


@end

@implementation ExploreSummaryViewController {
    NSArray *filteredResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    filteredResults = [self.occurrenceResults getFilteredResults:self.bcOptions.displayOptions limitToMapPoints:NO];

        
/*
    self.labelRetrieved.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.Results.count];
    self.labelFiltered.text = [NSString stringWithFormat:@"%lu", [self.occurrenceResults getFilteredResults:self.tripOptions].count];
    
    self.labelUniqueSpecies.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictTaxonSpecies.count];
    self.labelKingdoms.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictTaxonKingdom.count];
    self.labelPhylums.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictTaxonPhylum.count];
    self.labelClasses.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictTaxonClass.count];
    
    self.labelRecordTypes.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictRecordType.count];
    self.labelRecordSources.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictRecordSource.count];
*/
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedSummaryTable"]) {
        ExploreSummaryTableViewController *summaryTableVC = segue.destinationViewController;
        summaryTableVC.bcOptions = _bcOptions;
        summaryTableVC.occurrenceResults = _occurrenceResults;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
