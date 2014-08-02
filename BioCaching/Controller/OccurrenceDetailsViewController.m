//
//  OccurrenceDetailsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OccurrenceDetailsViewController.h"
#import "BCWebViewController.h"
#import "INatTaxonPhoto.h"

@interface OccurrenceDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelObserver;
@property (weak, nonatomic) IBOutlet UILabel *labelInstitution;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelINatTaxon;

- (IBAction)buttonBibliog:(id)sender;

@end

@implementation OccurrenceDetailsViewController {
    TaxonInfoViewController *_taxonInfoVC;
    INatTaxonPhoto *iNatTaxonPhoto;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Occurrence Details";
    
    self.textViewDescription.hidden = YES;
    self.textViewDescription.text = self.occurrence.iNatTaxon.summaryText;
    self.textViewDescription.textColor = [UIColor kColorTableCellText];

    self.labelDescription.hidden = NO;
    [self.labelDescription setHtml:self.occurrence.iNatTaxon.summaryText];

    self.labelDate.text = [self.occurrence.dateRecorded localDate];
    self.labelObserver.text = self.occurrence.recordedBy;
    self.labelInstitution.text = self.occurrence.institutionCode;
    self.labelLocation.text = self.occurrence.locationString;
    self.labelINatTaxon.text = [self.occurrence.iNatTaxon.recordId stringValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

#pragma-mark IBActions
- (IBAction)buttonBibliog:(id)sender {
    NSString *biblioURL = [NSString stringWithFormat:@"%@%@%@",
                           kBHLBaseURL,
                           kBHLSpeciesBiblioPath,
                           [self.occurrence.taxonSpecies stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Loading URL:%@", biblioURL);
    
    BCWebViewController *webController = [[BCWebViewController alloc] initWithURL:[NSURL URLWithString:biblioURL]];
//    [webController setToolbarTintColor:[UIColor blackColor]];
    [self.navigationController pushViewController:webController animated:YES];
}



#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedTaxonInfo"]) {
        _taxonInfoVC = segue.destinationViewController;
        _taxonInfoVC.occurrence = self.occurrence;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
