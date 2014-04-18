//
//  OccurrenceDetailsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OccurrenceDetailsViewController.h"
#import "INatTaxonPhoto.h"

@interface OccurrenceDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelObserver;
@property (weak, nonatomic) IBOutlet UILabel *labelInstitution;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

@property (weak, nonatomic) IBOutlet UILabel *labelPhotoCopyright;
@property (weak, nonatomic) IBOutlet UIImageView *imageMainPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imageTaxonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSpecies;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonFamily;
@end

@implementation OccurrenceDetailsViewController {
    INatTaxonPhoto *iNatTaxonPhoto;
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

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationController.navigationItem.title = @"Common Name";
    self.navigationItem.title = self.occurrence.iNatTaxon.common_name;
    
//    [imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/r4uwx.jpg"] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
    
    self.imageTaxonIcon.image = [UIImage imageNamed:[self.occurrence getINatIconicTaxaMainImageFile]];
    self.labelTaxonSpecies.text = self.occurrence.speciesBinomial;
    self.labelTaxonFamily.text = [NSString stringWithFormat:@"Class: %@   Family: %@", self.occurrence.Clazz, self.occurrence.Family];
    
    iNatTaxonPhoto = self.occurrence.iNatTaxon.taxon_photos[0];
    [self.imageMainPhoto setImageWithURL:[NSURL URLWithString:iNatTaxonPhoto.medium_url]];
    self.labelPhotoCopyright.text = iNatTaxonPhoto.attribution;

    self.labelDate.text = [self.occurrence.OccurrenceDate substringToIndex:10];
    self.labelObserver.text = self.occurrence.CollectorName;
    self.labelInstitution.text = self.occurrence.InstitutionCode;
    self.labelLocation.text = self.occurrence.locationString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
