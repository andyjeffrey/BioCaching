    //
//  ExploreMapViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreMapViewController.h"
#import "ExploreListViewController.h"
#import "OptionsStaticTableViewController.h"
#import "LocationsArray.h"
#import "TripOptions.h"
#import "GBIFManager.h"
#import "GBIFCommunicator.h"
#import "GBIFCommunicatorMock.h"
#import "GBIFOccurrenceResults.h"
#import "OccurrenceLocation.h"
#import "INatManager.h"
#import "INatTaxon.h"
#import "INatTaxonPhoto.h"

#define kDefaultSearchAreaStepperValue 1000
#define kInitialViewSpan 5000

@interface ExploreMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationList;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocationList;
@property (weak, nonatomic) IBOutlet UIView *viewDropDownRef;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UILabel *labelSearchArea;
@property (weak, nonatomic) IBOutlet UIStepper *stepperSearchArea;
@property (weak, nonatomic) IBOutlet UIButton *buttonCurrentLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonMapType;

@property (weak, nonatomic) IBOutlet UIView *viewCalloutRefFrame;
@property (weak, nonatomic) IBOutlet UIView *viewTaxonInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelPhotoCopyright;
@property (weak, nonatomic) IBOutlet UIImageView *imageMainPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imageTaxonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSpecies;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonFamily;
@property (weak, nonatomic) IBOutlet UIImageView *imageIconicTaxa;


//@property (nonatomic, strong) UIView *viewBackgroundControls;

@end

@implementation ExploreMapViewController
{
    CLLocationCoordinate2D _currentViewLocation;
    int _currentSearchAreaSpan;
    MKPolygon *_currentSearchAreaPolygon;
    CLLocation *_currentUserLocation;
    bool _followUser;
    TripOptions *_tripOptions;
    GBIFOccurrenceResults *_occurrenceResults;
    DropDownViewController *_dropDownViewLocations;
    UIView *_viewBackgroundControls;
    GBIFManager *_gbifManager;
    INatManager *_iNatManager;
    CGRect _taxonInfoRefFrame;
}

- (void)viewDidLoad
{
//    NSLog(@"viewDidAppear");
    [super viewDidLoad];
    
    [TSMessage setDefaultViewController:self];
    
    self.navigationController.navigationBarHidden = YES;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabicon-search-solid"];

    _tripOptions = [TripOptions initWithDefaults];
    
    self.mapView.showsUserLocation = YES;
    _followUser = NO;

    self.mapView.mapType = MKMapTypeStandard;
    [self.buttonMapType setTitle:@"MapType: Standard" forState:UIControlStateNormal];
    
    [self.buttonSearch setTitle:nil forState:UIControlStateNormal];
    [self.buttonSearch setBackgroundImage:
     [IonIcons imageWithIcon:icon_gear_b iconColor:[UIColor darkGrayColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
//     [IonIcons imageWithIcon:icon_settings size:30.0f color:[UIColor darkGrayColor]] forState:UIControlStateNormal];

    [self configureGBIFManager];
    [self configureINatManager];

    _currentViewLocation = LocationsArray.defaultLocation;
    [self updateLocationLabelAndMapView:_currentViewLocation];

    [self configureSearchAreaStepper: (int)_tripOptions.searchAreaSpan];
    [self updateSearchAreaOverlay:_currentViewLocation areaSpan:_currentSearchAreaSpan];
    
    _taxonInfoRefFrame = self.viewTaxonInfo.frame;
    self.viewTaxonInfo.hidden = YES;

    [self configureGestureRecognizers];
    self.mapView.delegate = self;

    [self performSearch:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureLocationDropDown];
    [self configureBackgroundControlsView];
    
//    NSLog(@"viewDidAppear");
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

- (void)configureSearchAreaStepper:(int)searchAreaSpan
{
    _currentSearchAreaSpan = searchAreaSpan;
    self.stepperSearchArea.value = log2(_currentSearchAreaSpan/kDefaultSearchAreaStepperValue);
    self.stepperSearchArea.maximumValue = 5;
    self.stepperSearchArea.minimumValue = -5;
    [self updateSearchAreaLabel:self.stepperSearchArea.value];
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

/*
- (void)configureViewsToDisable
{
    uiControls = [[NSArray alloc] initWithObjects:
                  self.mapView,
                  self.buttonLocationList,
                  self.stepperSearchArea,
                  self.buttonSearch,
                  self.buttonList,
                  self.buttonCurrentLocation,
                  self.buttonZoom,
                  self.buttonMapType,
                  self.buttonOptions,
                  nil];
}

- (void)dimUIControls:(BOOL)dimEnabled
{
    uiControlsView.hidden = !dimEnabled;
    for (UIControl *uiControl in uiControls) {
        uiControl.userInteractionEnabled = !dimEnabled;
    }
    if (dimEnabled) {
        uiControlsDimmed = dimEnabled;
    }
}
*/

- (void)configureLocationDropDown
{
//[self.view convertRect:self.buttonRecordType.frame fromView:self.buttonRecordType.superview]
    
    _dropDownViewLocations = [[DropDownViewController alloc] initWithArrayData:[LocationsArray displayStringsArray] refFrame:[self.view.superview convertRect:self.viewDropDownRef.frame fromView:self.viewDropDownRef.superview] tableViewHeight:260 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    [self.view addSubview:_dropDownViewLocations.view];
    _dropDownViewLocations.delegate = self;
    
    self.labelLocationList.text = nil;
    [self.labelLocationList setBackgroundColor:[UIColor colorWithPatternImage:[IonIcons imageWithIcon:icon_navicon size:self.labelLocationList.frame.size.width color:[UIColor darkGrayColor]]]];
//    [IonIcons label:self.labelLocationList setIcon:icon_navicon size:self.labelLocationList.frame.size.width color:[UIColor darkGrayColor] sizeToFit:YES];
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

- (void)updateLocationLabelAndMapView:(CLLocationCoordinate2D)location mapViewSpan:(NSInteger)viewSpan
{
    [self updateLocationLabel:location horizAccuracy:0];
    [self updateCurrentMapView:location latitudinalMeters:0 longitudinalMeters:viewSpan];
}

- (void)updateLocationLabelAndMapView:(CLLocationCoordinate2D)location
{
    [self updateLocationLabelAndMapView:location mapViewSpan:kInitialViewSpan];
}

- (void)updateLocationLabel:(CLLocationCoordinate2D)location horizAccuracy:(double)accuracy {
//    self.labelLocationDetails.text = [NSString stringWithFormat:@"Lat: %f Long: %f Acc: %.1fm",
    self.labelLocationDetails.text = [NSString stringWithFormat:@"Lat: %f Long: %f",
                                      location.latitude,
                                      location.longitude];
}

- (void)updateSearchAreaStepper:(int)searchAreaSpan
{
    self.stepperSearchArea.value = log2(searchAreaSpan/kDefaultSearchAreaStepperValue);
    [self updateSearchAreaLabel:self.stepperSearchArea.value];
}

- (void)updateSearchAreaLabel:(double)stepperValue
{
    self.labelSearchArea.text = [NSString stringWithFormat:@"Span: %dm", _currentSearchAreaSpan];
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
    
    MKCoordinateRegion searchRegion = MKCoordinateRegionMakeWithDistance(location, latSpan, longSpan);
    MKCoordinateSpan searchSpan = searchRegion.span;
    CLLocationCoordinate2D searchPolygonCoords[5] = {
        CLLocationCoordinate2DMake(location.latitude - searchSpan.latitudeDelta, location.longitude - searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude - searchSpan.latitudeDelta, location.longitude + searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude + searchSpan.latitudeDelta, location.longitude + searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude + searchSpan.latitudeDelta, location.longitude - searchSpan.longitudeDelta),
        CLLocationCoordinate2DMake(location.latitude - searchSpan.latitudeDelta, location.longitude - searchSpan.longitudeDelta)};
    
    // Polygon (square) area overlay
    _currentSearchAreaPolygon = [MKPolygon polygonWithCoordinates:searchPolygonCoords count:5];
    [self.mapView addOverlay:_currentSearchAreaPolygon];
    NSLog(@"%s SearchArea=%@", __PRETTY_FUNCTION__, _currentSearchAreaPolygon);

    // Circle area overlay
    //MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:1000];
    //[mapView addOverlay:circle];
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
//    OccurrenceLocation *location = [[OccurrenceLocation alloc] initWithGBIFOccurrence:occurrence];
    [self.mapView addAnnotation:occurrence];
}

- (void)updateCurrentMapView:(CLLocationCoordinate2D)location latitudinalMeters:(NSInteger)latRegionSpan longitudinalMeters:(NSInteger)longRegionSpan
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, latRegionSpan, longRegionSpan);
//    NSLog(@"%s, MKCoordinationRegion.span: %.4f, %.4f", __PRETTY_FUNCTION__, region.span.latitudeDelta, region.span.longitudeDelta);
    [self.mapView setRegion:region animated:YES];
}


#pragma mark IBActions
- (IBAction)buttonLocationSelect:(id)sender {
/*
    [self activateUIControls:FALSE];
*/
    NSLog(@"buttonLocationSelect");
    _viewBackgroundControls.hidden = NO;
    [_dropDownViewLocations openAnimation];
    [_dropDownViewLocations.uiTableView flashScrollIndicators];
}

- (IBAction)currentLocation:(id)sender {
    [self updateLocationLabel:_currentUserLocation.coordinate horizAccuracy:_currentUserLocation.horizontalAccuracy];
    [self updateSearchAreaOverlay:_currentUserLocation.coordinate areaSpan:_currentSearchAreaSpan];
    [self updateCurrentMapView:_currentUserLocation.coordinate latitudinalMeters:0 longitudinalMeters:kInitialViewSpan];
}

- (IBAction)searchZoomChanged:(UIStepper *)sender
{
    _currentSearchAreaSpan = kDefaultSearchAreaStepperValue * pow(2, self.stepperSearchArea.value);
    [self updateSearchAreaLabel:sender.value];
    [self updateSearchAreaOverlay:_currentSearchAreaPolygon.coordinate areaSpan:_currentSearchAreaSpan];
}

- (IBAction)zoomToLocation:(id)sender {
    [self updateCurrentMapView:_currentSearchAreaPolygon.coordinate latitudinalMeters:_currentSearchAreaSpan longitudinalMeters:_currentSearchAreaSpan];
}

- (IBAction)performSearch:(id)sender
{
    _tripOptions.searchAreaSpan = _currentSearchAreaSpan;
    _tripOptions.searchAreaPolygon = _currentSearchAreaPolygon;
    _tripOptions.searchAreaCentre = _currentSearchAreaPolygon.coordinate;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [self.gbifManager fetchOccurrencesWithinArea:_currentSearchAreaPolygon];
    [_gbifManager fetchOccurrencesWithOptions:_tripOptions];
}

- (IBAction)changeMapType:(id)sender
{
    NSString *mapType = @"MapType: %@";
    
    switch (self.mapView.mapType) {
        case MKMapTypeStandard:
            [self.mapView setMapType:MKMapTypeSatellite];
            [self.buttonMapType setTitle:[NSString stringWithFormat:mapType, @"Satellite"] forState:UIControlStateNormal];
            break;
            
        case MKMapTypeSatellite:
            [self.mapView setMapType:MKMapTypeHybrid];
            [self.buttonMapType setTitle:[NSString stringWithFormat:mapType, @"Hybrid"] forState:UIControlStateNormal];
            break;

        default:
            [self.mapView setMapType:MKMapTypeStandard];
            [self.buttonMapType setTitle:[NSString stringWithFormat:mapType, @"Standard"] forState:UIControlStateNormal];
            break;
    }
}


#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _currentUserLocation = userLocation.location;
    
    if (_followUser) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:TRUE];
        [self updateSearchAreaOverlay:userLocation.coordinate areaSpan:_currentSearchAreaSpan];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor grayColor];
        circleView.lineWidth = 2.0;
        [circleView setLineDashPattern:@[@10, @10]];
        circleView.fillColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
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
    [self updateLocationLabel:mapView.centerCoordinate horizAccuracy:0];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"OccurrenceAnnotation";
    if ([annotation isKindOfClass:[OccurrenceLocation class]]) {
/*
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
*/
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"OccurrenceAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:((OccurrenceLocation *)annotation).mapMarkerImageFile];
        } else {
            annotationView.image = [UIImage imageNamed:((OccurrenceLocation *)annotation).mapMarkerImageFile];
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[GBIFOccurrence class]])
    {
        GBIFOccurrence *occurrence = (GBIFOccurrence *)annotation;
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"OccurrenceAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:NO]];
        return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    GBIFOccurrence *occurrence = (GBIFOccurrence *)view.annotation;
    NSLog(@"didDeselectAnnotationView: %@", occurrence.speciesBinomial);

    view.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:NO]];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    GBIFOccurrence *occurrence = (GBIFOccurrence *)view.annotation;
    NSLog(@"didSelectAnnotationView: %@", occurrence.speciesBinomial);

    view.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMapMarkerImageFile:YES]];
    
    [self updateTaxonView:occurrence];
    [self showTaxonView];
    
}

- (void)updateTaxonView:(GBIFOccurrence *)occurrence
{
    INatTaxonPhoto *iNatTaxonPhoto;
    
    if (occurrence.iNatTaxon.taxon_photos.count > 0) {
        iNatTaxonPhoto = occurrence.iNatTaxon.taxon_photos[0];

        // Implement Image Cache
        [self.imageMainPhoto setImageWithURL:[NSURL URLWithString:iNatTaxonPhoto.medium_url]];
        self.labelPhotoCopyright.text = iNatTaxonPhoto.attribution;
    } else {
        self.imageMainPhoto.image = nil;
        self.labelPhotoCopyright.text = nil;
    }
    
    self.imageIconicTaxa.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMainImageFile]];
    self.labelTaxonSpecies.text = occurrence.speciesBinomial;
    self.labelTaxonFamily.text = [NSString stringWithFormat:@"Class: %@   Family: %@", occurrence.Clazz, occurrence.Family];
}

- (void)showTaxonView
{
    if (self.viewTaxonInfo.hidden) {
        CGRect startFrame = CGRectMake(_taxonInfoRefFrame.origin.x, _taxonInfoRefFrame.origin.y + _taxonInfoRefFrame.size.height, _taxonInfoRefFrame.origin.x + _taxonInfoRefFrame.size.width, 0);
        
        self.viewTaxonInfo.frame = startFrame;
        [UIView animateWithDuration:0.5f animations:^{
            self.viewTaxonInfo.hidden = NO;
            self.viewTaxonInfo.frame = _taxonInfoRefFrame;
            self.viewTaxonInfo.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)hideTaxonView
{
    if (!self.viewTaxonInfo.hidden) {
        CGRect endFrame = CGRectMake(_taxonInfoRefFrame.origin.x, _taxonInfoRefFrame.origin.y + _taxonInfoRefFrame.size.height, _taxonInfoRefFrame.origin.x + _taxonInfoRefFrame.size.width, 0);
        
        [UIView animateWithDuration:0.5f animations:^{
            self.viewTaxonInfo.frame = endFrame;
            self.viewTaxonInfo.alpha = 0.1f;
        } completion:^(BOOL finished) {
            self.viewTaxonInfo.hidden = YES;
        }];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped");
}

#pragma mark UIGestureRecognizer Methods

- (void)mapSingleClick:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"%s dropDownViewVisible:%@", __PRETTY_FUNCTION__, !_dropDownViewLocations.view.hidden ? @"YES" : @"NO");
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    UIView *selectedView = [self.view hitTest:touchPoint withEvent:nil];
    
    if ([selectedView isKindOfClass:[MKAnnotationView class]]) {
        NSLog(@"AnnotationView selected");
        CLLocationCoordinate2D mapCoord = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.viewCalloutRefFrame];
        [self.mapView setCenterCoordinate:mapCoord animated:YES];
        return;
    } else if (!self.viewTaxonInfo.hidden) {
        [self hideTaxonView];
        return;
    } else {
        CLLocationCoordinate2D mapCoord = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        [self.mapView setCenterCoordinate:mapCoord animated:YES];
        [self updateSearchAreaOverlay:mapCoord areaSpan:_currentSearchAreaSpan];
    }
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
- (void)optionsUpdated:(TripOptions *)tripOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateOccurrenceAnnotations:[_occurrenceResults getFilteredResults:_tripOptions limitToMapPoints:YES]];
    });
    
//    _tripOptions = savedTripOptions;
}

#pragma mark GBIFManagerDelegate

- (void)didReceiveOccurences:(GBIFOccurrenceResults *)occurrenceResults
{
    NSLog(@"ExploreMapViewController didReceiveOccurences: %lu", (unsigned long)occurrenceResults.Results.count);
    _occurrenceResults = occurrenceResults;
    
    [self addiNatTaxonInfoToOccurrences:[_occurrenceResults getFilteredResults:_tripOptions limitToMapPoints:YES]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateOccurrenceAnnotations:[_occurrenceResults getFilteredResults:_tripOptions limitToMapPoints:YES]];
        [self zoomToLocation:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

- (void)fetchingResultsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark INatManagerDelegate

- (void)iNatTaxonAddedToGBIFOccurrence:(GBIFOccurrence *)occurrence
{
    NSLog(@"%s iNatTaxon: %@ - %@", __PRETTY_FUNCTION__,
          occurrence.speciesBinomial, occurrence.iNatTaxon.common_name);

    if (occurrence.iNatTaxon)
    {
        if (occurrence.iNatTaxon.taxon_photos.count > 0)
        {
            INatTaxonPhoto *mainPhoto = occurrence.iNatTaxon.taxon_photos[0];
            NSLog(@"Caching Image For Taxon:%@", occurrence.speciesBinomial);
            UIImageView *tempImageView = [[UIImageView alloc] init];
            [tempImageView setImageWithURL:[NSURL URLWithString:mainPhoto.medium_url]];
        }
    }

    [self.mapView addAnnotation:occurrence];
}

#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ExploreListSegue"]) {
        UINavigationController *navVC = [segue destinationViewController];
        ExploreListViewController *detailsVC = [navVC viewControllers][0];
        detailsVC.occurrenceResults = _occurrenceResults;
        detailsVC.tripOptions = _tripOptions;
    }
/*    else if ([segue.identifier isEqualToString:@"ExploreOptionsSegue"]) {
        ExploreOptionsViewController *optionsVC = [segue destinationViewController];
        optionsVC.delegate = self;
        optionsVC.tripOptions = _tripOptions;
    }
*/    else if ([segue.identifier isEqualToString:@"OptionsStaticSegue"]) {
    
        UINavigationController *navVC = [segue destinationViewController];
        OptionsStaticTableViewController *optionsVC = [navVC viewControllers][0];
        optionsVC.delegate = self;
        optionsVC.tripOptions = _tripOptions;
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
    _currentSearchAreaSpan = [LocationsArray locationSearchAreaSpan:returnIndex];
    [self updateLocationLabelAndMapView:_currentViewLocation mapViewSpan:[LocationsArray locationViewSpan:returnIndex]];
    [self updateSearchAreaStepper:_currentSearchAreaSpan];
    [self updateSearchAreaOverlay:_currentViewLocation areaSpan:_currentSearchAreaSpan];
    _viewBackgroundControls.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
