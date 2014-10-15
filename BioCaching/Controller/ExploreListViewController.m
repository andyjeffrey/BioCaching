//
//  ExploreListViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreListViewController.h"
#import "ExploreContainerViewController.h"
#import "OccurrenceDetailsViewController.h"
#import "OccurrenceTableViewControler.h"
#import "ObservationViewController.h"
#import "ExploreDataManager.h"
#import "TripsDataManager.h"
#import "BCOptions.h"

static const int ddLogLevel = LOG_LEVEL_INFO;

@interface ExploreListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelResultsCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)buttonActionEdit:(id)sender;

@end


@implementation ExploreListViewController {
    ExploreContainerViewController *_exploreContVC;
    BCOptions *_bcOptions;
    TripsDataManager *_tripsDataManager;
    INatTrip *_currentTrip;
//    BOOL deletingRow;
}

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    DDLogDebug(@"%s", __PRETTY_FUNCTION__);
    
    _bcOptions = [BCOptions sharedInstance];
    _tripsDataManager = [TripsDataManager sharedInstance];

    [self setupSidebar];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    _exploreContVC = (ExploreContainerViewController *)self.parentViewController;
    if (_exploreContVC.currentTrip != _tripsDataManager.currentTrip) {
        _exploreContVC.currentTrip = _tripsDataManager.currentTrip;
    }
    _currentTrip = _exploreContVC.currentTrip;

    [self setupEditButton];
    [self setupLabels];
    [self.tableView reloadData];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _exploreContVC.viewButtonsPanel.frame.size.width, _exploreContVC.viewButtonsPanel.frame.size.height) ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [BCLoggingHelper recordGoogleScreen:@"ExploreList"];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark Sidebar Methods
- (void)setupSidebar
{
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
    [self.buttonSidebar setBackgroundImage:[IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
//    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
}

- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}


#pragma mark - Setup UI/Refresh Methods
- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    //    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
    [self setupSidebar];
}

- (void)setupEditButton
{
    if (_currentTrip) {
        self.buttonEdit.hidden = NO;
        self.buttonEdit.enabled = YES;
        [self updateEditButton];
    }
}

- (void)setupLabels
{
    [self.labelLocation setTextColor:[UIColor kColorHeaderText]];
    if (_currentTrip) {
        self.labelLocation.font = [UIFont systemFontOfSize:self.labelLocation.font.pointSize];
    } else {
        self.labelLocation.font = [UIFont italicSystemFontOfSize:self.labelLocation.font.pointSize];
        [self.labelLocation setText:@"No Active Search Results/Trip"];
    }
    
    [self.labelAreaSpan setTextWithColor:@"Area Span: " color:[UIColor kColorHeaderText]];
    [self.labelResultsCount setTextWithColor:@"Record Count: " color:[UIColor kColorHeaderText]];

    if (_currentTrip) {
        self.labelLocation.text = [CLLocation latLongStringFromCoordinate:_currentTrip.locationCoordinate];
        self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %@", _currentTrip.searchAreaSpan];
        self.labelResultsCount.text = [NSString stringWithFormat:@"Record Count: %d", (int)_currentTrip.occurrenceRecords.count];
    }
}

- (void)updateEditButton
{
    if (self.tableView.editing) {
        [self.buttonEdit setBackgroundImage:[IonIcons imageWithIcon:icon_checkmark_circled iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    } else {
        [self.buttonEdit setBackgroundImage:[IonIcons imageWithIcon:icon_edit iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    }
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_currentTrip) {
        return _currentTrip.occurrenceRecords.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxonListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor kColorTableBackgroundColor];

    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    
    cell.imageIconicTaxon.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMainImageFile]];
    
    if (occurrence.iNatTaxon.commonName) {
        [cell.labelTaxonTitle setTextWithColor:occurrence.title color:[occurrence getINatIconicTaxonColor]];
        [cell.labelTaxonSubTitle setTextWithDefaults:occurrence.subtitle];
        cell.labelTaxonTitle.hidden = NO;
        cell.labelTaxonSubTitle.hidden = NO;
        cell.labelTaxonScientific.hidden = YES;
    } else {
        [cell.labelTaxonScientific setTextWithColor:occurrence.subtitle color:[occurrence getINatIconicTaxonColor]];
        cell.labelTaxonTitle.hidden = YES;
        cell.labelTaxonSubTitle.hidden = YES;
        cell.labelTaxonScientific.hidden = NO;
    }
    
    if (occurrence.iNatTaxon.taxonPhotos.count == 0) {
        cell.labelTaxonTitle.text = [NSString stringWithFormat:@"%@ **", cell.labelTaxonTitle.text];
    }
#ifdef TESTING
    cell.labelTaxonSubTitle.text = [NSString stringWithFormat:@"%03lu  %@", (long)indexPath.row, occurrence.subtitle];
#endif

    if (_currentTrip.status.intValue >= TripStatusInProgress) {
        if (_currentTrip.status.intValue < TripStatusPublished) {
            if (!occurrence.taxaAttribute.observation) {
                [cell.buttonAction setTitle:@"Record" forState:UIControlStateNormal];
                cell.buttonAction.backgroundColor = [UIColor kColorDarkGreen];
                if (_currentTrip.statusValue < TripStatusFinished) {
                    cell.buttonAction.hidden = self.tableView.editing;
                } else {
                    cell.buttonAction.hidden = YES;
                }
            } else {
                [cell.buttonAction setTitle:@"Edit" forState:UIControlStateNormal];
                cell.buttonAction.backgroundColor = [UIColor orangeColor];
                cell.buttonAction.hidden = self.tableView.editing;
            }
        } else {
            if (!occurrence.taxaAttribute.observation) {
                cell.buttonAction.hidden = YES;
            } else {
                [cell.buttonAction setTitle:@"View" forState:UIControlStateNormal];
                cell.buttonAction.backgroundColor = [UIColor orangeColor];
            }
        }
    } else {
        cell.buttonAction.hidden = YES;
    }
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    
    DDLogDebug(@"didSelectRowAtIndexPath: %d - %@", indexPath.row, occurrence.title);
    
//    OccurrenceDetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OccurrenceDetails"];
//    detailsVC.occurrence = occurrence;
//    [self.navigationController pushViewController:detailsVC animated:YES];

    OccurrenceTableViewControler *occurrenceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OccurrenceVC"];
    occurrenceVC.occurrence = occurrence;
    [self.navigationController pushViewController:occurrenceVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxonListCell *cell = (TaxonListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.buttonAction.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaxonListCell *cell = (TaxonListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (_currentTrip.statusValue >= TripStatusInProgress) {
        cell.buttonAction.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDLogDebug(@"commitEditingStyle: %d", indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteOccurrenceAtIndexPath:indexPath];
    }
}


#pragma mark IBActions
- (IBAction)buttonActionEdit:(id)sender {
    //    [self.tableView setEditing:!self.tableView.editing animated:YES];
    self.tableView.editing = !self.tableView.editing;
    [self updateEditButton];
    [self.tableView reloadData];
}

- (void)actionButtonSelected:(TaxonListCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    DDLogDebug(@"Action Button: %d - %@", indexPath.row, occurrence.title);

    // Only used for record/edit now, so can delete TripStatus condition
//    if (_currentTrip && _currentTrip.status.intValue >= TripStatusInProgress)
    ObservationViewController *observationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Observation"];
    observationVC.occurrence = occurrence;
    if (_currentTrip.status.intValue == TripStatusPublished) {
        observationVC.locked = YES;
    }
    [self.navigationController pushViewController:observationVC animated:YES];
}


#pragma mark Storyboard Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OccurrenceDetails"]) {
        OccurrenceDetailsViewController *detailsVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//        DDLogDebug(@"%@:%lu", selectedIndexPath, (long)selectedIndexPath.row);
        detailsVC.occurrence = _currentTrip.occurrenceRecords[selectedIndexPath.row];
    }
    
}

#pragma mark-Helper Methods
- (void)deleteOccurrenceAtIndexPath:(NSIndexPath *)indexPath
{
    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    [_tripsDataManager removeOccurrenceFromTrip:_currentTrip occurrence:occurrence];
    //    deletingRow = YES;
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    //    deletingRow = NO;
    //    [self.tableView reloadData];
    [self setupLabels];
}

// Use KVO for table updates
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
    if ([kind integerValue] == NSKeyValueChangeRemoval) {
        
    }
}



@end
