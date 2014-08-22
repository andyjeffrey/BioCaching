//
//  TaxonInfoViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 01/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TaxonInfoViewController.h"
#import "OccurrenceDetailsViewController.h"
#import "OccurrenceTableViewControler.h"
#import "ObservationViewController.h"
#import "ImageCache.h"
#import "ExploreDataManager.h"
#import "TripsDataManager.h"

@interface TaxonInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageMainPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelPhotoCopyright;

@property (weak, nonatomic) IBOutlet UIImageView *imageIconicTaxon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonScientific;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;

@property (weak, nonatomic) IBOutlet UIView *viewOverlayMask;
@property (weak, nonatomic) IBOutlet UIView *viewRemoveButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageRemoveButton;

@property (weak, nonatomic) IBOutlet UIButton *buttonDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord;
@property (weak, nonatomic) IBOutlet UIButton *buttonRemove;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;

- (IBAction)buttonActionDelete:(id)sender;
- (IBAction)viewOccurrenceDetails:(id)sender;
- (IBAction)buttonActionRecord:(id)sender;
- (IBAction)buttonActionRemove:(id)sender;
- (IBAction)buttonActionCancel:(id)sender;

@end

@implementation TaxonInfoViewController {
    INatTrip *_currentTrip;
    INatObservation *_observation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (id)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    _currentTrip = [TripsDataManager sharedInstance].currentTrip;
    _observation = self.occurrence.taxaAttribute.observation;
    self.viewOverlayMask.hidden = YES;
    [self updateTaxonView];
    [self setupButtons];
    [self updateButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
//    [BCLoggingHelper recordGoogleScreen:@"TaxonInfo"];
}

- (void)setupButtons
{
    [self.buttonDelete setTitle:nil forState:UIControlStateNormal];
    [self.buttonDelete setBackgroundImage:
     [IonIcons imageWithIcon:icon_trash_a iconColor:[UIColor kColorButtonLabel] iconSize:20.0f imageSize:CGSizeMake(25.0f, 25.0f)] forState:UIControlStateNormal];
    [self.buttonDelete setBackgroundColor:[UIColor kColorDarkRed]];
    
    [self.buttonDetails setBackgroundImage:
     [IonIcons imageWithIcon:icon_information_circled iconColor:[UIColor kColorButtonLabel] iconSize:24.0f imageSize:CGSizeMake(30.0f, 30.0f)] forState:UIControlStateNormal];

    if (_currentTrip.status.intValue != TripStatusPublished) {
        if (!_observation) {
            [self.buttonRecord setTitle:@"Record" forState:UIControlStateNormal];
            [self.buttonRecord setBackgroundColor:[UIColor kColorDarkGreen]];
        } else {
            [self.buttonRecord setTitle:@"Edit" forState:UIControlStateNormal];
            [self.buttonRecord setBackgroundColor:[UIColor orangeColor]];
        }
    } else {
        [self.buttonRecord setTitle:@"View" forState:UIControlStateNormal];
        [self.buttonRecord setBackgroundColor:[UIColor orangeColor]];
    }
    [self.buttonRemove setBackgroundColor:[UIColor kColorDarkRed]];
    [self.buttonCancel setBackgroundColor:[UIColor kColorDarkGreen]];
}

- (void)updateButtons
{
    if (!self.viewOverlayMask.hidden) {
        self.buttonDetails.hidden = YES;
        self.buttonRecord.hidden = YES;
        self.buttonRemove.hidden = NO;
        self.buttonCancel.hidden = NO;
    } else {
        self.buttonDetails.hidden = !self.showDetailsButton;
        self.buttonRecord.hidden = (_currentTrip.status.intValue < TripStatusInProgress);
        if (_currentTrip.statusValue >= TripStatusFinished && !_observation) {
            self.buttonRecord.hidden = YES;
        }
        self.buttonRemove.hidden = YES;
        self.buttonCancel.hidden = YES;
    }
}

- (void)updateTaxonView
{
    INatTaxonPhoto *iNatTaxonPhoto;
    
    if (self.occurrence.iNatTaxon.taxonPhotos.count > 0) {
        iNatTaxonPhoto = self.occurrence.iNatTaxon.taxonPhotos[0];
        
        CGRect imageFrame = self.imageMainPhoto.frame;
        
        //        [self.imageMainPhoto setImageWithURL:[NSURL URLWithString:iNatTaxonPhoto.medium_url]];
        self.imageMainPhoto.image = [ImageCache getImageForURL:iNatTaxonPhoto.mediumUrl];
        if (self.imageMainPhoto.image.size.height > imageFrame.size.height) {
            self.imageMainPhoto.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self.imageMainPhoto.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        self.labelPhotoCopyright.text = iNatTaxonPhoto.attribution;
    } else {
        self.imageMainPhoto.image = nil;
        self.labelPhotoCopyright.text = nil;
    }
    
    self.imageIconicTaxon.image = [UIImage imageNamed:[self.occurrence getINatIconicTaxaMainImageFile]];
    
    if (self.occurrence.iNatTaxon.commonName) {
        self.labelTaxonTitle.text = self.occurrence.title;
        self.labelTaxonSubTitle.text = self.occurrence.subtitle;
        [self.labelTaxonTitle setTextColor:[self.occurrence getINatIconicTaxonColor]];
        self.labelTaxonTitle.hidden = NO;
        self.labelTaxonSubTitle.hidden = NO;
        self.labelTaxonScientific.hidden = YES;
    } else {
        self.labelTaxonScientific.text = self.occurrence.subtitle;
        [self.labelTaxonScientific setTextColor:[self.occurrence getINatIconicTaxonColor]];
        self.labelTaxonTitle.hidden = YES;
        self.labelTaxonSubTitle.hidden = YES;
        self.labelTaxonScientific.hidden = NO;
    }
    //    self.labelTaxonFamily.text = [NSString stringWithFormat:@"Class: %@   Family: %@", occurrence.Clazz, occurrence.Family];
}

- (IBAction)viewOccurrenceDetails:(id)sender {
//    OccurrenceDetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OccurrenceDetails"];
//    detailsVC.occurrence = self.occurrence;
//    [self.navigationController pushViewController:detailsVC animated:YES];
    
    OccurrenceTableViewControler *occurrenceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OccurrenceVC"];
    occurrenceVC.occurrence = self.occurrence;
    [self.navigationController pushViewController:occurrenceVC animated:YES];
}

- (IBAction)buttonActionRecord:(id)sender {
    ObservationViewController *observationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Observation"];
    observationVC.occurrence = self.occurrence;
    if (_currentTrip.status.intValue == TripStatusPublished) {
        observationVC.locked = YES;
    }
    
    [self.navigationController pushViewController:observationVC animated:YES];
}

- (IBAction)buttonActionRemove:(id)sender {
    [[TripsDataManager sharedInstance] removeOccurrenceFromTrip:self.occurrence.taxaAttribute.trip occurrence:self.occurrence];
    if (self.navigationController.topViewController == self.parentViewController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)buttonActionCancel:(id)sender {
    self.viewOverlayMask.hidden = YES;
    [self updateButtons];
}

- (IBAction)buttonActionDelete:(id)sender {
    self.viewOverlayMask.hidden = NO;
    [self updateButtons];
}

@end
