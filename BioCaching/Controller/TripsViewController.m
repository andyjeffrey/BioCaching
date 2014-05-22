//
//  TripsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsViewController.h"
#import "TripsDataManager.h"
#import "ExploreListViewController.h"
#import "TripsListCell.h"
#import "INatTrip.h"
#import <RestKit/RestKit.h>

#import "SWRevealViewController.h"

@interface TripsViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet UITableView *tableTrips;
@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;

- (IBAction)buttonSidebar:(id)sender;
@end

@implementation TripsViewController {
    TripsDataManager *tripsDataManager;
//    NSArray *_trips;
    NSArray *_tableSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setupUI];
    [self setupTable];
    
//    [self configureRestKit];
    tripsDataManager = [TripsDataManager sharedInstance];
    [self loadCompletedTripsFromINat];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableTrips reloadData];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    self.tableTrips.backgroundColor = [UIColor kColorTableBackgroundColor];
    [self setupSidebar];
}

- (void)setupSidebar
{
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    // Change button color
    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
}


- (void)setupTable
{
    NSMutableArray *sections = [[NSMutableArray alloc] initWithCapacity:3];
    [sections addObject:@[@"Saved For Later", [NSNumber numberWithInt:TripStatusCreated]]];
    [sections addObject:@[@"In Progress", [NSNumber numberWithInt:TripStatusInProgress]]];
    [sections addObject:@[@"Completed", [NSNumber numberWithInt:TripStatusCompleted]]];
    _tableSections = [[NSArray alloc] initWithArray:sections];
}


- (void)configureRestKit
{
/*
    NSURL *baseURL = [NSURL URLWithString:kINatBaseURL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    RKObjectMapping *iNatMapping = [RKObjectMapping mappingForClass:[INatTrip class]];
    [iNatMapping addAttributeMappingsFromArray:@[@"title", @"created_at"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:iNatMapping method:RKRequestMethodGET pathPattern:kINatTripsPath keyPath:kINatTripsKey statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
*/
}

- (void)loadCompletedTripsFromINat
{
    [tripsDataManager loadAllTrips:nil success:^(NSArray *trips) {
//        _trips = trips;
        [self.tableTrips reloadData];
    }];
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount;
    if (section == TripStatusCreated) {
        rowCount = [TripsDataManager sharedInstance].createdTrips.count;
    } else if (section == TripStatusInProgress) {
        rowCount = [TripsDataManager sharedInstance].inProgressTrips.count;
    } else {
        rowCount = [TripsDataManager sharedInstance].completedTrips.count;
    }
    
    if (rowCount == 0) {
        rowCount = 1;
    }
        
    
    return rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _tableSections[section][0];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
    [header.textLabel setTextColor:[UIColor kColorLabelText]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripsListCell" forIndexPath:indexPath];

    INatTrip *trip;
    
    if (indexPath.section == TripStatusCreated) {
        if (tripsDataManager.createdTrips.count > 0) {
            trip = tripsDataManager.createdTrips[indexPath.row];
        }
    } else if (indexPath.section == TripStatusInProgress) {
        if (tripsDataManager.inProgressTrips.count > 0) {
            trip = tripsDataManager.inProgressTrips[indexPath.row];
        }
    } else {
        if (tripsDataManager.completedTrips.count > 0) {
            trip = tripsDataManager.completedTrips[indexPath.row];
        }
    }

    cell.labelTripTitle.text = trip.title;
    cell.labelTripSubtitle.text = [NSString stringWithFormat:@"%@", trip.createdAt];
    cell.labelTripSummaryStats.text = [NSString stringWithFormat:@"%d / %d", 0, 0];
    cell.labelBackground.text = @"";
    
    if (!trip) {
        cell.labelTripTitle.text = @"";
        cell.labelTripSubtitle.text = @"";
        cell.labelTripSummaryStats.text = @"";
        cell.labelBackground.text = @"[No Trips]";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip;
    
    if (indexPath.section == TripStatusCreated) {
        if (tripsDataManager.createdTrips.count > 0) {
            trip = tripsDataManager.createdTrips[indexPath.row];
        }
    } else if (indexPath.section == TripStatusInProgress) {
        if (tripsDataManager.inProgressTrips.count > 0) {
            trip = tripsDataManager.inProgressTrips[indexPath.row];
        }
    } else {
        if (tripsDataManager.completedTrips.count > 0) {
            trip = tripsDataManager.completedTrips[indexPath.row];
        }
    }
    
    if (!trip) {
        NSLog(@"Cell Selected: %lu-%lu: NO TRIP", (long)indexPath.section, (long)indexPath.row);
    } else if (trip.status == [NSNumber numberWithInt:TripStatusCompleted]) {
        NSLog(@"Cell Selected: %lu-%lu: %@", (long)indexPath.section, (long)indexPath.row, trip.objectId);
        
        [[RKObjectManager sharedManager] getObject:trip path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"Loading mapping result: %@", mappingResult);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error mapping result: %@", error);
        }];
    } else {
        NSLog(@"Cell Selected: %lu-%lu: Saving Trip...", (long)indexPath.section, (long)indexPath.row);
        [tripsDataManager saveTrip:trip];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}

#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushTripTaxaList"]) {
        ExploreListViewController *exploreVC = segue.destinationViewController;
//        exploreVC.iNatTrip = _trips[self.tableTrips.indexPathForSelectedRow.row];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

@end
