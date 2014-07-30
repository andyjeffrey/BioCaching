//
//  ExploreMapViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreMapViewController.h"
#import "ExploreListViewController.h"
#import "ExploreOptionsViewController.h"
#import "TaxonInfoViewController.h"

#import "MapViewLayoutGuide.h"
#import "CrossHairView.h"
#import "LocationsArray.h"
#import "BCOptions.h"

#import "INatTaxon.h"
#import "INatTaxonPhoto.h"
#import "ImageCache.h"
#import "TripsDataManager.h"

#import "ExploreDataManager.h"
#import "GBIFOccurrenceResults.h"

static float const kOccurrenceAnnotationOffset = 50.0f;

@interface ExploreMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet CrossHairView *viewMapCrossHair;
@property (weak, nonatomic) IBOutlet UIView *viewMapAnnotationRefFrame;

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityViewLocationSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocationList;
@property (weak, nonatomic) IBOutlet UIView *viewDropDownRef;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefreshSearch;

@property (weak, nonatomic) IBOutlet UIView *viewSearchResults;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelResultsCount;

@property (weak, nonatomic) IBOutlet UIButton *buttonMaptype;
@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;
@property (weak, nonatomic) IBOutlet UIButton *buttonCurrentLocation;
- (IBAction)actionMaptype:(id)sender;
- (IBAction)actionSettings:(id)sender;
- (IBAction)actionCurrentLocation:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewButtonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIImageView *imageButtonSave;
@property (weak, nonatomic) IBOutlet UILabel *labelButtonSave;
- (IBAction)buttonSave:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewButtonStart;
@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIImageView *imageButtonStart;
@property (weak, nonatomic) IBOutlet UILabel *labelButtonStart;
- (IBAction)buttonStart:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewTaxonInfo;

//@property (nonatomic, strong) UIView *viewBackgroundControls;

@end

@implementation ExploreMapViewController
{
    BCOptions *_bcOptions;
    TaxonInfoViewController *_taxonInfoVC;
    CGRect _taxonInfoRefFrame;
    
    DropDownViewController *_dropDownViewLocations;
    UIView *_viewBackgroundControls;
    
    BOOL _mapViewLoaded;
    BOOL _updateMapView;
    BOOL _searchInProgress;
    CLLocation *_currentUserLocation;
    CLLocationCoordinate2D _currentViewCoordinate;
    
    MKPolygon *_currentSearchAreaPolygon;
    MKCircle *_currentSearchAreaCircle;
    
    ExploreDataManager *_exploreDataManager;
    GBIFOccurrenceResults *_occurrenceResults;
    
    TripsDataManager *_tripsDataManager;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: Remove from here (passed in from parent/container controller)
    _bcOptions = [BCOptions sharedInstance];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabicon-search-solid"];
    
    [self setupSidebar];
    [self setupButtons];
    [self setupTaxonInfoView];
    
    self.mapView.showsUserLocation = YES;
    
    if (!self.mapView.userLocation.location) {
        self.labelLocationDetails.text = @"Searching For Location...";
        [self.activityViewLocationSearch startAnimating];
    }
    
#ifdef TESTING
    // Go to preset location
    _currentViewLocation = LocationsArray.defaultLocation;
    [self updateLocationLabelAndMapView:_currentViewLocation mapViewSpan:[LocationsArray locationViewSpan:LocationsArray.defaultLocationIndex]];
    
    _bcOptions.searchOptions.searchAreaSpan = [LocationsArray locationSearchAreaSpan:LocationsArray.defaultLocationIndex];
    [self updateSearchAreaOverlay:_currentViewLocation areaSpan:_bcOptions.searchOptions.searchAreaSpan];
#endif
    
    [self configureGestureRecognizers];
    self.mapView.delegate = self;
    
    _exploreDataManager = [ExploreDataManager sharedInstance];
    _exploreDataManager.delegate = self;
    
    _tripsDataManager = [TripsDataManager sharedInstance];
    _tripsDataManager.exploreDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    // Force ExploreMapVC To Always Show Current Trip?
    if (_currentTrip != _tripsDataManager.currentTrip) {
        _updateMapView = YES;
        _currentTrip = _tripsDataManager.currentTrip;
    }
    [self updateSearchResultsView];
    [self updateButtons];
    [self updateMapType];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (_currentTrip && _updateMapView) {
        // Update Add Trip Occurrence Annotations
        [self updateOccurrenceAnnotations:_currentTrip.occurrenceRecords];
        // Update Trip Search Area Overlay
        [self updateSearchAreaOverlay:_currentTrip.locationCoordinate areaSpan:_currentTrip.searchAreaSpan.doubleValue];
        // Move/Zoom Map To Trip Search Area
        [self updateCurrentMapView:_currentTrip.locationCoordinate latitudinalMeters:0 longitudinalMeters:_currentTrip.searchAreaSpan.doubleValue];
        _updateMapView = NO;
    }
    [self configureLocationDropDown];
    [self configureBackgroundControlsView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark Init/UI Setup Methods

- (void)setupButtons
{
    self.viewTopBar.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
    
    [self.buttonRefreshSearch setTitle:nil forState:UIControlStateNormal];
    [self.buttonRefreshSearch setBackgroundImage:
     [IonIcons imageWithIcon:icon_refresh iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonRefreshSearch.backgroundColor = [UIColor kColorButtonBackground];
    
    self.buttonLocationList.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    self.labelLocationDetails.textColor = [UIColor kColorButtonLabel];
    
    self.buttonSettings.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
    [self.buttonSettings setBackgroundImage:
     [IonIcons imageWithIcon:icon_gear_b iconColor:[UIColor whiteColor] iconSize:28.0f imageSize:CGSizeMake(30.0f, 30.0f)] forState:UIControlStateNormal];
    
    [self resetTripButtons];
}

- (void)setupTaxonInfoView
{
    _taxonInfoRefFrame = self.viewTaxonInfo.frame;
    self.viewTaxonInfo.hidden = YES;
    self.viewTaxonInfo.alpha = 0.0f;
}

- (void)configureLocationDropDown
{
    _dropDownViewLocations = [[DropDownViewController alloc] initWithArrayData:[LocationsArray displayStringsArray] refFrame:[self.view.superview convertRect:self.viewDropDownRef.frame fromView:self.viewDropDownRef.superview] tableViewHeight:260 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    [self.view addSubview:_dropDownViewLocations.view];
    _dropDownViewLocations.delegate = self;
}

- (void)configureBackgroundControlsView
{
    //    _viewBackgroundControls = [[UIView alloc] initWithFrame:self.view.frame];
    _viewBackgroundControls = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    _viewBackgroundControls.backgroundColor = [UIColor blackColor];
    _viewBackgroundControls.alpha = 0.3f;
    _viewBackgroundControls.hidden = YES;
    [self.view insertSubview:_viewBackgroundControls belowSubview:_dropDownViewLocations.view];
    
    UIGestureRecognizer *uiControlViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBackgroundControlsClick:)];
    //    singleTapRecognizer.delaysTouchesBegan = YES;
    //    singleTapRecognizer.numberOfTapsRequired = 1;
    [_viewBackgroundControls addGestureRecognizer:uiControlViewTapRecognizer];
}

- (void)configureGestureRecognizers
{
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapSingleClick:)];
    //    singleTapRecognizer.delaysTouchesBegan = YES;
    //    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapDoubleClick:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    //    doubleTapRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:doubleTapRecognizer];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
}


#pragma mark UI Update Methods

- (void)resetTripButtons
{
    self.labelButtonStart.text = @"Save";
    self.imageButtonSave.image =
    [IonIcons imageWithIcon:icon_archive iconColor:[UIColor kColorBCButtonLabel] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
    //    [self.buttonSave setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
    self.viewButtonSave.hidden = YES;
    
    self.labelButtonStart.textColor = [UIColor kColorINatGreen];
    self.labelButtonStart.font = [UIFont systemFontOfSize:20];
    self.labelButtonStart.text = @"Start";
    self.imageButtonStart.image =
    [IonIcons imageWithIcon:icon_play iconColor:[UIColor kColorINatGreen] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
    self.viewButtonStart.hidden = YES;
}

- (void)updateButtons {
    [self resetTripButtons];
    if (_currentTrip) {
        if (_currentTrip.status.intValue == TripStatusCreated) {
            self.viewButtonSave.hidden = NO;
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusSaved) {
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusInProgress) {
            self.labelButtonStart.textColor = [UIColor orangeColor];
            self.labelButtonStart.font = [UIFont systemFontOfSize:20];
            self.labelButtonStart.text = @"Stop";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_stop iconColor:[UIColor orangeColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusFinished) {
            self.labelButtonStart.textColor = [UIColor cyanColor];
            self.labelButtonStart.font = [UIFont systemFontOfSize:12];
            self.labelButtonStart.text = @"Completed";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_upload iconColor:[UIColor cyanColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
            self.viewButtonStart.hidden = NO;
        } else if (_currentTrip.status.intValue == TripStatusPublished) {
            self.labelButtonStart.textColor = [UIColor blackColor];
            self.labelButtonStart.font = [UIFont systemFontOfSize:12];
            self.labelButtonStart.text = @"Published";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_checkmark iconColor:[UIColor blackColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
            self.viewButtonStart.hidden = NO;
        }
    }
}

- (void)updateMapType
{
    switch ((MKMapType)_bcOptions.displayOptions.mapType) {
        case MKMapTypeSatellite:
            [self.buttonMaptype setTitle:@"Satellite" forState:UIControlStateNormal];
            break;
        case MKMapTypeHybrid:
            [self.buttonMaptype setTitle:@"Hybrid" forState:UIControlStateNormal];
            break;
        default:
            [self.buttonMaptype setTitle:@"Standard" forState:UIControlStateNormal];
            break;
    }
    self.mapView.mapType = _bcOptions.displayOptions.mapType;
}

- (void)updateLocationLabelAndMapView:(CLLocationCoordinate2D)location mapViewSpan:(NSInteger)viewSpan
{
    [self updateLocationLabel:location horizAccuracy:0];
    [self updateCurrentMapView:location latitudinalMeters:0 longitudinalMeters:viewSpan];
}

- (void)updateLocationLabelAndMapView:(CLLocationCoordinate2D)location
{
    [self updateLocationLabelAndMapView:location mapViewSpan:kDefaultViewSpan];
}

- (void)updateLocationLabel:(CLLocationCoordinate2D)location horizAccuracy:(double)accuracy {
    //    self.labelLocationDetails.text = [NSString stringWithFormat:@"Lat: %f Long: %f Acc: %.1fm",
    self.labelLocationDetails.text = [CLLocation latLongStringFromCoordinate:location];
}

- (void)updateSearchResultsView
{
    if (!_currentTrip) {
        self.viewSearchResults.hidden = YES;
    } else {
        self.viewSearchResults.hidden = NO;
    }
    [self updateAreaSpanLabel];
    [self updateRecordCountLabel];
}

- (void)updateAreaSpanLabel
{
    self.labelAreaSpan.text = [NSString stringWithFormat:@"Search Span: %@m", _currentTrip.searchAreaSpan];
}

- (void)updateRecordCountLabel
{
    if (_currentTrip) {
        [self updateRecordCountLabel:(int)_currentTrip.occurrenceRecords.count];
    } else {
        [self updateRecordCountLabel:0];
    }
}

- (void)updateRecordCountLabel:(int)recordCount
{
    self.labelResultsCount.text = [NSString stringWithFormat:@"Record Count: %d", recordCount];
}

- (void)updateSearchAreaOverlay:(CLLocationCoordinate2D)location areaSpan:(double)areaSpan
{
    [self updateSearchAreaOverlay:location latitudeSpan:areaSpan/2 longitudeSpan:areaSpan/2];
}

- (void)updateSearchAreaOverlay:(CLLocationCoordinate2D)location latitudeSpan:(double)latSpan longitudeSpan:(double)longSpan
{
    if (_currentSearchAreaPolygon) {
        [self.mapView removeOverlay:_currentSearchAreaPolygon];
        _currentSearchAreaPolygon = nil;
    }
    
    if (_currentSearchAreaCircle) {
        [self.mapView removeOverlay:_currentSearchAreaCircle];
        _currentSearchAreaCircle = nil;
    }
    
    // Polygon (square) area overlay
    MKCoordinateRegion searchRegion = MKCoordinateRegionMakeWithDistance(location, latSpan, longSpan);
    MKCoordinateSpan searchSpan = searchRegion.span;
    CLLocationCoordinate2D searchPolygonCoords[5] = {
        CLLocationCoordinate2DMake(location.latitude - searchSpan.latitudeDelta, location.longitude - searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude - searchSpan.latitudeDelta, location.longitude + searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude + searchSpan.latitudeDelta, location.longitude + searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude + searchSpan.latitudeDelta, location.longitude - searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude - searchSpan.latitudeDelta, location.longitude - searchSpan.longitudeDelta)};
    
    _currentSearchAreaPolygon = [MKPolygon polygonWithCoordinates:searchPolygonCoords count:5];
    //    [self.mapView addOverlay:_currentSearchAreaPolygon];
    NSLog(@"%s SearchArea=%@", __PRETTY_FUNCTION__, _currentSearchAreaPolygon);
    
    // Circle area overlay
    _currentSearchAreaCircle = [MKCircle circleWithCenterCoordinate:location radius:longSpan];
    [self.mapView addOverlay:_currentSearchAreaCircle];
}


- (void)updateOccurrenceAnnotations:(NSArray *)occurrences
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (int i = 0; i < occurrences.count; i++) {
        [self addOccurrenceAnnotation:occurrences[i]];
    }
}

- (void)addOccurrenceAnnotation:(GBIFOccurrence *)occurrence
{
    [self.mapView addAnnotation:occurrence];
}

- (void)updateCurrentMapView:(CLLocationCoordinate2D)location latitudinalMeters:(NSInteger)latRegionSpan longitudinalMeters:(NSInteger)longRegionSpan
{
/*
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Location:(%.6f,%.6f)", location.latitude, location.longitude);
    NSLog(@"MapView CenterCoords:(%.6f,%.6f)", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    NSLog(@"MapView CenterPoint:(%.0f,%.0f)", self.mapView.center.x, self.mapView.center.y);
    NSLog(@"CrossHair CenterPoint:(%.0f,%.0f)", self.viewMapCrossHair.center.x , self.viewMapCrossHair.center.y);
    NSLog(@"VC Frame:%@", self.view.description);
    NSLog(@"MapView Frame:%@", self.mapView.description);
*/
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, latRegionSpan, longRegionSpan);
    [self.mapView setRegion:region animated:YES];
/*
    NSLog(@"Region: center=(%.6f,%.6f) span=(%.20f,%.20f)", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
    NSLog(@"MapView CenterCoords:(%.6f,%.6f)", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    NSLog(@"MapView CenterPoint:(%.0f,%.0f)", self.mapView.center.x, self.mapView.center.y);
    NSLog(@"CrossHair CenterPoint:(%.0f,%.0f)", self.viewMapCrossHair.center.x , self.viewMapCrossHair.center.y);
    
    NSLog(@"%@", [self.topLayoutGuide debugDescription]);
    NSLog(@"%@", [self.bottomLayoutGuide debugDescription]);
*/
}

- (void)showTaxonView
{
    [_taxonInfoVC viewWillAppear:YES];
    if (self.viewTaxonInfo.hidden) {
        self.viewTaxonInfo.hidden = NO;
        CGRect startFrame = CGRectMake(_taxonInfoRefFrame.origin.x, _taxonInfoRefFrame.origin.y + _taxonInfoRefFrame.size.height, _taxonInfoRefFrame.origin.x + _taxonInfoRefFrame.size.width, _taxonInfoRefFrame.size.height);
        self.viewTaxonInfo.frame = startFrame;
        [UIView animateWithDuration:0.5f animations:^{
            self.viewTaxonInfo.frame = _taxonInfoRefFrame;
            self.viewTaxonInfo.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hideTaxonView
{
    if (!self.viewTaxonInfo.hidden) {
        CGRect endFrame = CGRectMake(_taxonInfoRefFrame.origin.x, _taxonInfoRefFrame.origin.y + _taxonInfoRefFrame.size.height, _taxonInfoRefFrame.origin.x + _taxonInfoRefFrame.size.width, _taxonInfoRefFrame.size.height);
        
        [UIView animateWithDuration:0.5f animations:^{
            self.viewTaxonInfo.frame = endFrame;
            self.viewTaxonInfo.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.viewTaxonInfo.hidden = YES;
        }];
    }
}


#pragma mark IBActions
- (IBAction)buttonLocationSelect:(id)sender {
    /*
     [self activateUIControls:FALSE];
     */
    NSLog(@"buttonLocationSelect");
    [self hideTaxonView];
    _viewBackgroundControls.hidden = NO;
    [_dropDownViewLocations openAnimation];
    [_dropDownViewLocations.uiTableView flashScrollIndicators];
}

- (IBAction)buttonRefreshSearch:(id)sender
{
    [self hideTaxonView];
    
    if (![ConnectionHelper checkNetworkConnectivityAndDisplayAlert:YES]) {
        return;
    }
    
    if (_currentTrip && _currentTrip.status.intValue < (int)TripStatusSaved) {
        [BCAlerts displayOKorCancelAlert:@"New Search - Are You Sure?" message:@"Warning! - This will overwrite records\nfrom your previous search.\nPress Cancel then Save (or Start)\na trip to keep current results" okBlock:^{
            [_tripsDataManager discardCurrentTrip];
            [self performSearch];
        } cancelBlock:^{
            return;
        }];
    } else {
        [self performSearch];
    }
}

- (IBAction)actionMaptype:(id)sender {
    _bcOptions.displayOptions.mapType++;
    if (_bcOptions.displayOptions.mapType == 3) {
        _bcOptions.displayOptions.mapType = MKMapTypeStandard;
    }
    [self updateMapType];
    
}


- (IBAction)actionCurrentLocation:(id)sender {
    [self updateCurrentMapView:_currentUserLocation.coordinate latitudinalMeters:0 longitudinalMeters:[self getCurrentMapViewSpan]];
}

- (IBAction)zoomToSearchArea:(id)sender {
    [self updateCurrentMapView:_bcOptions.searchOptions.searchAreaCentre latitudinalMeters:0 longitudinalMeters:_bcOptions.searchOptions.searchAreaSpan];
}


- (IBAction)buttonStart:(id)sender {
    if (!_currentTrip) {
        _currentTrip = [[TripsDataManager sharedInstance] CreateTripFromOccurrenceResults:_occurrenceResults bcOptions:_bcOptions tripStatus:TripStatusInProgress];
        _currentTrip.startTime = [NSDate date];
    } else {
        if (_currentTrip.status.intValue <= TripStatusSaved) {
            if (_currentTrip.status.intValue == TripStatusCreated) {
                [self displayTripNameDialog];
            }
            _currentTrip.status = [NSNumber numberWithInt:TripStatusInProgress];
            _currentTrip.startTime = [NSDate date];
        } else if (_currentTrip.status.intValue == TripStatusInProgress){
            _currentTrip.status = [NSNumber numberWithInt:TripStatusFinished];
            _currentTrip.stopTime = [NSDate date];
            
#ifdef DEBUG
            _currentTrip.stopTime = [_currentTrip.startTime dateByAddingTimeInterval:kDefaultTripDuration];
#endif
            [BCAlerts displayDefaultInfoAlert:@"Trip Completed, Ready to Publish" message:@"Please goto Trips Screen to publish trip to iNat"];
        } else if (_currentTrip.status.intValue == TripStatusFinished){
            [BCAlerts displayDefaultInfoAlert:@"Trip Completed, Ready to Publish" message:@"Please goto Trips Screen to publish trip to iNat"];
        }

        [_tripsDataManager saveChanges];
    }
    
    [self updateButtons];
}

- (IBAction)buttonSave:(id)sender {
    if (!_currentTrip) {
        _currentTrip = [[TripsDataManager sharedInstance] CreateTripFromOccurrenceResults:_occurrenceResults bcOptions:_bcOptions tripStatus:TripStatusSaved];
    } else {
        _currentTrip.status = [NSNumber numberWithInteger:TripStatusSaved];
        [self displayTripNameDialog];
    }
}

- (void)displayTripNameDialog {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Creating New Trip..." message:@"Enter name for trip\n(or accept default):" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.text = _currentTrip.title;
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Enter Trip Name:";
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *tripName = [alertView textFieldAtIndex:0].text;
    if (tripName.length > 0) {
        _currentTrip.title = tripName;
    }
    [_tripsDataManager saveChanges];
    self.viewButtonSave.hidden = YES;

    [BCAlerts displayDefaultSuccessNotification:@"New Trip Saved to Trips Page" subtitle:nil];
}

- (void)performSearch
{
    _searchInProgress = YES;
    
    // Use current view region for searchAreaSpan
    if (_currentTrip) {
        _currentTrip = nil;
        _bcOptions.searchOptions.searchAreaSpan = [self getCurrentMapViewSpan];
        [self updateButtons];
    }
    [self updateSearchResultsView];
    [self.mapView removeAnnotations:_currentTrip.occurrenceRecords];
//    [self updateAreaSpanLabel];
//    [self updateRecordCountLabel];
    
    _bcOptions.searchOptions.searchAreaCentre = _currentViewCoordinate;
    [self updateSearchAreaOverlay:_bcOptions.searchOptions.searchAreaCentre areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    _bcOptions.searchOptions.searchAreaPolygon = _currentSearchAreaPolygon;
    
    [_exploreDataManager fetchOccurrencesWithOptions:_bcOptions];
}


#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    // Keep Searching Until Location Fixed With Reasonable Accuracy (100m)
    if (![self isLocationAccurateEnough:userLocation.location]) {
        return;
    }
    
    if (self.activityViewLocationSearch.isAnimating) {
        [self.activityViewLocationSearch stopAnimating];
        _currentUserLocation = userLocation.location;
        [self updateLocationLabelAndMapView:_currentUserLocation.coordinate mapViewSpan:kDefaultViewSpan];
        [self updateSearchAreaOverlay:_currentUserLocation.coordinate areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    }
    _currentUserLocation = userLocation.location;
    if (_bcOptions.displayOptions.followUser) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:TRUE];
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    _mapViewLoaded = YES;
}

- (BOOL)isLocationAccurateEnough:(CLLocation *)location {
    CLLocationAccuracy minimumAccuracy = kCLLocationAccuracyHundredMeters;
    return (location.horizontalAccuracy <= minimumAccuracy);
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (_mapViewLoaded || _currentUserLocation) {
        _currentViewCoordinate = mapView.centerCoordinate;
        [self updateLocationLabel:mapView.centerCoordinate horizAccuracy:0];

        // If loading for the first time, perform search on current location
        if (!_currentTrip && _bcOptions.displayOptions.autoSearch && !_searchInProgress) {
            [self performSearch];
        }
    }
}

- (CLLocationDistance)getCurrentMapViewSpan
{
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    return MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor grayColor];
        circleView.lineWidth = 2.0;
        [circleView setLineDashPattern:@[@10, @10]];
        circleView.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        return circleView;
    }
    else if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonView *polygonView = [[MKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor redColor];
        polygonView.lineWidth = 2.0;
        [polygonView setLineDashPattern:@[@10, @10]];
        polygonView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        return polygonView;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"OccurrenceAnnotation";
    
    if ([annotation isKindOfClass:[OccurrenceRecord class]])
    {
        OccurrenceRecord *occurrence = (OccurrenceRecord *)annotation;
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"OccurrenceAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:NO]];
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        [mapView deselectAnnotation:view.annotation animated:NO];
        return;
    }
    
    OccurrenceRecord *occurrence = (OccurrenceRecord *)view.annotation;
    NSLog(@"didSelectAnnotationView: %@", occurrence.taxonSpecies);
    
    view.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:YES]];
    
    _taxonInfoVC.occurrence = occurrence;
    
    [self centerMapWithOffset:CGPointMake(0, kOccurrenceAnnotationOffset)from:occurrence.coordinate];
    [self showTaxonView];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    
    OccurrenceRecord *occurrence = (OccurrenceRecord *)view.annotation;
    NSLog(@"didDeselectAnnotationView: %@", occurrence.taxonSpecies);
    
    view.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:NO]];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped");
}


- (void)centerMapWithOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate
{
    CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    point.x += offset.x;
    point.y += offset.y;
    CLLocationCoordinate2D center = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:center animated:YES];
}


#pragma mark UIGestureRecognizer Methods

- (void)mapSingleClick:(UIGestureRecognizer *)gestureRecognizer
{
    //    NSLog(@"%s dropDownViewVisible:%@", __PRETTY_FUNCTION__, !_dropDownViewLocations.view.hidden ? @"YES" : @"NO");
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    UIView *selectedView = [self.mapView hitTest:touchPoint withEvent:nil];
    
    if ([selectedView isKindOfClass:[MKAnnotationView class]]) {
        double annotationOffset = kOccurrenceAnnotationOffset;
        if ([((MKAnnotationView *)selectedView).annotation isKindOfClass:[MKUserLocation class]]) {
            annotationOffset = 0;
        }
        CLLocationCoordinate2D mapCoord = [self.mapView convertPoint:CGPointMake(touchPoint.x, touchPoint.y + annotationOffset) toCoordinateFromView:self.mapView];
        [self.mapView setCenterCoordinate:mapCoord animated:YES];
        return;
    } else if (!self.viewTaxonInfo.hidden) {
        [self.mapView deselectAnnotation:[self.mapView selectedAnnotations][0] animated:NO];
        [self hideTaxonView];
        return;
    }
    
//    CGRect visibleRect = CGRectIntersection(self.mapView.frame, self.view.frame);
//    NSString *coordsString = [NSString stringWithFormat:@"(%.f,%.f)->(%.f,%.f)", visibleRect.origin.x, visibleRect.origin.y, visibleRect.origin.x + visibleRect.size.width, visibleRect.origin.y + visibleRect.size.height];
//    NSLog(@"Visible Rect:%@", coordsString);
    
    CLLocationCoordinate2D mapCoord = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:mapCoord animated:YES];
}

- (void)mapDoubleClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"DoubleClick");
}

- (void)viewBackgroundControlsClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"viewBackgroundControlsClick");
    [_dropDownViewLocations closeAnimation];
    _viewBackgroundControls.hidden = YES;
}


#pragma mark ExploreOptionsDelegate

- (void)optionsUpdated:(BCOptions *)bcOptions
{
    self.mapView.mapType = bcOptions.displayOptions.mapType;
    
    if (_currentSearchAreaCircle) {
        [self.mapView removeOverlay:_currentSearchAreaCircle];
    }
    
    [self updateSearchAreaOverlay:_currentViewCoordinate areaSpan:_bcOptions.searchOptions.searchAreaSpan];
}

#pragma mark - TripsDataManagerDelegate

- (void)newTripCreated:(INatTrip *)trip
{
    _currentTrip = trip;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateButtons];
        [self updateSearchResultsView];
//        [self updateRecordCountLabel];
        [self zoomToSearchArea:nil];
        _searchInProgress = NO;
    });
}

- (void)occurrenceAddedToTrip:(OccurrenceRecord *)occurrence
{
    NSLog(@"ExploreMapViewController occurrenceAddedToTrip, INatTaxonId: %lu", (unsigned long)occurrence.iNatTaxon.recordId);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotation:occurrence];
        [self updateRecordCountLabel];
    });
}

- (void)occurrenceRemovedFromTrip:(OccurrenceRecord *)occurrence
{
    NSLog(@"ExploreMapViewController occurrenceRemovedFromTrip, INatTaxonId: %lu", (unsigned long)occurrence.iNatTaxon.recordId);
    [self hideTaxonView];
    _taxonInfoVC.occurrence = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotation:occurrence];
        [self updateRecordCountLabel];
    });
}

#pragma mark - ExploreDataManagerDelegate

- (void)occurrenceResultsReceived:(GBIFOccurrenceResults *)occurrenceResults
{
    NSLog(@"ExploreMapViewController didReceiveOccurences: %lu", (unsigned long)occurrenceResults.Results.count);
    _occurrenceResults = occurrenceResults;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateSearchResultsView];
//        [self updateRecordCountLabel];
        [self zoomToSearchArea:nil];
    });
}

- (void)taxonAddedToOccurrence:(GBIFOccurrence *)occurrence
{
    NSLog(@"%s iNatTaxon: %@ - %@", __PRETTY_FUNCTION__, occurrence.speciesBinomial, occurrence.iNatTaxon.commonName);
    //    _occurrenceResults = _exploreDataManager.occurrenceResults;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotation:occurrence];
        [self updateRecordCountLabel];
    });
}

- (void)occurrenceRemoved:(GBIFOccurrence *)occurrence
{
    NSLog(@"%s iNatTaxon: %@ - %@", __PRETTY_FUNCTION__, occurrence.speciesBinomial, occurrence.iNatTaxon.commonName);
    //    if (self.navigationController.topViewController != self.parentViewController)
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    [self hideTaxonView];
    _taxonInfoVC.occurrence = nil;
    [self.mapView removeAnnotation:occurrence];
    [self updateRecordCountLabel];
}


#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"exploreOptionsSegue"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ExploreOptionsViewController *optionsVC = [navVC viewControllers][0];
        optionsVC.delegate = self;
//        optionsVC.bcOptions = _bcOptions;
    } else if ([segue.identifier isEqualToString:@"embedTaxonInfo"]) {
        _taxonInfoVC = segue.destinationViewController;
        _taxonInfoVC.showDetailsButton = YES;
    }
}

#pragma mark DropDownViewDelegate
-(void)dropDownCellSelected:(NSInteger)returnIndex
{
    if (returnIndex == 0) {
        _currentViewCoordinate = _currentUserLocation.coordinate;
    } else {
        _currentViewCoordinate = [LocationsArray locationCoordinate:returnIndex];
    }
    _bcOptions.searchOptions.searchAreaSpan = [LocationsArray locationSearchAreaSpan:returnIndex];
    _bcOptions.searchOptions.searchLocationName = [LocationsArray displayString:returnIndex];
    [self updateLocationLabelAndMapView:_currentViewCoordinate mapViewSpan:[LocationsArray locationViewSpan:returnIndex]];
    [self updateSearchAreaOverlay:_currentViewCoordinate areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    _viewBackgroundControls.hidden = YES;
    [self.activityViewLocationSearch stopAnimating];
}


#pragma mark UILayoutSupport Overrides
// Fix for MapView issue on iOS7, where setRegion calls move map 20px off center in y axis
// http://stackoverflow.com/questions/18903808/ios7-compass-in-mapview-placing

- (id<UILayoutSupport>)topLayoutGuide {
    return [[MapViewLayoutGuide alloc]initWithLength:20];
}

- (id<UILayoutSupport>)bottomLayoutGuide {
    return [[MapViewLayoutGuide alloc]initWithLength:20];
}

#pragma mark Sidebar Methods

- (void)setupSidebar
{
    //    self.buttonSidebar.alpha = 1.0f;
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    
    // Change button color
    //    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
}

- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

@end
