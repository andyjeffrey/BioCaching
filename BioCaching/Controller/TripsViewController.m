//
//  TripsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsViewController.h"
#import "ExploreContainerViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"

#import "TripsDataManager.h"
#import "INatTrip.h"

@interface TripsViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet UITableView *tableTrips;
@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefresh;

- (IBAction)buttonSidebar:(id)sender;
- (IBAction)buttonRefresh:(id)sender;

@end

@implementation TripsViewController {
    TripsDataManager *_tripsDataManager;
    NSArray *_tableSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _tripsDataManager = [TripsDataManager sharedInstance];
    _tripsDataManager.tableDelegate = self;
    
    [self setupUI];
    [self setupTable];
    
//    [self loadCompletedTripsFromINat];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshTable];
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
#ifdef DEBUG
    [sections addObject:@[@"Created (Not Saved)", [NSNumber numberWithInt:TripStatusCreated], _tripsDataManager.createdTrips]];
#endif
    [sections addObject:@[@"Saved For Later", [NSNumber numberWithInt:TripStatusSaved], _tripsDataManager.savedTrips]];
    [sections addObject:@[@"In Progress", [NSNumber numberWithInt:TripStatusInProgress], _tripsDataManager.inProgressTrips]];
    [sections addObject:@[@"Finished", [NSNumber numberWithInt:TripStatusFinished], _tripsDataManager.finishedTrips]];
    [sections addObject:@[@"Published", [NSNumber numberWithInt:TripStatusPublished], _tripsDataManager.publishedTrips]];
    _tableSections = [[NSArray alloc] initWithArray:sections];
}

// TODO: Replace With NSFetchedResultsController
- (void)refreshTable
{
    _tableSections = nil;
    [self setupTable];
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
    INatTrip *trip;
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }

    TripListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripListCell" forIndexPath:indexPath];

    if (!trip) {
        cell.labelTripTitle.text = @"";
        cell.labelTripSubtitle.text = @"";
        cell.labelTripSummaryStats.text = @"";
        cell.labelBackground.text = @"[No Trips]";
        cell.buttonAction.hidden = YES;
        return cell;
    }
    
    cell.labelTripTitle.text = trip.title;
    NSString *subtitle;
    if (trip.startTime) {
        subtitle = [NSString stringWithFormat:@"%@ - ", [trip.startTime localDateTime]];
        if (trip.stopTime) {
            subtitle = [subtitle stringByAppendingString:[trip.stopTime localTime]];
        }
    } else {
        subtitle = [NSString stringWithFormat:@"Created: %@", [trip.localCreatedAt localDateTime]];
    }
    cell.labelTripSubtitle.text = subtitle;
    
    cell.labelTripSummaryStats.text = [NSString stringWithFormat:@"%d / %d",
                                       (int)trip.observations.count,
                                       (int)trip.taxaAttributes.count];
    cell.labelBackground.text = @"";
    
    if (trip.status.intValue == TripStatusFinished) {
        [cell.buttonAction setTitle:@"Upload" forState:UIControlStateNormal];
        [cell.buttonAction setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        cell.buttonAction.hidden = NO;
    } else {
        cell.buttonAction.hidden = YES;
#ifdef DEBUG
        [cell.buttonAction setTitle:@"Delete" forState:UIControlStateNormal];
        [cell.buttonAction setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cell.buttonAction.hidden = NO;
#endif
    }
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip;
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }
    
    if (trip) {
        _tripsDataManager.currentTrip = trip;
        [self performSegueWithIdentifier:@"ExploreVC" sender:nil];
    } else {
        NSLog(@"Cell Selected: %lu-%lu: NO TRIP", (long)indexPath.section, (long)indexPath.row);
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionButtonSelected:(TripListCell *)cell
{
    cell.buttonAction.hidden = YES;
    NSIndexPath *indexPath = [self.tableTrips indexPathForCell:cell];
    INatTrip *trip;
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }
    NSLog(@"actionButtonSelectedForTripAtIndexPath:%d-%d:%@",
          (int)indexPath.section, (int)indexPath.row, trip.title);
    
    if (trip.status.intValue == TripStatusFinished) {
        [cell.buttonAction setTitle:@"Uploading" forState:UIControlStateNormal];
        if ([LoginManager sharedInstance].loggedIn) {
            [cell.activityIndicator startAnimating];
            [_tripsDataManager saveTripToINat:trip];
        } else {
            [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
        }
    } else if (trip.status.intValue == TripStatusPublished) {
        if ([LoginManager sharedInstance].loggedIn) {
            [cell.activityIndicator startAnimating];
            [_tripsDataManager deleteTripFromINat:trip];
        } else {
            [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
        }
    } else {
        [_tripsDataManager deleteTripFromLocalStore:trip];
    }
}


#pragma mark - TripsDataManagerDelegate

- (void)tripsTableUpdated
{
    [self refreshTable];
    [self.tableTrips reloadData];
}

#pragma mark UIStoryboard Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);

    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SidebarViewController *sidebarVC = (SidebarViewController*)self.revealViewController.rearViewController;
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
            if (rvc_segue.identifier) {
                UIViewController *cachedVC = [sidebarVC.viewControllersCache objectForKey:rvc_segue.identifier];
                if (cachedVC != nil) {
                    dvc = cachedVC;
//                    dvc = cachedVC.childViewControllers[0];
                } else {
                    [sidebarVC.viewControllersCache setObject:dvc forKey:rvc_segue.identifier];
                }
            }
            //            UINavigationController *navVC = (UINavigationController *)self.revealViewController.frontViewController;
            //            [navVC setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewController:dvc];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}


#pragma-mark IBActions
- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)buttonRefresh:(id)sender {
#ifdef DEBUG
    [_tripsDataManager loadAllTripsFromINat];
#endif
}

@end
