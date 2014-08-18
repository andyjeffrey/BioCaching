//
//  ObservationViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ObservationViewController.h"
#import "BCLocationManager.h"
#import "TripsDataManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ObservationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageIconicTaxon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonScientific;

@property (weak, nonatomic) IBOutlet UIButton *buttonDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

@property (weak, nonatomic) IBOutlet UIImageView *imageObsPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonUpdatePhoto;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

- (IBAction)buttonActionSave:(id)sender;
- (IBAction)buttonActionDelete:(id)sender;
- (IBAction)buttonActionUpdatePhoto:(id)sender;

@end

@implementation ObservationViewController {
    UIImagePickerController *imagePicker;
    ALAssetsLibrary *assetsLibrary;
    INatObservation *_observation;
    CLLocation *_obsLocation;
    NSString *_obsLocationText;
    BOOL _saveChanges;
    BCLocationManager *_locationManager;
    NSDate *eventTimer;
    BOOL _newObservation;
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
    
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    self.navigationItem.title = @"Your Observation";
    
//    // Changing of Navigation Back Button Here Not Working!
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:cancelButton];

    self.view.backgroundColor = [UIColor kColorTableBackgroundColor];
    self.imageObsPhoto.backgroundColor = [UIColor grayColor];
    
    _observation = self.occurrence.observation;
    if (!_observation) {
        _observation = [INatObservation createNewObservationFromOccurrence:self.occurrence];
        _observation.dateRecorded = [NSDate date];
        _newObservation = YES;
    }
    if (_observation.latitude && _observation.longitude) {
        _obsLocation = [CLLocation initWithCoordinate:_observation.coordinate];
    } else if (!self.locked) {
        [BCLocationManager getCurrentLocationWithDelegate:self];
        [self.activityLocation startAnimating];
    }

    [self setupButtons];
    [self setupLabels];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    if (imagePicker) {
        return;
    }
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"INatObservation"];
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (imagePicker) {
        //Transitioning to ImagePicker so don't save MOs
        return;
    }
    
    if (_saveChanges) {
        [[TripsDataManager sharedInstance] saveChanges];
        if (_newObservation) {
            [BCLoggingHelper recordGoogleEvent:@"Observation" action:[NSString stringWithFormat:@"Created: %d",  _observation.taxonId.intValue]];
        }
    } else {
        // Rollback Context
        [[TripsDataManager sharedInstance] rollbackChanges];
    }
    [_locationManager.locationManager stopUpdatingLocation];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupButtons
{
    [self.buttonDate setBackgroundImage:
     [IonIcons imageWithIcon:icon_calendar iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonDate.backgroundColor = [UIColor kColorButtonBackground];
    self.buttonDate.enabled = NO;
    
    [self.buttonLocation setBackgroundImage:
     [IonIcons imageWithIcon:icon_location iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonLocation.backgroundColor = [UIColor kColorButtonBackground];
    self.buttonLocation.enabled = NO;
    
    [self.buttonUpdatePhoto setBackgroundImage:
     [IonIcons imageWithIcon:icon_edit iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonUpdatePhoto.backgroundColor = [UIColor kColorButtonBackground];

    if (self.locked) {
        self.buttonUpdatePhoto.hidden = YES;
        self.buttonDelete.hidden = YES;
        [self.buttonSave setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (void)setupLabels
{
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
}

- (void)updateUI
{
    self.labelDate.text = [_observation.dateRecorded localDateTime];
    if (_obsLocation) {
        self.labelLocation.text = [_obsLocation latLongVerbose];
    } else if (!self.locked) {
        self.labelLocation.text = @"Searching For Location...";
    } else {
        self.labelLocation.text = @"No Location Recorded";
    }
    if (_observation.obsPhotos.count > 0) {
        // Reload Photo From Storage/Album
        INatObservationPhoto *obsPhoto = _observation.obsPhotos[0];
        [self loadImageFromLocalAsset:obsPhoto.localAssetUrl];
        self.buttonAddPhoto.hidden = YES;
        self.buttonUpdatePhoto.hidden = NO;
    } else {
        self.buttonAddPhoto.hidden = NO;
        self.buttonUpdatePhoto.hidden = YES;
    }
    if (self.locked) {
        self.buttonAddPhoto.hidden = YES;
        self.buttonUpdatePhoto.hidden = YES;
    }
}

- (void)updateObservation
{
    if (_obsLocation) {
        _observation.latitude = [NSNumber numberWithDouble:_obsLocation.coordinate.latitude];
        _observation.longitude = [NSNumber numberWithDouble:_obsLocation.coordinate.longitude];
    }
}


#pragma mark - LocationControllerDelegate
- (void)currentLocationUpdated:(CLLocation *)location
{
    NSLog(@"locationUpdated:%@ Accurracy:%d", [location latLongVerbose], (int)location.horizontalAccuracy);
    _obsLocation = location;
    [self updateObservation];
    if (location.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters) {
        [_locationManager.locationManager stopUpdatingLocation];
        [self.activityLocation stopAnimating];
    }
    [self updateUI];
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
    if (!self.locked) {
        [self updateObservation];
        [[TripsDataManager sharedInstance] addObservationToTripOccurrence:_observation occurrence:self.occurrence];
        _saveChanges = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonActionDelete:(id)sender {
    [[TripsDataManager sharedInstance] removeObservationFromTripOccurrence:_observation occurrence:self.occurrence];
    _saveChanges = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)buttonActionUpdatePhoto:(id)sender {
    UIActionSheet *photoSourceSelector = [[UIActionSheet alloc] init];
    [photoSourceSelector setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [photoSourceSelector addButtonWithTitle:NSLocalizedString(@"Take Photo",nil)];
        [photoSourceSelector addButtonWithTitle:NSLocalizedString(@"Choose Existing",nil)];
        [photoSourceSelector addButtonWithTitle:NSLocalizedString(@"Cancel",nil)];
        [photoSourceSelector setCancelButtonIndex:2];
    } else {
        [photoSourceSelector addButtonWithTitle:NSLocalizedString(@"Choose Existing",nil)];
        [photoSourceSelector addButtonWithTitle:NSLocalizedString(@"Cancel",nil)];
        [photoSourceSelector setCancelButtonIndex:1];
    }
    
    [photoSourceSelector showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSInteger sourceType;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
    } else {
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
    }

    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"MediaType: %@", mediaType);
    NSURL *photoAssetUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSString *photoAssetUrlString = photoAssetUrl.absoluteString;
    NSLog(@"URL: %@", photoAssetUrlString);

    [self dismissViewControllerAnimated:YES completion:nil];
    imagePicker = nil;

    UIImage *image = [info
                      objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.imageObsPhoto setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    self.imageObsPhoto.image = image;

    if (_observation.obsPhotos.count == 0) {
        [[TripsDataManager sharedInstance] addNewPhotoToTripObservation:photoAssetUrl.absoluteString observation:_observation];
    }
    INatObservationPhoto *obsPhoto = _observation.obsPhotos[0];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        obsPhoto.localAssetUrl = photoAssetUrlString;
        [self updateUI];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    NSLog(@"New Image Asset Saved: %@", assetURL);
                    obsPhoto.localAssetUrl = assetURL.absoluteString;
                } else {
                    NSLog(@"Error Saving New Photo From Camera: %@", error);
                }
            [self updateUI];
        }];
    }
}

- (void)image:(UIImage *)image finishedSavingPhotoToAlbum:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"finishedSavingPhotoToAlbum: %@", contextInfo);
}

- (void)loadImageFromLocalAsset:(NSString *)localAssetUrlString
{
    eventTimer = [NSDate date];
    NSURL *assetUrl = [NSURL URLWithString:localAssetUrlString];
    
    [assetsLibrary assetForURL:assetUrl resultBlock: ^(ALAsset *asset){
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullScreenImage];
//        CGImageRef imageRef = [representation fullResolutionImage];
        if (imageRef) {
            //TODO: Do something wiith orientation and scale if required?
            self.imageObsPhoto.image = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
            NSTimeInterval timeElapsed = [eventTimer timeIntervalSinceNow];
            NSLog(@"%.3f", timeElapsed);
            [BCLoggingHelper recordGoogleTiming:@"Device" name:@"LoadAsset" timing:timeElapsed];
            
//            [self updateUI];
        } else {
            //TODO: Add Alert/Label When Previously Saved Image Removed From Photo Store
        }
    } failureBlock: ^(NSError *error){
        // Error Loading Asset From Asset Library
        NSLog(@"Error Loading Asset: %@ %@", assetUrl, error);
        // Display Error Text (over imageView?)
    }];
}

@end
