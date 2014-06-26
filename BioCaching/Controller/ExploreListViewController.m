//
//  ExploreListViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreListViewController.h"
#import "OccurrenceDetailsViewController.h"
#import "ExploreDataManager.h"
#import "TripsDataManager.h"

@interface ExploreListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;

@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelResultsCount;

@property (weak, nonatomic) IBOutlet UITableView *tableViewResults;

@end


@implementation ExploreListViewController {
    GBIFOccurrenceResults *_occurrenceResults;
    NSArray *_filteredResults;
    INatTrip *_currentTrip;
    BOOL deletingRow;
}

#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    _occurrenceResults = [ExploreDataManager sharedInstance].occurrenceResults;
    _filteredResults = [_occurrenceResults getFilteredResults:YES];
    _currentTrip = [TripsDataManager sharedInstance].currentTrip;
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
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor kColorButtonLabel] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonSidebar.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    
    // Change button color
    //    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
}

- (void)setupButtons
{
    [self.buttonEdit setTitle:nil forState:UIControlStateNormal];
    [self.buttonEdit setBackgroundImage:
     [IonIcons imageWithIcon:icon_edit iconColor:[UIColor kColorButtonLabel] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonEdit.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
}


- (void)setupLabels
{
    [self.labelLocation setTextWithColor:[NSString stringWithFormat:@"Location: %f,%f",
                               self.bcOptions.searchOptions.searchAreaCentre.latitude,
                               self.bcOptions.searchOptions.searchAreaCentre.longitude] color:[UIColor kColorHeaderText]];
    
    [self.labelAreaSpan setTextWithColor:[NSString stringWithFormat:@"Area Span: %lum",
                               (unsigned long)self.bcOptions.searchOptions.searchAreaSpan] color:[UIColor kColorHeaderText]];
    
    [self.labelResultsCount setTextWithColor:[NSString stringWithFormat:@"Record Count: %d",
                                              (int)[_occurrenceResults getFilteredResults:YES].count] color:[UIColor kColorHeaderText]];
}


#pragma mark - IBActions



#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
/*
 #ifdef DEBUG
    if (_bcOptions.displayOptions.displayPoints < _filteredResults.count)
    {
        return _bcOptions.displayOptions.displayPoints;
    }
#endif
*/
    if (deletingRow && (_filteredResults.count >= _bcOptions.displayOptions.displayPoints)) {
        return _filteredResults.count - 1;
    } else {
        return _filteredResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBIFOccurrence *occurrence = _filteredResults[indexPath.row];

    TaxonListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxonListCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor kColorTableBackgroundColor];
    
    cell.imageIconicTaxon.image = [UIImage imageNamed:[occurrence getINatIconicTaxaMainImageFile]];
    [cell.labelTaxonTitle setTextWithDefaults:occurrence.title];
    [cell.labelTaxonSubTitle setTextWithDefaults:occurrence.subtitle];

    if (occurrence.iNatTaxon.taxonPhotos.count == 0) {
        cell.labelTaxonTitle.text = [NSString stringWithFormat:@"%@ **", cell.labelTaxonTitle.text];
    }
#ifdef DEBUG
    cell.labelTaxonSubTitle.text = [NSString stringWithFormat:@"%03lu  %@", (long)indexPath.row, occurrence.detailsSubTitle];
#endif
    
    if (!_currentTrip)
    {
        [cell.buttonAction setTitle:@"Remove" forState:UIControlStateNormal];
        cell.buttonAction.backgroundColor = [UIColor kColorDarkRed];
    } else
    {
        [cell.buttonAction setTitle:@"Record" forState:UIControlStateNormal];
        cell.buttonAction.backgroundColor = [UIColor kColorDarkGreen];
    }
        
    cell.delegate = self;
    
//    [cell.buttonAction addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.buttonAction.backgroundColor = [UIColor redColor];
//    cell.buttonAction.titleLabel.text = @"Remove";

    return cell;
}

- (void)actionButtonSelected:(TaxonListCell *)cell
{
    if (!_currentTrip) {
        NSIndexPath *indexPath = [self.tableViewResults indexPathForCell:cell];
        GBIFOccurrence *occurrence = _filteredResults[indexPath.row];
        
        NSLog(@"Action Button: %lu - %@", indexPath.row, occurrence.title);
        
        [[ExploreDataManager sharedInstance] removeOccurrence:occurrence];
        _filteredResults = [_occurrenceResults getFilteredResults:YES];

        deletingRow = YES;
        [self.tableViewResults deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        deletingRow = NO;
        [self.tableViewResults reloadData];
        [self setupLabels];
    } else {
        [cell.buttonAction setTitle:@"Seen" forState:UIControlStateNormal];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row Selected: %lu", indexPath.row);
    GBIFOccurrence *occurrence = _filteredResults[indexPath.row];
    
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
        detailsVC.occurrence = _filteredResults[selectedIndexPath.row];
    }
    
}

@end
