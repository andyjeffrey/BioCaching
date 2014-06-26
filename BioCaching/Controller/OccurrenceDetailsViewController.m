//
//  OccurrenceDetailsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OccurrenceDetailsViewController.h"
#import "TaxonInfoViewController.h"
#import "BCWebViewController.h"
#import "INatTaxonPhoto.h"

@interface OccurrenceDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageMainPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imageTaxonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSpecies;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonFamily;
@property (weak, nonatomic) IBOutlet UILabel *labelPhotoCopyright;

@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet NIAttributedLabel *labelDescription;
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

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.title = @"Occurrence Details";
    
//    [imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/r4uwx.jpg"] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    
    self.imageTaxonIcon.image = [UIImage imageNamed:[self.occurrence getINatIconicTaxaMainImageFile]];
    self.labelTaxonSpecies.text = self.occurrence.speciesBinomial;
    self.labelTaxonFamily.text = [NSString stringWithFormat:@"Class: %@   Family: %@", self.occurrence.Clazz, self.occurrence.Family];
    
    if (self.occurrence.iNatTaxon.taxonPhotos.count > 0)
    {
        iNatTaxonPhoto = self.occurrence.iNatTaxon.taxonPhotos[0];
        [self.imageMainPhoto setImageWithURL:[NSURL URLWithString:iNatTaxonPhoto.mediumUrl]];
        self.labelPhotoCopyright.text = iNatTaxonPhoto.attribution;
    }
    
    [self.labelDescription setHtml:self.occurrence.iNatTaxon.summaryText];
//    self.textViewDescription.text = self.occurrence.iNatTaxon.wikipedia_summary;
//    self.textViewDescription.textColor = [UIColor kColorTableCellText];

    self.labelDate.text = [self.occurrence.OccurrenceDate substringToIndex:10];
    self.labelObserver.text = self.occurrence.CollectorName;
    self.labelInstitution.text = self.occurrence.InstitutionCode;
    self.labelLocation.text = self.occurrence.locationString;
    self.labelINatTaxon.text = [self.occurrence.iNatTaxon.recordId stringValue];
}

- (void)viewWillAppear:(BOOL)animated
{
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
                           [self.occurrence.speciesBinomial stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Loading URL:%@", biblioURL);
    
    BCWebViewController *webController = [[BCWebViewController alloc] initWithURL:[NSURL URLWithString:biblioURL]];
    [webController setToolbarTintColor:[UIColor blackColor]];
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
