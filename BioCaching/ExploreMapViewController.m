    //
//  ExploreMapViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreMapViewController.h"
#import "ExploreTableViewController.h"
#import "GBIFCommunicator.h"
#import "GBIFCommunicatorMock.h"
#import "GBIFOccurrenceResults.h"
#import "OccurrenceLocation.h"

#define kDefaultViewSpan 5000
#define kMapMarkersMax 100

@interface ExploreMapViewController () {
    int _currentSearchAreaSpan;
    MKPolygon *_currentSearchAreaPolygon;
    bool _followUser;
    CLLocation *_currentUserLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationDetails;
@property (weak, nonatomic) IBOutlet UIButton *mapTypeButton;
@property (weak, nonatomic) IBOutlet UIStepper *areaStepper;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation ExploreMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _manager = [[GBIFManager alloc] init];
    _manager.delegate = self;
#ifdef MOCKDATA
    _manager.communicator = [[GBIFCommunicatorMock alloc] init];
#else
    _manager.communicator = [[GBIFCommunicator alloc] init];
#endif
    _manager.communicator.delegate = _manager;
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabicon-search-solid"];
    
    self.mapView.mapType = MKMapTypeStandard;
    [self.mapTypeButton setTitle:@"MapType: Standard" forState:UIControlStateNormal];
    
    //_currentSearchAreaSize = 1000 * pow(2,areaStepper), i.e. default = 1000m
    self.areaStepper.value = 1;
    self.areaStepper.maximumValue = 5;
    self.areaStepper.minimumValue = -5;
    [self updateSearchAreaLabel:self.areaStepper.value];
    
    CLLocationCoordinate2D defaultLocation = CLLocationCoordinate2DMake(37.769341, -122.481937);
    //CLLocationCoordinate2D defaultLocation = CLLocationCoordinate2DMake(0, 0);
    [self updateLocationLabel:defaultLocation horizAccuracy:0];
    [self updateCurrentMapView:defaultLocation latitudinalMeters:0 longitudinalMeters:kDefaultViewSpan];

    [self updateSearchAreaOverlay:defaultLocation areaSpan:_currentSearchAreaSpan];
    [self searchArea:nil];

    self.mapView.showsUserLocation = TRUE;
    _followUser = FALSE;
    self.mapView.delegate = self;
    
    UITapGestureRecognizer *singleTapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapSingleClick:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapDoubleClick:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:doubleTapRecognizer];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
}



- (void)updateLocationLabel:(CLLocationCoordinate2D)location horizAccuracy:(double)accuracy {
    self.labelLocationDetails.text = [NSString stringWithFormat:@"Lat: %f , Long: %f , Acc: %.1fm",
                                      location.latitude,
                                      location.longitude,
                                      accuracy];
}

- (void)updateSearchAreaLabel:(double)stepperValue
{
    _currentSearchAreaSpan = 1000 * pow(2, stepperValue);
    self.areaLabel.text = [NSString stringWithFormat:@"Span: %dm", _currentSearchAreaSpan];
    
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
    NSLog(@"SearchArea: %@", _currentSearchAreaPolygon);

    // Circle area overlay
    //MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:1000];
    //[mapView addOverlay:circle];
}

- (void)updateOccurrenceAnnotations:(NSArray *)occurrenceResults
{
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (int i = 0; i < kMapMarkersMax && i < occurrenceResults.count; i++) {
        [self addOccurrenceAnnotation:occurrenceResults[i]];
    }
    
}

- (void)addOccurrenceAnnotation:(GBIFOccurrence *)occurrence
{
    OccurrenceLocation *location = [[OccurrenceLocation alloc] initWithGBIFOccurrence:occurrence];
    [self.mapView addAnnotation:location];
}

- (void)updateCurrentMapView:(CLLocationCoordinate2D)location latitudinalMeters:(int)latRegionSpan longitudinalMeters:(int)longRegionSpan
{
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(location, latRegionSpan, longRegionSpan);
    NSLog(@"MKCoordinationRegion.span: %.4f, %.4f", region.span.latitudeDelta, region.span.longitudeDelta);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapSingleClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"SingleClick");
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D mapCoord = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:mapCoord animated:YES];
    [self updateSearchAreaOverlay:mapCoord areaSpan:_currentSearchAreaSpan];
    
}

- (void)mapDoubleClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"DoubleClick");
}

#pragma mark IBActions

- (IBAction)changeMapType:(id)sender
{
    NSString *mapType = @"MapType: %@";
    
    switch (self.mapView.mapType) {
        case MKMapTypeStandard:
            [self.mapView setMapType:MKMapTypeSatellite];
            [self.mapTypeButton setTitle:[NSString stringWithFormat:mapType, @"Satellite"] forState:UIControlStateNormal];
            break;
            
        case MKMapTypeSatellite:
            [self.mapView setMapType:MKMapTypeHybrid];
            [self.mapTypeButton setTitle:[NSString stringWithFormat:mapType, @"Hybrid"] forState:UIControlStateNormal];
            break;

        default:
            [self.mapView setMapType:MKMapTypeStandard];
            [self.mapTypeButton setTitle:[NSString stringWithFormat:mapType, @"Standard"] forState:UIControlStateNormal];
            break;
    }
}

- (IBAction)zoomToLocation:(id)sender {
    [self updateCurrentMapView:_currentSearchAreaPolygon.coordinate latitudinalMeters:0 longitudinalMeters:_currentSearchAreaSpan];
}

- (IBAction)searchZoomChanged:(UIStepper *)sender
{
    [self updateSearchAreaLabel:sender.value];
    [self updateSearchAreaOverlay:_currentSearchAreaPolygon.coordinate areaSpan:_currentSearchAreaSpan];
}

- (IBAction)searchArea:(id)sender
{
    [_manager fetchOccurencesWithinArea:_currentSearchAreaPolygon];
}

- (IBAction)currentLocation:(id)sender {
    [self updateLocationLabel:_currentUserLocation.coordinate horizAccuracy:_currentUserLocation.horizontalAccuracy];
    [self updateSearchAreaOverlay:_currentUserLocation.coordinate areaSpan:_currentSearchAreaSpan];
    [self updateCurrentMapView:_currentUserLocation.coordinate latitudinalMeters:0 longitudinalMeters:kDefaultViewSpan];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    _currentUserLocation = userLocation.location;
    
    if (_followUser) {
        [self.mapView setCenterCoordinate:userLocation.coordinate animated:TRUE];
        [self updateSearchAreaOverlay:userLocation.coordinate areaSpan:_currentSearchAreaSpan];
    }

    /*
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 0, 5000);
    NSLog(@"MKCoordinationRegion.span: %.4f, %.4f", region.span.latitudeDelta, region.span.longitudeDelta);
    [self.mapView setRegion:region animated:YES];
    
    [self updateSearchAreaOverlay:userLocation.coordinate latitudeSpan:_currentSearchAreaSize longitudeSpan:_currentSearchAreaSize];
     */
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
    [self updateLocationLabel:mapView.centerCoordinate horizAccuracy:0];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"OccurrenceLocation";
    if ([annotation isKindOfClass:[OccurrenceLocation class]]) {
/*
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.pinColor = MKPinAnnotationColorRed;
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
*/
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:((OccurrenceLocation *)annotation).mapMarkerImageFile];

        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)gr
{
    return TRUE;
}

#pragma mark GBIFManagerDelegate

- (void)didReceiveOccurences:(GBIFOccurrenceResults *)occurrenceResults
{
    NSLog(@"ExploreMapViewController didReceiveOccurences: %lu", (unsigned long)occurrenceResults.Results.count);
    _occurrenceResults = occurrenceResults;
    [self updateOccurrenceAnnotations:occurrenceResults.Results];
    [self zoomToLocation:nil];
}

- (void)fetchingResultsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ExploreListSegue"]) {
        ExploreListViewController *vc = [segue destinationViewController];
        [vc setSearchAreaCenter:_currentSearchAreaPolygon.coordinate];
        [vc setSearchAreaSpan:_currentSearchAreaSpan];
        [vc setOccurenceResults:_occurrenceResults];
    } else if ([segue.identifier isEqualToString:@"ExploreTableSegue"]) {
        ExploreTableViewController *vc = [segue destinationViewController];
        [vc setOccurenceResults:_occurrenceResults];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
