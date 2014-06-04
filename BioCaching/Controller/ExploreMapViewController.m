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
#import "SWRevealViewController.h"

#import "MapViewLayoutGuide.h"
#import "CrossHairView.h"
#import "LocationsArray.h"
#import "BCOptions.h"

#import "INatTaxon.h"
#import "INatTaxonPhoto.h"
#import "ImageCache.h"
#import "TripsDataManager.h"

#import "ExploreDataManager.h"
#import "GBIFManager.h"
#import "GBIFCommunicator.h"
#import "GBIFCommunicatorMock.h"
#import "GBIFOccurrenceResults.h"
#import "INatManager.h"


static float const kOccurrenceAnnotationOffset = 50.0f;
static int const kDefaultSearchAreaStepperValue = 1000;

@interface ExploreMapViewController () {
    MKCircle *_currentSearchAreaCircle;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet CrossHairView *viewMapCrossHair;
@property (weak, nonatomic) IBOutlet UIView *viewMapAnnotationRefFrame;

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocationList;
@property (weak, nonatomic) IBOutlet UIView *viewDropDownRef;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefreshSearch;

@property (weak, nonatomic) IBOutlet UIButton *buttonSettings;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtrlView;

@property (weak, nonatomic) IBOutlet UIButton *buttonCurrentLocation;

@property (weak, nonatomic) IBOutlet UIView *viewButtonSave;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIImageView *imageButtonSave;
- (IBAction)buttonSave:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonStart;
@property (weak, nonatomic) IBOutlet UIImageView *imageButtonStart;
@property (weak, nonatomic) IBOutlet UILabel *labelButtonStart;
- (IBAction)buttonStart:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewTaxonInfo;

//@property (nonatomic, strong) UIView *viewBackgroundControls;

@end

@implementation ExploreMapViewController
{
    TaxonInfoViewController *_taxonInfoVC;
    CGRect _taxonInfoRefFrame;

    DropDownViewController *_dropDownViewLocations;
    UIView *_viewBackgroundControls;
    
    CLLocationCoordinate2D _currentViewLocation;
    CLLocation *_currentUserLocation;
    bool _followUser;

    MKPolygon *_currentSearchAreaPolygon;
    
    ExploreDataManager *_exploreDataManager;
    
    GBIFOccurrenceResults *_occurrenceResults;
    GBIFManager *_gbifManager;
    INatManager *_iNatManager;
    INatTrip *_currentTrip;
}


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // TODO: Remove from here (passed in from parent/container controller)
    _bcOptions = [[BCOptions alloc] initWithDefaults];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabicon-search-solid"];

    [self setupSidebar];
    [self setupButtons];
    [self setupTaxonInfoView];

    self.mapView.mapType = _bcOptions.displayOptions.mapType;
    self.mapView.showsUserLocation = YES;
    _followUser = NO;

    // TODO: Use observer/notification pattern to get updated results
    _occurrenceResults = self.occurrenceResults;
    [self configureGBIFManager];
    [self configureINatManager];
    
    _exploreDataManager = [ExploreDataManager sharedInstance];

    _currentViewLocation = LocationsArray.defaultLocation;
    [self updateLocationLabelAndMapView:_currentViewLocation mapViewSpan:[LocationsArray locationViewSpan:LocationsArray.defaultLocationIndex]];

    _bcOptions.searchOptions.searchAreaSpan = [LocationsArray locationSearchAreaSpan:LocationsArray.defaultLocationIndex];
    [self updateSearchAreaOverlay:_currentViewLocation areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    
    [self configureGestureRecognizers];
    self.mapView.delegate = self;

    [self performSearch];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self configureLocationDropDown];
    [self configureBackgroundControlsView];
}


#pragma mark Initialisation Methods

- (void)configureGBIFManager
{
    _gbifManager = [[GBIFManager alloc] init];
    _gbifManager.delegate = self;
}

- (void)configureINatManager
{
    _iNatManager = [[INatManager alloc] init];
    _iNatManager.delegate = self;
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


#pragma mark Update View Methods

- (void)updateButtons {
    if (!_currentTrip) {
        self.viewButtonSave.hidden = NO;
        
        self.labelButtonStart.textColor = [UIColor kColorINatGreen];
        self.labelButtonStart.text = @"Start";
        self.imageButtonStart.image =
        [IonIcons imageWithIcon:icon_play iconColor:[UIColor kColorINatGreen] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
    }
    else {
        if (_currentTrip.status.intValue == TripStatusInProgress) {
            self.labelButtonStart.textColor = [UIColor orangeColor];
            self.labelButtonStart.text = @"Stop";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_stop iconColor:[UIColor orangeColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
        } else if (_currentTrip.status.intValue == TripStatusFinished) {
            self.labelButtonStart.textColor = [UIColor cyanColor];
            self.labelButtonStart.text = @"Upload";
            self.imageButtonStart.image =
            [IonIcons imageWithIcon:icon_upload iconColor:[UIColor cyanColor] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
        }
    }
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
    self.labelLocationDetails.text = [NSString stringWithFormat:@"Lat: %f Long: %f",
                                      location.latitude,
                                      location.longitude];
}

- (void)updateSearchAreaOverlay:(CLLocationCoordinate2D)location areaSpan:(double)areaSpan
{
    [self updateSearchAreaOverlay:location latitudeSpan:areaSpan/2 longitudeSpan:areaSpan/2];
}

- (void)updateSearchAreaOverlay:(CLLocationCoordinate2D)location latitudeSpan:(double)latSpan longitudeSpan:(double)longSpan
{
    if (_currentSearchAreaPolygon) {
        [self.mapView removeOverlay:_currentSearchAreaPolygon];
    }
    
    if (_currentSearchAreaCircle) {
        [self.mapView removeOverlay:_currentSearchAreaCircle];
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

- (void)addiNatTaxonInfoToOccurrences:(NSArray *)occurrences
{
    for (GBIFOccurrence *occurrence in occurrences) {
        [_iNatManager addINatTaxonToGBIFOccurrence:occurrence];
    }
}

- (void)addOccurrenceAnnotation:(GBIFOccurrence *)occurrence
{
    [self.mapView addAnnotation:occurrence];
}

- (void)updateCurrentMapView:(CLLocationCoordinate2D)location latitudinalMeters:(NSInteger)latRegionSpan longitudinalMeters:(NSInteger)longRegionSpan
{
//    self.mapView.centerCoordinate = location;

    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Location:(%.6f,%.6f)", location.latitude, location.longitude);
    NSLog(@"MapView CenterCoords:(%.6f,%.6f)", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    NSLog(@"MapView CenterPoint:(%.0f,%.0f)", self.mapView.center.x, self.mapView.center.y);
    NSLog(@"CrossHair CenterPoint:(%.0f,%.0f)", self.viewMapCrossHair.center.x , self.viewMapCrossHair.center.y);
    NSLog(@"VC Frame:%@", self.view.description);
    NSLog(@"MapView Frame:%@", self.mapView.description);

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, latRegionSpan, longRegionSpan);
    [self.mapView setRegion:region animated:YES];
    
    NSLog(@"Region: center=(%.6f,%.6f) span=(%.20f,%.20f)", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
    NSLog(@"MapView CenterCoords:(%.6f,%.6f)", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
    NSLog(@"MapView CenterPoint:(%.0f,%.0f)", self.mapView.center.x, self.mapView.center.y);
    NSLog(@"CrossHair CenterPoint:(%.0f,%.0f)", self.viewMapCrossHair.center.x , self.viewMapCrossHair.center.y);
    
    NSLog(@"%@", [self.topLayoutGuide debugDescription]);
    NSLog(@"%@", [self.bottomLayoutGuide debugDescription]);
    
    //    [self.mapView setCenterCoordinate:location];
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

- (IBAction)currentLocation:(id)sender {
//    [self updateLocationLabel:_currentUserLocation.coordinate horizAccuracy:_currentUserLocation.horizontalAccuracy];
//    [self updateSearchAreaOverlay:_currentUserLocation.coordinate areaSpan:_currentSearchAreaSpan];
//    [self updateCurrentMapView:_currentUserLocation.coordinate latitudinalMeters:0 longitudinalMeters:kDefaultViewSpan];
}


- (IBAction)zoomToSearchArea:(id)sender {
    [self updateCurrentMapView:_bcOptions.searchOptions.searchAreaCentre latitudinalMeters:0 longitudinalMeters:_bcOptions.searchOptions.searchAreaSpan];
}



- (IBAction)buttonRefreshSearch:(id)sender
{
    [self hideTaxonView];

    if (!_currentTrip) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create New Trip", nil)
                                                     message:NSLocalizedString(@"Unsaved Trip Will Be Lost \n\nTODO: Add OK/Cancel Option", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
        [av show];
    }
    _currentTrip = nil;
    [self updateButtons];
    [self performSearch];
}


- (IBAction)buttonStart:(id)sender {
    if (!_currentTrip) {
        _currentTrip = [[TripsDataManager sharedInstance] CreateTripFromOccurrenceResults:self.occurrenceResults bcOptions:self.bcOptions tripStatus:TripStatusInProgress];
    } else {
        if (_currentTrip.status.intValue == TripStatusCreated) {
            _currentTrip.status = [NSNumber numberWithInt:TripStatusInProgress];

            //TODO: Change TripsDataManager to use single array with predicates/FetchedResultsController
            [[TripsDataManager sharedInstance].savedTrips removeObject:_currentTrip];
            [[TripsDataManager sharedInstance].inProgressTrips addObject:_currentTrip];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Started and Saved to Trips Page", nil)
                                                         message:NSLocalizedString(@"Animate button disappearing to trips menu/button", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
            [av show];
            
        } else if (_currentTrip.status.intValue == TripStatusInProgress){
            _currentTrip.status = [NSNumber numberWithInt:TripStatusFinished];

            //TODO: Change TripsDataManager to use single array with predicates/FetchedResultsController
            [[TripsDataManager sharedInstance].inProgressTrips removeObject:_currentTrip];
            [[TripsDataManager sharedInstance].finishedTrips addObject:_currentTrip];
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Finished and Ready to Upload (From Trips Page)", nil)
                                                         message:NSLocalizedString(@"More user interaction asking to validate observations and items on trip list etc.", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                               otherButtonTitles:nil];
            [av show];
            
        }

        [[TripsDataManager sharedInstance] saveChanges];
    }
    
    if (_currentTrip) {
        self.viewButtonSave.hidden = YES;
        [self updateButtons];
    }
}

- (IBAction)buttonSave:(id)sender {
    if (!_currentTrip) {
        _currentTrip = [[TripsDataManager sharedInstance] CreateTripFromOccurrenceResults:self.occurrenceResults bcOptions:self.bcOptions tripStatus:TripStatusCreated];
    }
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Trip Saved to Trips Page", nil)
                                                 message:NSLocalizedString(@"Animate button disappearing to trips menu/button", nil)
                                                delegate:self
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                       otherButtonTitles:nil];
    [av show];
    
    self.viewButtonSave.hidden = YES;
}




- (void)performSearch
{
    _bcOptions.searchOptions.searchAreaCentre = _currentViewLocation;
    [self updateSearchAreaOverlay:_bcOptions.searchOptions.searchAreaCentre areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    _bcOptions.searchOptions.searchAreaPolygon = _currentSearchAreaPolygon;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

//    [_exploreDataManager fetchOccurrencesWithOptions:_bcOptions.searchOptions];
    [_gbifManager fetchOccurrencesWithOptions:_bcOptions.searchOptions];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _currentUserLocation = userLocation.location;
    
    if (_followUser) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:TRUE];
//        [self updateSearchAreaOverlay:userLocation.coordinate areaSpan:_currentSearchAreaSpan];
    }
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


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    _currentViewLocation = mapView.centerCoordinate;
    [self updateLocationLabel:mapView.centerCoordinate horizAccuracy:0];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"OccurrenceAnnotation";
    
    if ([annotation isKindOfClass:[GBIFOccurrence class]])
    {
        GBIFOccurrence *occurrence = (GBIFOccurrence *)annotation;
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
    GBIFOccurrence *occurrence = (GBIFOccurrence *)view.annotation;
    NSLog(@"didSelectAnnotationView: %@", occurrence.speciesBinomial);

    view.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:YES]];
    
    _taxonInfoVC.occurrence = occurrence;
    
    [self centerMapWithOffset:CGPointMake(0, kOccurrenceAnnotationOffset)from:occurrence.coordinate];
    [self showTaxonView];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    GBIFOccurrence *occurrence = (GBIFOccurrence *)view.annotation;
    NSLog(@"didDeselectAnnotationView: %@", occurrence.speciesBinomial);
    
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


#pragma mark UIGestureRecognizer Methods

- (void)mapSingleClick:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"%s dropDownViewVisible:%@", __PRETTY_FUNCTION__, !_dropDownViewLocations.view.hidden ? @"YES" : @"NO");
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    UIView *selectedView = [self.mapView hitTest:touchPoint withEvent:nil];
    
    if ([selectedView isKindOfClass:[MKAnnotationView class]]) {
        CLLocationCoordinate2D mapCoord = [self.mapView convertPoint:CGPointMake(touchPoint.x, touchPoint.y + kOccurrenceAnnotationOffset) toCoordinateFromView:self.mapView];
        [self.mapView setCenterCoordinate:mapCoord animated:YES];
        return;
    } else if (!self.viewTaxonInfo.hidden) {
        [self.mapView deselectAnnotation:[self.mapView selectedAnnotations][0] animated:NO];
        [self hideTaxonView];
        return;
    }

    CGRect visibleRect = CGRectIntersection(self.mapView.frame, self.view.frame);
    NSString *coordsString = [NSString stringWithFormat:@"(%.f,%.f)->(%.f,%.f)", visibleRect.origin.x, visibleRect.origin.y, visibleRect.origin.x + visibleRect.size.width, visibleRect.origin.y + visibleRect.size.height];
    NSLog(@"Visible Rect:%@", coordsString);
    
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

#pragma mark UIGestureRecognizerDelegate
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"shouldReceiveTouch: %@", [touch.view class]);
    return (![touch.view isDescendantOfView:_dropDownViewLocations.view]);

}
*/
/*
- (BOOL)shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)gr
{
    return TRUE;
}
*/

#pragma mark ExploreOptionsDelegate
- (void)optionsUpdated:(BCOptions *)bcOptions
{
    self.mapView.mapType = bcOptions.displayOptions.mapType;

    if (_currentSearchAreaCircle) {
        [self.mapView removeOverlay:_currentSearchAreaCircle];
    }
    
    [self updateSearchAreaOverlay:_currentViewLocation areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateOccurrenceAnnotations:[_occurrenceResults getFilteredResults:bcOptions.displayOptions limitToMapPoints:YES]];
    });
    
//    _tripOptions = savedTripOptions;
}

#pragma mark - GBIFManagerDelegate

- (void)didReceiveOccurences:(GBIFOccurrenceResults *)occurrenceResults
{
    NSLog(@"ExploreMapViewController didReceiveOccurences: %lu", (unsigned long)occurrenceResults.Results.count);
    _occurrenceResults = occurrenceResults;
    
    [self addiNatTaxonInfoToOccurrences:[_occurrenceResults getFilteredResults:_bcOptions.displayOptions limitToMapPoints:YES]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateOccurrenceAnnotations:[_occurrenceResults getFilteredResults:_bcOptions.displayOptions limitToMapPoints:YES]];
        [self zoomToSearchArea:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

- (void)fetchingResultsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - INatManagerDelegate

- (void)iNatTaxonAddedToGBIFOccurrence:(GBIFOccurrence *)occurrence
{
//    NSLog(@"%s iNatTaxon: %@ - %@", __PRETTY_FUNCTION__, occurrence.speciesBinomial, occurrence.iNatTaxon.common_name);

    if (occurrence.iNatTaxon)
    {
        if (occurrence.iNatTaxon.taxon_photos.count > 0)
        {
            INatTaxonPhoto *mainPhoto = occurrence.iNatTaxon.taxon_photos[0];
            [ImageCache saveImageForURL:mainPhoto.medium_url];
        }
    }
    
    //
    [self.mapView addAnnotation:occurrence];
}

#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"exploreOptionsSegue"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ExploreOptionsViewController *optionsVC = [navVC viewControllers][0];
        optionsVC.delegate = self;
        optionsVC.bcOptions = _bcOptions;
    } else if ([segue.identifier isEqualToString:@"embedTaxonInfo"]) {
        _taxonInfoVC = segue.destinationViewController;
    }
}

#pragma mark DropDownViewDelegate
-(void)dropDownCellSelected:(NSInteger)returnIndex
{
    if (returnIndex == 0) {
        _currentViewLocation = _currentUserLocation.coordinate;
    } else {
        _currentViewLocation = [LocationsArray locationCoordinate:returnIndex];
    }
    _bcOptions.searchOptions.searchAreaSpan = [LocationsArray locationSearchAreaSpan:returnIndex];
    [self updateLocationLabelAndMapView:_currentViewLocation mapViewSpan:[LocationsArray locationViewSpan:returnIndex]];
//    [self updateSearchAreaStepper:_currentSearchAreaSpan];
    [self updateSearchAreaOverlay:_currentViewLocation areaSpan:_bcOptions.searchOptions.searchAreaSpan];
    _viewBackgroundControls.hidden = YES;
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


- (void)setupTaxonInfoView
{
    _taxonInfoRefFrame = self.viewTaxonInfo.frame;
    self.viewTaxonInfo.hidden = YES;
    self.viewTaxonInfo.alpha = 0.0f;
}

- (void)setupButtons
{
    self.viewTopBar.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
    
    [self setupSidebar];
    
    [self.buttonRefreshSearch setTitle:nil forState:UIControlStateNormal];
    [self.buttonRefreshSearch setBackgroundImage:
     [IonIcons imageWithIcon:icon_refresh iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonRefreshSearch.backgroundColor = [UIColor kColorButtonBackground];
    
    self.buttonLocationList.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    self.labelLocationDetails.textColor = [UIColor kColorButtonLabel];

    self.buttonSettings.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
    [self.buttonSettings setBackgroundImage:
     [IonIcons imageWithIcon:icon_gear_b iconColor:[UIColor whiteColor] iconSize:28.0f imageSize:CGSizeMake(30.0f, 30.0f)] forState:UIControlStateNormal];

    self.imageButtonSave.image =
    [IonIcons imageWithIcon:icon_archive iconColor:[UIColor kColorBCButtonLabel] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
//    [self.buttonSave setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];

    self.labelButtonStart.textColor = [UIColor kColorINatGreen];
    self.imageButtonStart.image =
    [IonIcons imageWithIcon:icon_play iconColor:[UIColor kColorINatGreen] iconSize:32.0f imageSize:CGSizeMake(32.0f, 32.0f)];
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
