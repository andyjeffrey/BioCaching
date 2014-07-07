//
//  ObservationViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ObservationViewController.h"
#import "LocationController.h"
#import "TripsDataManager.h"

@interface ObservationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageTaxonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubtitle;

@property (weak, nonatomic) IBOutlet UIButton *buttonDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;


@property (weak, nonatomic) IBOutlet UIImageView *imageObservation;
@property (weak, nonatomic) IBOutlet UIButton *buttonObservation;

- (IBAction)buttonActionSave:(id)sender;

@end

@implementation ObservationViewController {
    LocationController *_locationController;
    NSDate *_obsDate;
    CLLocation *_obsLocation;
    NSString *_obsLocationText;
    NSString *_notes;
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
    self.navigationItem.title = @"Record Observation";
    
    self.view.backgroundColor = [UIColor kColorTableBackgroundColor];
    
    _obsDate = [NSDate date];
    
    [self setupButtons];
    [self setupLabels];
    
    self.imageObservation.backgroundColor = [UIColor grayColor];
    
    _locationController = [LocationController sharedInstance];
    _locationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_locationController.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_locationController.locationManager stopUpdatingLocation];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupButtons
{
    [self.buttonDate setBackgroundImage:
     [IonIcons imageWithIcon:icon_calendar iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonDate.backgroundColor = [UIColor kColorButtonBackground];
    
    [self.buttonLocation setBackgroundImage:
     [IonIcons imageWithIcon:icon_location iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonLocation.backgroundColor = [UIColor kColorButtonBackground];
}

- (void)setupLabels
{
    self.imageTaxonIcon.image = [UIImage imageNamed:[self.occurrence getINatIconicTaxaMainImageFile]];
    self.labelTaxonTitle.text = self.occurrence.title;
    self.labelTaxonSubtitle.text = self.occurrence.subtitle;
    self.labelDate.text = [[NSDate date] localDateTime];
    self.labelLocation.text = @"";
}

- (void)updateLabels
{
    self.labelLocation.text = [_obsLocation latLongVerbose];
}


#pragma mark - LocationControllerDelegate
- (void)locationUpdated:(CLLocation *)location
{
    NSLog(@"locationUpdated:%@", [location latLongVerbose]);
    _obsLocation = location;
    [self updateLabels];
}

- (void)lookupLocation
{
        CLGeocoder *geocoder;

        if (!geocoder) {
             geocoder = [[CLGeocoder alloc] init];
         }
         [geocoder cancelGeocode];
    [geocoder reverseGeocodeLocation:_obsLocation completionHandler:^(NSArray *placemarks, NSError *error) {
             CLPlacemark *pm = [placemarks firstObject];
             if (pm) {
                 _obsLocationText = [[NSArray arrayWithObjects:
                                                 pm.name,
                                                 pm.locality,
                                                 pm.administrativeArea,
                                                 pm.ISOcountryCode,
                                                 nil]
                                                componentsJoinedByString:@", "];
             }
    }];
}

#pragma mark - IBActions
- (IBAction)buttonActionSave:(id)sender {
    INatObservation *observation = [INatObservation createNewObservationFromOccurrence:self.occurrence dateRecorded:_obsDate location:_obsLocation notes:_notes];
    [[TripsDataManager sharedInstance] addObservationToTripOccurrence:observation occurrence:self.occurrence trip:[TripsDataManager sharedInstance].currentTrip];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
