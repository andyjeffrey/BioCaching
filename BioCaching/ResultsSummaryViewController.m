//
//  ResultsSummaryViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 31/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ResultsSummaryViewController.h"

@interface ResultsSummaryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelRetrieved;
@property (weak, nonatomic) IBOutlet UILabel *labelFiltered;
@property (weak, nonatomic) IBOutlet UILabel *labelUniqueSpecies;
@property (weak, nonatomic) IBOutlet UILabel *labelKingdoms;
@property (weak, nonatomic) IBOutlet UILabel *labelPhylums;
@property (weak, nonatomic) IBOutlet UILabel *labelClasses;


@property (weak, nonatomic) IBOutlet UILabel *labelRecordTypes;
@property (weak, nonatomic) IBOutlet UILabel *labelRecordSources;
@property (weak, nonatomic) IBOutlet UILabel *labelUniqueLocations;

@end

@implementation ResultsSummaryViewController {
    NSArray *filteredResults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    filteredResults = [self.occurrenceResults getFilteredResults:self.tripOptions];
    NSLog (@"ResultsSummaryViewController:viewDidLoad");

    self.labelRetrieved.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.Results.count];
    self.labelFiltered.text = [NSString stringWithFormat:@"%lu", [self.occurrenceResults getFilteredResults:self.tripOptions].count];

    self.labelUniqueSpecies.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictTaxonSpecies.count];
    self.labelKingdoms.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.taxonKingdomCounts.count];
    self.labelPhylums.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.taxonPhylumCounts.count];
    self.labelClasses.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.taxonClassCounts.count];
    
    self.labelRecordTypes.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.recordTypeCounts.count];
    self.labelRecordSources.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.recordSourceCounts.count];
    self.labelUniqueLocations.text = [NSString stringWithFormat:@"%lu", self.occurrenceResults.dictRecordLocation.count];
        
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
