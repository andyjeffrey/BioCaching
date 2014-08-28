//
//  OccurrenceTableViewControler.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OccurrenceTableViewControler.h"
#import "TaxonInfoViewController.h"
#import "BCWebViewController.h"

@interface OccurrenceTableViewControler ()

@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelDescMore;
@property (weak, nonatomic) IBOutlet BCButtonRounded *buttonDescMore;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelObserver;
@property (weak, nonatomic) IBOutlet UILabel *labelInstitution;

@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonGBIFID;
@property (weak, nonatomic) IBOutlet UIButton *buttonINATID;

- (IBAction)buttonActionBiblio:(id)sender;
- (IBAction)buttonActionDescMore:(id)sender;
- (IBAction)buttonActionLocation:(id)sender;
- (IBAction)buttonActionGBIFID:(id)sender;
- (IBAction)buttonActionINATID:(id)sender;

@end

@implementation OccurrenceTableViewControler {
    TaxonInfoViewController *_taxonInfoVC;
}

- (id)init {
    self = [super init];
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Occurrence Details";

//    self.navigationItem.title = @"Occurrence Details";
//    self.navigationController.navigationBar.barTintColor = [UIColor kColorHeaderBackground];
//    self.navigationController.navigationBar.tintColor = [UIColor kColorHeaderText];
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor kColorHeaderText], UITextAttributeTextColor, nil];

    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];

    self.labelDescription.hidden = NO;
    [self.labelDescription setHtml:self.occurrence.iNatTaxon.summaryText];
//    self.labelDescMore.backgroundColor = [UIColor kColorTableBackgroundColor];
//    self.labelDescMore.hidden = NO;
    self.buttonDescMore.backgroundColor = [UIColor kColorTableBackgroundColor];
    self.buttonDescMore.hidden = NO;
    
    self.labelDate.text = [self.occurrence.dateRecorded localDate];
    self.labelObserver.text = self.occurrence.recordedBy;
    self.labelInstitution.text = self.occurrence.institutionCode;
    
    [self.buttonLocation setTitle:self.occurrence.locationString forState:UIControlStateNormal];
    [self.buttonGBIFID setTitle:self.occurrence.gbifId.stringValue forState:UIControlStateNormal];
    [self.buttonINATID setTitle:self.occurrence.iNatTaxon.recordId.stringValue forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    // TaxonInfoVC:viewWillAppear not automatically called on when embedded in TableVC so invoke manually to setup view with Taxon details
    [_taxonInfoVC viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"Occurrence"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Include extra details for testing
#ifdef TESTING
    return 3;
#else
    return 2;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If shorter Pre-iPhone5 display, use alternative layout for main details table section (section#1)
/*
    if (!IS_IPHONE5 && (indexPath.section == 1)) {
        NSLog(@"Using Pre-iPhone5 Table Section, Row Height:");
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:3];
    }
*/
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    // If shorter Pre-iPhone5 display, use alternative layout for main details table section (section#1)
    if (!IS_IPHONE5 && (indexPath.section == 1) && (indexPath.row == 0)) {
        NSLog(@"Using Pre-iPhone5 Table Section, Row Height:");
        [self.labelDescription setNumberOfLines:2];
        [self.labelDescription sizeToFit];
        rowHeight = 50;
    }
    
    return rowHeight;
}


#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedTaxonInfo"]) {
        _taxonInfoVC = segue.destinationViewController;
        _taxonInfoVC.occurrence = self.occurrence;
    }
}

#pragma-mark IBActions
- (IBAction)buttonActionBiblio:(id)sender {
    NSString *biblioURL = [NSString stringWithFormat:@"%@%@%@",
                           kBHLBaseURL,
                           kBHLSpeciesBiblioPath,
                           [self.occurrence.taxonSpecies stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Loading URL:%@", biblioURL);
    
    BCWebViewController *webController = [[BCWebViewController alloc] initWithURL:[NSURL URLWithString:biblioURL] fixedTitle:@"Species Bibliograpy"];
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)buttonActionDescMore:(id)sender {
}

- (IBAction)buttonActionLocation:(id)sender {
    NSString *urlLocation = [NSString stringWithFormat:@"http://www.google.com/maps?q=%.6f,%.6f", self.occurrence.latitude.doubleValue, self.occurrence.longitude.doubleValue];

    NSLog(@"Loading URL:%@", urlLocation);
    
    BCWebViewController *webController = [[BCWebViewController alloc] initWithURL:[NSURL URLWithString:urlLocation]];
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)buttonActionGBIFID:(id)sender {
    NSString *urlGBIF = [NSString stringWithFormat:@"%@%@%@",
                           kGBIFBaseURL,
                           @"occurrence/",
                         self.occurrence.gbifId.stringValue];
    NSLog(@"Loading URL:%@", urlGBIF);
    
    BCWebViewController *webController = [[BCWebViewController alloc] initWithURL:[NSURL URLWithString:urlGBIF] fixedTitle:@"GBIF Record"];
    [self.navigationController pushViewController:webController animated:YES];
}

- (IBAction)buttonActionINATID:(id)sender {
    NSString *urlINAT = [NSString stringWithFormat:@"%@%@%@.json",
                         kINatBaseURL,
                         @"taxa/",
                         self.occurrence.iNatTaxon.recordId.stringValue];
    NSLog(@"Loading URL:%@", urlINAT);
    
    BCWebViewController *webController = [[BCWebViewController alloc] initWithURL:[NSURL URLWithString:urlINAT] fixedTitle:@"iNat Taxon Record"];
    [self.navigationController pushViewController:webController animated:YES];
}

@end
