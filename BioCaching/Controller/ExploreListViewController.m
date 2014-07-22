//
//  ExploreListViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreListViewController.h"
#import "OccurrenceDetailsViewController.h"
#import "ObservationViewController.h"
#import "ExploreDataManager.h"
#import "TripsDataManager.h"
#import "BCOptions.h"

@interface ExploreListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelResultsCount;

@property (weak, nonatomic) IBOutlet UITableView *tableViewResults;

@end


@implementation ExploreListViewController {
    BCOptions *_bcOptions;
    TripsDataManager *_tripsDataManager;
    INatTrip *_currentTrip;
    BOOL deletingRow;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.navigationController.navigationBarHidden = YES;
    
    _bcOptions = [BCOptions sharedInstance];
    [self setupUI];
    _tripsDataManager = [TripsDataManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    _currentTrip = _tripsDataManager.currentTrip;
    [self setupLabels];
    [self.tableViewResults reloadData];
    
    //    [self.tableViewResults performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableViewResults deselectRowAtIndexPath:[self.tableViewResults indexPathForSelectedRow] animated:YES];
}


#pragma mark - Init/Setup Methods

- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    //    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    self.tableViewResults.backgroundColor = [UIColor kColorTableBackgroundColor];
    [self setupSidebar];
    [self setupButtons];
}

- (void)setupSidebar
{
    self.buttonSidebar.enabled = NO;
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
//    [self.buttonSidebar setBackgroundImage:[IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    // Change button color
    //    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
}

- (void)setupButtons
{
    self.buttonEdit.enabled = NO;
    [self.buttonEdit setTitle:nil forState:UIControlStateNormal];
//    [self.buttonEdit setBackgroundImage:[IonIcons imageWithIcon:icon_edit iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonEdit.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
}


- (void)setupLabels
{
    [self.labelLocation setTextWithColor:@"No Active Search Results/Trip" color:[UIColor kColorHeaderText]];
    [self.labelAreaSpan setTextWithColor:@"Area Span: " color:[UIColor kColorHeaderText]];
    [self.labelResultsCount setTextWithColor:@"Record Count: " color:[UIColor kColorHeaderText]];

    if (_currentTrip) {
        self.labelLocation.text = [CLLocation latLongStringFromCoordinate:_currentTrip.locationCoordinate];
        self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %@", _currentTrip.searchAreaSpan];
        self.labelResultsCount.text = [NSString stringWithFormat:@"Record Count: %d", (int)_currentTrip.occurrenceRecords.count];
    }
}


#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (deletingRow && (_currentTrip.occurrenceRecords.count >= _bcOptions.displayOptions.displayPoints)) {
        return _currentTrip.occurrenceRecords.count - 1;
    } else {
        return _currentTrip.occurrenceRecords.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GBIFOccurrence *occurrence = _filteredResults[indexPath.row];
    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    
    TaxonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxonListCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor kColorTableBackgroundColor];
    
    cell.imageIconicTaxon.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMainImageFile]];
    [cell.labelTaxonTitle setTextWithDefaults:occurrence.title];
    [cell.labelTaxonSubTitle setTextWithDefaults:occurrence.subtitle];
    
    if (occurrence.iNatTaxon.taxonPhotos.count == 0) {
        cell.labelTaxonTitle.text = [NSString stringWithFormat:@"%@ **", cell.labelTaxonTitle.text];
    }
#ifdef DEBUG
    cell.labelTaxonSubTitle.text = [NSString stringWithFormat:@"%03lu  %@", (long)indexPath.row, occurrence.subtitle];
#endif
    
    if (_currentTrip.status.intValue <= TripStatusSaved) {
        [cell.buttonAction setTitle:@"Remove" forState:UIControlStateNormal];
        cell.buttonAction.backgroundColor = [UIColor kColorDarkRed];
    } else {
        if (!occurrence.taxaAttribute.observation) {
            [cell.buttonAction setTitle:@"Record" forState:UIControlStateNormal];
            cell.buttonAction.backgroundColor = [UIColor kColorDarkGreen];
        } else {
            [cell.buttonAction setTitle:@"Edit" forState:UIControlStateNormal];
            cell.buttonAction.backgroundColor = [UIColor orangeColor];
        }
    }
    cell.delegate = self;
    
    //    [cell.buttonAction addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
    //    cell.buttonAction.backgroundColor = [UIColor redColor];
    //    cell.buttonAction.titleLabel.text = @"Remove";
    
    return cell;
}

#pragma mark IBActions
- (void)actionButtonSelected:(TaxonListCell *)cell
{
    NSIndexPath *indexPath = [self.tableViewResults indexPathForCell:cell];
    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    NSLog(@"Action Button: %lu - %@", indexPath.row, occurrence.title);
    
    if (_currentTrip && _currentTrip.status.intValue >= TripStatusInProgress)
    {
        ObservationViewController *observationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Observation"];
        observationVC.occurrence = occurrence;
        [self.parentViewController.navigationController pushViewController:observationVC animated:YES];
        //        [cell.buttonAction setTitle:@"Seen" forState:UIControlStateNormal];
    } else {
        [_tripsDataManager removeOccurrenceFromTrip:_currentTrip occurrence:occurrence];
        deletingRow = YES;
        [self.tableViewResults deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        deletingRow = NO;
        [self.tableViewResults reloadData];
        [self setupLabels];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row Selected: %lu", indexPath.row);
    OccurrenceRecord *occurrence = _currentTrip.occurrenceRecords[indexPath.row];
    
    //    tableView.editing = YES;
}


// Use KVO for table updates
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
    if ([kind integerValue] == NSKeyValueChangeRemoval) {
        
    }
}


#pragma mark Storyboard Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    NSLog(@"%@:%@ segue=%@", self.class, NSStringFromSelector(_cmd), segue.identifier);
    //    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);
    
    if ([segue.identifier isEqualToString:@"OccurrenceDetails"]) {
        OccurrenceDetailsViewController *detailsVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableViewResults indexPathForSelectedRow];
        //        NSLog(@"%@:%lu", selectedIndexPath, (long)selectedIndexPath.row);
        detailsVC.occurrence = _currentTrip.occurrenceRecords[selectedIndexPath.row];
    }
    
}

@end
