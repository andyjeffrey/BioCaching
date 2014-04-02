//
//  OccurrenceDetailsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OccurrenceDetailsViewController.h"

@interface OccurrenceDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSpecies;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonFamily;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelObserver;
@property (weak, nonatomic) IBOutlet UILabel *labelInstitution;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@end

@implementation OccurrenceDetailsViewController

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
//    self.navigationController.navigationItem.title = @"Species Common Name";
    
    self.labelTaxonSpecies.text = self.occurrence.speciesBinomial;
    self.labelTaxonFamily.text = [NSString stringWithFormat:@"Class: %@   Family: %@", self.occurrence.Clazz, self.occurrence.Family];
    self.labelDate.text = [self.occurrence.OccurrenceDate substringToIndex:10];
    self.labelObserver.text = self.occurrence.CollectorName;
    self.labelInstitution.text = self.occurrence.InstitutionCode;
    self.labelLocation.text = self.occurrence.locationString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Species Common Name";
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
