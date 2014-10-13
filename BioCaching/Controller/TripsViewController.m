//
//  TripsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsViewController.h"
#import "ExploreContainerViewController.h"
#import "SidebarViewController.h"
#import "BCWebViewController.h"

#import "TripsDataManager.h"
#import "INatTrip.h"

@interface TripsViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

- (IBAction)buttonSidebar:(id)sender;
- (IBAction)buttonActionEdit:(id)sender;

@end

@implementation TripsViewController {
    UITableViewController *_tableVC;
    TripsDataManager *_tripsDataManager;
    NSArray *_tableSections;
}


#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    _tripsDataManager = [TripsDataManager sharedInstance];
    _tripsDataManager.delegate = self;
    
    [self setupUI];
    [self setupTableData];
//    [self setupRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshTable];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"TripList"];
}


#pragma mark - Setup UI/Refresh Methods
- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
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
    self.buttonEdit.enabled = YES;
    [self.buttonEdit setTitle:nil forState:UIControlStateNormal];
    self.buttonEdit.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [self updateEditButton];
/*
    [self.buttonRefresh setTitle:nil forState:UIControlStateNormal];
    [self.buttonRefresh setBackgroundImage:
     [IonIcons imageWithIcon:icon_refresh iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonRefresh.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
*/
}

- (void)setupRefreshControl
{
    _tableVC = [[UITableViewController alloc] init];
    _tableVC.tableView = self.tableView;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh Trip History from iNaturalist" attributes:@{NSForegroundColorAttributeName:[UIColor kColorTableCellText]}];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor kColorTableCellText];
    _tableVC.refreshControl = refreshControl;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableVC.refreshControl beginRefreshing];
        [_tableVC.refreshControl endRefreshing];
    });
    
    
}

- (void)updateEditButton
{
    if (self.tableView.editing) {
        [self.buttonEdit setBackgroundImage:[IonIcons imageWithIcon:icon_checkmark_circled iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    } else {
        [self.buttonEdit setBackgroundImage:[IonIcons imageWithIcon:icon_edit iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    }
}


- (void)setupTableData
{
    NSMutableArray *sections = [[NSMutableArray alloc] init];
#ifdef TESTING
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
    [self setupTableData];
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
    header.contentView.backgroundColor = [UIColor kColorTableHeaderBackgroundColor];
    [header.textLabel setTextColor:[UIColor kColorLabelText]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip = [self getTripForIndexPath:indexPath];

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
    
    cell.labelTripSubtitle.font = [UIFont systemFontOfSize:13];
    cell.labelTripSubtitle.textColor = [UIColor kColorTableCellText];
    cell.labelTripSubtitle.text = subtitle;
    
    cell.labelTripSummaryStats.text = [NSString stringWithFormat:@"%d / %d",
                                       (int)trip.observations.count,
                                       (int)trip.taxaAttributes.count];
    cell.labelBackground.text = @"";
    
    if (trip.statusValue == TripStatusFinished) {
        [cell.buttonAction setTitle:@"Upload" forState:UIControlStateNormal];
        [cell.buttonAction setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        cell.buttonAction.enabled = YES;
        cell.buttonAction.hidden = self.tableView.editing;
    } else if (trip.statusValue == TripStatusPublished) {
        [cell.buttonAction setTitle:@"iNat" forState:UIControlStateNormal];
        [cell.buttonAction setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        cell.buttonAction.enabled = YES;
        cell.buttonAction.hidden = self.tableView.editing;
    } else {
        cell.buttonAction.hidden = YES;
    }
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip = [self getTripForIndexPath:indexPath];
    
    if (trip) {
        _tripsDataManager.currentTrip = trip;
        [self performSegueWithIdentifier:@"ExploreVC" sender:nil];
    } else {
        NSLog(@"Cell Selected: %lu-%lu: NO TRIP", (long)indexPath.section, (long)indexPath.row);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripListCell *cell = (TripListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonAction.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip = [self getTripForIndexPath:indexPath];
    if (trip.status.intValue == TripStatusFinished) {
        TripListCell *cell = (TripListCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.buttonAction.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteTripAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)actionButtonSelected:(TripListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    INatTrip *trip = [self getTripForIndexPath:indexPath];

    NSLog(@"actionButtonSelectedForTripAtIndexPath:%d-%d:%@",
          (int)indexPath.section, (int)indexPath.row, trip.title);
    
    if (trip.status.intValue == TripStatusFinished) {
        cell.buttonAction.enabled = NO;
        [cell.buttonAction setTitle:@"Queued" forState:UIControlStateNormal];
        if ([LoginManager sharedInstance].loggedIn) {
            [_tripsDataManager addTripToUploadQueue:trip];
            [_tripsDataManager initiateUploads];
        } else {
            [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
        }
    } else if (trip.status.intValue == TripStatusPublished) {
/*
        if ([LoginManager sharedInstance].loggedIn) {
            [cell.activityIndicator startAnimating];
            [_tripsDataManager deleteTripFromINat:trip];
        } else {
            [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
        }
*/
        NSURL *tripURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/trips/%d", kINatBaseURL, trip.recordIdValue]];
        BCWebViewController *webVC = [[BCWebViewController alloc] initWithURL:tripURL fixedTitle:@"Trip Record on iNat"];
        [self.navigationController pushViewController:webVC animated:TRUE];
        
    } else {
        [_tripsDataManager deleteTripFromLocalStore:trip];
    }
}




#pragma mark - TripsDataManagerDelegate

- (void)tripsDataTableUpdated
{
    [self refreshTable];
    [self.tableView reloadData];
    [_tableVC.refreshControl endRefreshing];
}

- (void)startedUpload:(INatTrip *)trip
{
    TripListCell *cell = [self getTableCellForTrip:trip];
    cell.buttonAction.hidden = YES;
    [cell.activityIndicator startAnimating];
    cell.labelTripSubtitle.font = [UIFont systemFontOfSize:10];
}

- (void)finishedUpload:(INatTrip *)trip success:(BOOL)success
{
    TripListCell *cell = [self getTableCellForTrip:trip];
    if (success) {
        [BCAlerts displayDefaultSuccessNotification:@"Trip Successfully Published To iNaturalist" subtitle:nil];
        [self tripsDataTableUpdated];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            cell.labelTripSubtitle.alpha = 0;
            cell.labelTripSubtitle.font = [UIFont systemFontOfSize:13];
            cell.labelTripSubtitle.text = @"Error Uploading Trip - Please Retry";
            cell.buttonAction.alpha = 0;
            cell.buttonAction.hidden = NO;
            [cell.buttonAction setTitle:@"Upload" forState:UIControlStateNormal];
            [UIView animateWithDuration:1 animations:^{
                cell.labelTripSubtitle.alpha = 1;
                cell.buttonAction.alpha = 1;
            }];
        });
        [BCAlerts displayDefaultFailureNotification:@"Trip Publication Failed" subtitle:@"Please Retry The Upload"];
    }
}

- (void)uploadProgress:(INatTrip *)trip progressString:(NSString *)progressString success:(BOOL)success
{
    TripListCell *cell = [self getTableCellForTrip:trip];
    // Update UI on main thread??...
    //        dispatch_async(dispatch_get_main_queue(), ^{
    cell.labelTripSubtitle.text = progressString;
    if (success) {
        cell.labelTripSubtitle.textColor = [UIColor kColorDarkGreen];
    } else {
        cell.labelTripSubtitle.textColor = [UIColor redColor];
    }
    //        });
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

- (IBAction)buttonActionEdit:(id)sender
{
    self.tableView.editing = !self.tableView.editing;
    [self updateEditButton];
    [self.tableView reloadData];
}

#pragma-mark Helper Methods
- (INatTrip *)getTripForIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip;
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }
    return trip;
}

- (TripListCell *)getTableCellForTrip:(INatTrip *)trip
{
    int uploadingTableSection = 2;
#if TESTING
    uploadingTableSection = 3;
#endif
    int uploadingTableRow = (int)[_tableSections[uploadingTableSection][2] indexOfObject:trip];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:uploadingTableRow inSection:uploadingTableSection];
    TripListCell *cell = (TripListCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    return cell;
}


- (void)deleteTripAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip;
    NSArray *sectionArray = _tableSections[indexPath.section][2];
    if (sectionArray && sectionArray.count > 0) {
        trip = sectionArray[indexPath.row];
    }
    
    if (trip.status.intValue != TripStatusPublished) {
        [_tripsDataManager deleteTripFromLocalStore:trip];
    } else {
        [BCAlerts displayOKorCancelAlert:@"Please Confirm Deletion" message:@"Trip published on iNaturalist\nDo you want to delete from both\n local device and iNaturalist,\n or just local device?" okButtonTitle:@"Device" okBlock:^{
            [_tripsDataManager deleteTripFromLocalStore:trip];
        } cancelButtonTitle:@"Both" cancelBlock:^{
            if ([LoginManager sharedInstance].loggedIn) {
                TripListCell *cell = (TripListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell.activityIndicator startAnimating];
                [_tripsDataManager deleteTripFromINat:trip];
            } else {
                [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
            }
        }];
    }
    
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)refreshTripsFromINat
{
    if ([LoginManager sharedInstance].loggedIn) {
        NSString *iNatUsername = [[NSUserDefaults standardUserDefaults] valueForKey:kINatAuthUsernamePrefKey];
        [_tripsDataManager loadTripsFromINat:iNatUsername];
    } else {
        [BCAlerts displayDefaultInfoAlert:@"Authentication Required" message:@"Please Sign In Before Continuing\n (Automatically take user to profile/signin screen?)"];
        [_tableVC.refreshControl endRefreshing];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self performSelector:@selector(refreshTripsFromINat) withObject:nil afterDelay:0.5];
}




@end
