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

static const int ddLogLevel = LOG_LEVEL_DEBUG;
static NSString *const kNotesPlaceholderText = @"[Observation Notes]";

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

@property (weak, nonatomic) IBOutlet UITextView *textViewNotes;

@property (weak, nonatomic) IBOutlet UIView *viewBottomButtons;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)buttonActionSave:(id)sender;
- (IBAction)buttonActionDelete:(id)sender;
- (IBAction)buttonActionUpdatePhoto:(id)sender;

@end

@implementation ObservationViewController {
    UIImagePickerController *imagePicker;
    ALAssetsLibrary *assetsLibrary;
    NSString *_currentPhotoAsset;
    INatObservation *_observation;
    CLLocation *_obsLocation;
    NSString *_obsLocationText;
    BOOL _saveChanges;
    BCLocationManager *_locationManager;
    NSDate *eventTimer;
    BOOL _newObservation;
    float _scrollViewHeight;
    BOOL _keyboardShown;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    _keyboardShown = NO;
    self.textViewNotes.delegate = self;

    assetsLibrary = [[ALAssetsLibrary alloc] init];

    [self.view setBackgroundColor:[UIColor kColorTableBackgroundColor]];
    self.navigationItem.title = @"Observation Record";
    
    self.viewBottomButtons.backgroundColor = [UIColor darkGrayColor];
    
    self.imageObsPhoto.backgroundColor = [UIColor darkGrayColor];
    
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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _scrollViewHeight = self.textViewNotes.frame.origin.y + self.textViewNotes.frame.size.height + kDefaultScrollviewHeightPadding;
    
    DDLogDebug(@"textViewNotes Bottom: %.0f", self.textViewNotes.frame.origin.y + self.textViewNotes.frame.size.height);
    DDLogDebug(@"scrollView Height: %.0f->%.0f", self.scrollView.frame.origin.y, self.scrollView.frame.size.height);
    DDLogDebug(@"scrollView Content Height: %.0f", self.scrollView.contentSize.height);
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, _scrollViewHeight)];
    
    DDLogDebug(@"scrollView Content Height: %.0f", self.scrollView.contentSize.height);
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
    
    if (imagePicker) {
        return;
    }

//    [self.navigationItem setTitle:@"Occurrence Details"];
    self.navigationController.navigationBarHidden = NO;
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"INatObservation"];
    [self.scrollView flashScrollIndicators];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

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
     [IonIcons imageWithIcon:icon_edit iconColor:[UIColor whiteColor] iconSize:28.0f imageSize:CGSizeMake(36.0f, 36.0f)] forState:UIControlStateNormal];
//    self.buttonUpdatePhoto.backgroundColor = [UIColor kColorTableBackgroundColor];
//    [self.buttonUpdatePhoto setBackgroundImage:[UIImage imageWithColor:[UIColor kColorTextViewBackgroundColor]] forState:UIControlStateNormal];

    [self.buttonDelete setBackgroundColor:[UIColor kColorDarkRed]];
    [self.buttonSave setBackgroundColor:[UIColor kColorDarkGreen]];
    
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
    
    [self updateLocationLabel];

    if (_observation.obsPhotos.count > 0) {
        // Reload Photo From Storage/Album If Necessary
        INatObservationPhoto *obsPhoto = _observation.obsPhotos[0];
        if (![_currentPhotoAsset isEqualToString:obsPhoto.localAssetUrl]) {
            [self loadImageFromLocalAsset:obsPhoto.localAssetUrl];
        }
    }
    [self updatePhotoButtons];
    
    [self updateTextViewPlaceholder];
    
    if (self.locked) {
        self.buttonAddPhoto.hidden = YES;
        self.buttonUpdatePhoto.hidden = YES;
    }
}

- (void)updateLocationLabel
{
    if (_obsLocation) {
        self.labelLocation.text = [_obsLocation latLongVerbose];
    } else if (!self.locked) {
        self.labelLocation.text = @"Searching For Location...";
    } else {
        self.labelLocation.text = @"No Location Recorded";
    }
}

- (void)updatePhotoButtons
{
    if (self.imageObsPhoto.image) {
        self.buttonAddPhoto.hidden = YES;
        self.buttonUpdatePhoto.hidden = NO;
    } else {
        self.buttonAddPhoto.hidden = NO;
        self.buttonUpdatePhoto.hidden = YES;
    }
}

- (void)updateTextViewPlaceholder
{
    if (!_observation.notes) {
        self.textViewNotes.text = kNotesPlaceholderText;
        self.textViewNotes.textColor = [UIColor lightTextColor];
        self.textViewNotes.font = [UIFont italicSystemFontOfSize:self.textViewNotes.font.pointSize];
    } else {
        self.textViewNotes.text = _observation.notes;
        self.textViewNotes.textColor = [UIColor whiteColor];
        self.textViewNotes.font = [UIFont systemFontOfSize:self.textViewNotes.font.pointSize];
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
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLocationLabel];
//    });
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

#pragma mark - UITextView Methods
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += keyboardSize.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    _keyboardShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (_keyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    [self.scrollView scrollRectToVisible:self.textViewNotes.frame animated:YES];
    _keyboardShown = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!_observation.notes) {
        _observation.notes = @"";
    }
    [self updateTextViewPlaceholder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _observation.notes = nil;
    } else {
        _observation.notes = textView.text;
    }
    [self updateTextViewPlaceholder];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
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

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    [self.imageObsPhoto setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    self.imageObsPhoto.image = image;
    [self updatePhotoButtons];

    if (_observation.obsPhotos.count == 0) {
        [[TripsDataManager sharedInstance] addNewPhotoToTripObservation:photoAssetUrl.absoluteString observation:_observation];
    }
    INatObservationPhoto *obsPhoto = _observation.obsPhotos[0];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        obsPhoto.localAssetUrl = photoAssetUrlString;
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        DDLogDebug(@"Saved image.imageOrientation: %d", image.imageOrientation);
        UIImage *normalizedImage = [image normalizedImage];
        [assetsLibrary writeImageToSavedPhotosAlbum:normalizedImage.CGImage orientation:(ALAssetOrientation)normalizedImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
//        [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                    NSLog(@"New Image Asset Saved: %@", assetURL);
                    obsPhoto.localAssetUrl = assetURL.absoluteString;
                    _currentPhotoAsset = obsPhoto.localAssetUrl;
                } else {
                    NSLog(@"Error Saving New Photo From Camera: %@", error);
                    [BCAlerts displayDefaultInfoAlert:@"Error Saving Image" message:@"Could Not Save Image\nTo Photo Library"];
                    _currentPhotoAsset = nil;
                    self.imageObsPhoto.image = nil;
                    [self updateUI];
                }
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
            _currentPhotoAsset = localAssetUrlString;
            
            DDLogDebug(@"Loaded image.imageOrientation: %d", representation.orientation);
            NSNumber *orientationValue = [[representation metadata] objectForKey:@"Orientation"];
            DDLogDebug(@"orientation from metadata: %d", orientationValue.intValue);
            NSNumber *orientationAsset = [asset valueForProperty:@"ALAssetPropertyOrientation"];
            DDLogDebug(@"orientation from asset: %d", orientationAsset.intValue);

            //TODO: Do something wiith orientation and scale if required?
//            self.imageObsPhoto.image = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
            self.imageObsPhoto.image = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:UIImageOrientationUp];
            NSTimeInterval timeElapsed = [eventTimer timeIntervalSinceNow] * -1;
            NSLog(@"%.3f", timeElapsed);
            [BCLoggingHelper recordGoogleTiming:@"Device" name:@"LoadAsset" timing:timeElapsed];
            
            [self updateUI];
        } else {
            // Previously Saved Image Removed From Photo Store
            DDLogDebug(@"CGImageRef=Nil: %@", assetUrl);
            [BCAlerts displayDefaultInfoAlert:@"Error Loading Photo" message:@"Original Photo Not Found"];
        }
    } failureBlock: ^(NSError *error){
        // Error Loading Asset From Asset Library
        DDLogDebug(@"Error Loading Asset: %@ %@", assetUrl, error);
        [BCAlerts displayDefaultInfoAlert:@"Error Loading Photo" message:@"Original Photo Not Found"];
    }];
}

@end
