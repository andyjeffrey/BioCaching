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
@property (weak, nonatomic) IBOutlet UIButton *buttonRefresh;

- (IBAction)buttonSidebar:(id)sender;
- (IBAction)buttonRefresh:(id)sender;

@end

@implementation TripsViewController {
    TripsDataManager *tripsDataManager;
    NSArray *_tableSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    tripsDataManager = [TripsDataManager sharedInstance];

    [self setupUI];
    [self setupTable];
    
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
    [self setupButtons];
}

- (void)setupSidebar
{
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    // Change button color
//    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
}

- (void)setupButtons
{
    [self.buttonRefresh setTitle:nil forState:UIControlStateNormal];
    [self.buttonRefresh setBackgroundImage:
     [IonIcons imageWithIcon:icon_refresh iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonRefresh.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
}

- (void)setupTable
{
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    [sections addObject:@[@"Saved For Later", [NSNumber numberWithInt:TripStatusCreated], tripsDataManager.savedTrips]];
    [sections addObject:@[@"In Progress", [NSNumber numberWithInt:TripStatusInProgress], tripsDataManager.inProgressTrips]];
    [sections addObject:@[@"Finished", [NSNumber numberWithInt:TripStatusFinished], tripsDataManager.finishedTrips]];
    [sections addObject:@[@"Published", [NSNumber numberWithInt:TripStatusPublished], tripsDataManager.publishedTrips]];
    _tableSections = [[NSArray alloc] initWithArray:sections];
}


- (void)loadCompletedTripsFromINat
{
    [tripsDataManager loadAllTripsFromINat:nil success:^(NSArray *trips) {
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
    NSArray *sectionArray = _tableSections[section][2];
    
    if (sectionArray && sectionArray.count > 0) {
        rowCount = sectionArray.count;
    } else {
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
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }
    
    cell.labelTripTitle.text = trip.title;

    NSString *subtitle;
    if (trip.startTime) {
        subtitle = [NSString stringWithFormat:@"%@ - ", [trip.startTime localDateTime]];
        if (trip.stopTime) {
            subtitle = [subtitle stringByAppendingString:[trip.stopTime localTime]];
        }
    } else {
        subtitle = [NSString stringWithFormat:@"Trip Created: %@", [trip.localCreatedAt localDateTime]];
    }
    cell.labelTripSubtitle.text = subtitle;
    
    cell.labelTripSummaryStats.text = [NSString stringWithFormat:@"%d / %d",
                                       0,
                                       (int)trip.taxaAttributes.count];
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
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }
    
    if (!trip) {
        NSLog(@"Cell Selected: %lu-%lu: NO TRIP", (long)indexPath.section, (long)indexPath.row);
    } else if (trip.status.intValue == TripStatusPublished) {
        NSLog(@"Cell Selected: %lu-%lu: Deleting Trip...", (long)indexPath.section, (long)indexPath.row);
        [tripsDataManager deleteTripFromINat:trip];

/*
        NSLog(@"Cell Selected: %lu-%lu: %@", (long)indexPath.section, (long)indexPath.row, trip.recordId);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Published Trip Selected", nil)
                                                     message:NSLocalizedString(@"In future this will show trip details and give option to create a duplicate trip?", nil)
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                           otherButtonTitles:nil];
        [av show];
        
        [[RKObjectManager sharedManager] getObject:trip path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"Trip Received: %@", mappingResult);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error mapping result: %@", error);
        }];
*/
    } else if (trip.status.intValue == TripStatusFinished) {
        NSLog(@"Cell Selected: %lu-%lu: Saving Trip...", (long)indexPath.section, (long)indexPath.row);
        if ([LoginManager sharedInstance].loggedIn) {
            [tripsDataManager saveTripToINat:trip];
        } else {
            [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
        }
    } else {
        [BCAlerts displayDefaultInfoAlert:@"Saved/In Progress Trip Selected" message:@"In future this will take you back to the Explore page for the selected trip"];
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


#pragma-mark IBActions

- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)buttonRefresh:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self loadCompletedTripsFromINat];
}

@end
