//
//  ExploreOptionsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreOptionsViewController.h"
#import "OptionsRecordType.h"
#import "OptionsRecordSource.h"
#import "OptionsSpeciesFilter.h"

#import "BCDatabaseHelper.h"
#import "TripsDataManager.h"
#import "BCLocationManager.h"

#define kDisplayPointsSliderInterval 5

@interface ExploreOptionsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldYearFrom;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYearTo;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsSettingTitle;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelsSettingValue;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switches;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;


@property (weak, nonatomic) IBOutlet UISlider *sliderAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelRecordType;
@property (weak, nonatomic) IBOutlet UILabel *labelRecordSource;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeciesFilter;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordType;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordSource;
@property (weak, nonatomic) IBOutlet UIButton *buttonSpeciesFilter;

@property (weak, nonatomic) IBOutlet UISlider *sliderDisplayPoints;
@property (weak, nonatomic) IBOutlet UILabel *labelPoints;
@property (weak, nonatomic) IBOutlet UISwitch *switchFullSpeciesNames;
@property (weak, nonatomic) IBOutlet UISwitch *switchUniqueSpecies;
@property (weak, nonatomic) IBOutlet UISwitch *switchUniqueLocations;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segControlMapType;
@property (weak, nonatomic) IBOutlet UISwitch *switchFollowUser;
@property (weak, nonatomic) IBOutlet UISwitch *switchRecordTrack;
@property (weak, nonatomic) IBOutlet UISwitch *switchAutoSearch;
@property (weak, nonatomic) IBOutlet UISwitch *switchPreCacheImages;

@property (weak, nonatomic) IBOutlet UISwitch *switchGBIFTestAPI;
@property (weak, nonatomic) IBOutlet UISwitch *switchGBIFTestData;
@property (weak, nonatomic) IBOutlet UILabel *labelApproxCirclePoints;
@property (weak, nonatomic) IBOutlet UIStepper *stepperApproxCirclePoints;
- (IBAction)stepperApproxCirclePoints:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelMemCacheCap;
@property (weak, nonatomic) IBOutlet UILabel *labelMemCacheCurr;
@property (weak, nonatomic) IBOutlet UILabel *labelDiskCacheCap;
@property (weak, nonatomic) IBOutlet UILabel *labelDiskCacheCurr;
- (IBAction)buttonClearCaches:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelDatabaseOccurrences;
@property (weak, nonatomic) IBOutlet UILabel *labelDatabaseTaxa;
@property (weak, nonatomic) IBOutlet UILabel *labelDatabaseObservations;
@property (weak, nonatomic) IBOutlet UILabel *labelDatabaseTrips;
- (IBAction)buttonClearDatabase:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSave;

@property (weak, nonatomic) IBOutlet UIButton *buttonDebugTest;
- (IBAction)buttonActionDebugTest:(id)sender;

- (IBAction)buttonActionCancel:(id)sender;
- (IBAction)buttonActionSave:(id)sender;

@end

@implementation ExploreOptionsViewController
{
    BCOptions *_bcOptions;
    double _areaSpanValue;
    RecordType _recordTypeIndex;
    RecordSource _recordSourceIndex;
    SpeciesFilter _speciesFilterIndex;
    NSUInteger _displayPoints;
    DropDownViewController *activeDropDownView;
	DropDownViewController *dropDownView1;
	DropDownViewController *dropDownView2;
	DropDownViewController *dropDownView3;
    UIView *_viewBackgroundControls;
}


#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    
    _bcOptions = [BCOptions sharedInstance];
    [self configureDropDownLists];
    [self configureBackgroundControlsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initiateAreaSpan];
    [self saveCurrentSearchOptions];
    [self initiateDisplayPoints];
    [self initiateTextFields];
    [self initiateSwitches];
    [self updateLabels];
    [self updateCacheLabels];
    [self updateDatabaseLabels];
}


- (void)setupUI
{
    [self.navigationController.navigationBar setBackgroundColor:[UIColor kColorHeaderBackground]];
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
    self.tableView.separatorColor = [UIColor kColorTableCellSeparator];
    
    [self.labelsSettingTitle setValue:[UIColor lightTextColor] forKey:@"textColor"];
    [self.labelsSettingValue setValue:[UIColor lightTextColor] forKey:@"textColor"];

//    [self.sliders setValue:[UIColor darkGrayColor] forKey:@"tintColor"];
//    [self.sliders makeObjectsPerformSelector:@selector(setTintColor:) withObject:[UIColor kColorINatGreen]];

//    [self.switches setValue:[UIColor darkGrayColor] forKey:@"tintColor"];
//    [self.switches setValue:[UIColor lightGrayColor] forKey:@"onTintColor"];
//    [self.switches setValue:[UIColor kColorINatGreen] forKey:@"thumbTintColor"];
    
//    [self.buttons setValue:[UIColor kColorINatGreen] forKey:@"backgroundColor"];
//    [self.buttons setValue:[UIColor lightTextColor] forKey:@"textColor"];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //    view.tintColor = [UIColor clearColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    header.contentView.backgroundColor = [UIColor kColorTableHeaderBackgroundColor];
}

- (void)initiateAreaSpan
{
//    [multipleLabels makeObjectsPerformSelector:@selector(setTextColor:) withObject:[UIColor redColor]];
    
    _areaSpanValue = _bcOptions.searchOptions.searchAreaSpan;
    self.sliderAreaSpan.minimumValue = -5;
    self.sliderAreaSpan.maximumValue = 5;
    self.sliderAreaSpan.value = (int)log2((double)_areaSpanValue/kDefaultSearchAreaSpan);
}

- (void)saveCurrentSearchOptions
{
    _recordTypeIndex = _bcOptions.searchOptions.enumRecordType;
    _recordSourceIndex = _bcOptions.searchOptions.enumRecordSource;
    _speciesFilterIndex = _bcOptions.searchOptions.enumSpeciesFilter;
}

- (void)initiateDisplayPoints
{
    _displayPoints = _bcOptions.displayOptions.displayPoints;
    self.sliderDisplayPoints.minimumValue = 1;
    self.sliderDisplayPoints.maximumValue = kOptionsDefaultMaxDisplayPoints;
    self.sliderDisplayPoints.value = _displayPoints;
}

- (void)initiateTextFields
{
    if (_bcOptions.searchOptions.yearFrom.length > 0) {
        self.textFieldYearFrom.text = _bcOptions.searchOptions.yearFrom;
    }
    
    if (_bcOptions.searchOptions.yearTo.length > 0) {
        self.textFieldYearTo.text = _bcOptions.searchOptions.yearTo;
    }
}

- (void)initiateSwitches
{
    self.switchFullSpeciesNames.on = _bcOptions.displayOptions.fullSpeciesNames;
    self.switchUniqueSpecies.on = _bcOptions.displayOptions.uniqueSpecies;
    self.switchUniqueLocations.on = _bcOptions.displayOptions.uniqueLocations;
    
    self.segControlMapType.selectedSegmentIndex = _bcOptions.displayOptions.mapType;
    self.switchFollowUser.on = _bcOptions.displayOptions.followUser;
    self.switchRecordTrack.on = _bcOptions.displayOptions.trackLocation;
    self.switchAutoSearch.on = _bcOptions.displayOptions.autoSearch;
    self.switchPreCacheImages.on = _bcOptions.displayOptions.preCacheImages;
    self.switchGBIFTestAPI.on = _bcOptions.searchOptions.testGBIFAPI;
    self.switchGBIFTestData.on = _bcOptions.searchOptions.testGBIFData;
    
    self.stepperApproxCirclePoints.value = _bcOptions.searchOptions.approxCirclePoints;
}

- (void)configureDropDownLists
{
    dropDownView1 = [[DropDownViewController alloc] initWithArrayData:[OptionsRecordType allDisplayStrings] refFrame:[self.buttonRecordType.superview convertRect:self.buttonRecordType.frame toView:self.view] tableViewHeight:220 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView1.delegate = self;
	[self.view addSubview:dropDownView1.view];
    
    dropDownView2 = [[DropDownViewController alloc] initWithArrayData:[OptionsRecordSource allDisplayStrings] refFrame:[self.buttonRecordSource.superview convertRect:self.buttonRecordSource.frame toView:self.view] tableViewHeight:220 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView2.delegate = self;
	[self.view addSubview:dropDownView2.view];
    
    dropDownView3 = [[DropDownViewController alloc] initWithArrayData:[OptionsSpeciesFilter allDisplayStrings] refFrame:[self.buttonSpeciesFilter.superview convertRect:self.buttonSpeciesFilter.frame toView:self.view] tableViewHeight:220 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView3.delegate = self;
	[self.view addSubview:dropDownView3.view];
    
    activeDropDownView = nil;
}

- (void)configureBackgroundControlsView
{
//    _viewBackgroundControls = [[UIView alloc] initWithFrame:self.view.frame];
    _viewBackgroundControls = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    _viewBackgroundControls.backgroundColor = [UIColor blackColor];
    _viewBackgroundControls.alpha = 0.3f;
    _viewBackgroundControls.hidden = YES;
    [self.view insertSubview:_viewBackgroundControls belowSubview:dropDownView1.view];
    
    UIGestureRecognizer *uiControlViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBackgroundControlsClick:)];
    //    singleTapRecognizer.delaysTouchesBegan = YES;
    //    singleTapRecognizer.numberOfTapsRequired = 1;
    [_viewBackgroundControls addGestureRecognizer:uiControlViewTapRecognizer];
}


- (void)updateLabels
{
    [self updateLabelAreaSpan];

    self.labelRecordType.text = [OptionsRecordType displayStringForOption:_recordTypeIndex];
    self.labelRecordSource.text = [OptionsRecordSource displayStringForOption:_recordSourceIndex];
    self.labelSpeciesFilter.text = [OptionsSpeciesFilter displayStringForOption:_speciesFilterIndex];
    self.labelPoints.text = [NSString stringWithFormat:@"%d", (int) self.sliderDisplayPoints.value];
    
    self.labelApproxCirclePoints.text = [NSString stringWithFormat:@"%d", (int)self.stepperApproxCirclePoints.value];
}

- (void)updateLabelAreaSpan
{
    if (_areaSpanValue < 1000) {
        self.labelAreaSpan.text = [NSString stringWithFormat:@"%d m", (int) _areaSpanValue];
    } else {
        self.labelAreaSpan.text = [NSString stringWithFormat:@"%d km", (int) _areaSpanValue / 1000];
    }
}

- (void)updateCacheLabels
{
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    
    self.labelMemCacheCap.text = [NSByteCountFormatter stringFromByteCount:urlCache.memoryCapacity countStyle:NSByteCountFormatterCountStyleMemory];
    self.labelMemCacheCurr.text = [NSByteCountFormatter stringFromByteCount:urlCache.currentMemoryUsage countStyle:NSByteCountFormatterCountStyleMemory];
    self.labelDiskCacheCap.text = [NSByteCountFormatter stringFromByteCount:urlCache.diskCapacity countStyle:NSByteCountFormatterCountStyleFile];
    self.labelDiskCacheCurr.text = [NSByteCountFormatter stringFromByteCount:urlCache.currentDiskUsage countStyle:NSByteCountFormatterCountStyleFile];
}

- (void)updateDatabaseLabels
{
#ifdef TESTING
    self.buttonDebugTest.hidden = NO;
#endif
    
    self.labelDatabaseOccurrences.text = [NSString stringWithFormat:@"%d", (int)[BCDatabaseHelper rowCountForEntity:[OccurrenceRecord entityName]]];
    self.labelDatabaseTaxa.text = [NSString stringWithFormat:@"%d", (int)[BCDatabaseHelper rowCountForEntity:[INatTaxon entityName]]];
    self.labelDatabaseObservations.text = [NSString stringWithFormat:@"%d", (int)[BCDatabaseHelper rowCountForEntity:[INatObservation entityName]]];
    self.labelDatabaseTrips.text = [NSString stringWithFormat:@"%d", (int)[BCDatabaseHelper rowCountForEntity:[INatTrip entityName]]];
}

#pragma mark IBActions

- (IBAction)sliderAreaSpan:(id)sender {
    int sliderIntValue = (int)self.sliderAreaSpan.value;
    self.sliderAreaSpan.value = sliderIntValue;
    _areaSpanValue = kDefaultSearchAreaSpan * pow(2, sliderIntValue);
    [self updateLabelAreaSpan];
}

- (IBAction)sliderPoints:(id)sender {
    int output = (int)self.sliderDisplayPoints.value;
    self.sliderDisplayPoints.value = kDisplayPointsSliderInterval * floor(((output+(kDisplayPointsSliderInterval/2))/kDisplayPointsSliderInterval)+0.5);
    _displayPoints = self.sliderDisplayPoints.value;
    [self updateLabels];
}

- (IBAction)buttonRecordTypeTouch:(id)sender {
    [self displayDropDownView:dropDownView1];
}
- (IBAction)buttonRecordSourceTouch:(id)sender {
    [self displayDropDownView:dropDownView2];
}
- (IBAction)buttonSpeciesFilterTouch:(id)sender {
    [self displayDropDownView:dropDownView3];
}

- (void)displayDropDownView:(DropDownViewController *)dropDownView
{
    _viewBackgroundControls.hidden = NO;
    self.tableView.scrollEnabled = NO;
    activeDropDownView = dropDownView;
	[dropDownView openAnimation];
    [dropDownView.uiTableView flashScrollIndicators];
}

- (IBAction)stepperApproxCirclePoints:(id)sender {
    [self updateLabels];
}


- (IBAction)buttonClearCaches:(id)sender {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self updateCacheLabels];
}

- (IBAction)buttonClearDatabase:(id)sender {
    [BCAlerts displayOKorCancelAlert:@"Clear Database - Are You Sure?" message:@"Warning! - This will remove all stored records from your mobile device" okBlock:^{
        [BCDatabaseHelper clearDataStore];
        [TripsDataManager sharedInstance].currentTrip = nil;
        [self updateDatabaseLabels];
    } cancelBlock:^{
        return;
    }];
}

- (IBAction)buttonActionDebugTest:(id)sender {
    [NSException raise:NSInternalInconsistencyException format:@"Test Exception Thrown From %@", self.description];
}

- (IBAction)buttonActionCancel:(id)sender {
    
    [self viewBackgroundControlsClick:nil];
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    } else if (self.revealViewController) {
        [self.revealViewController revealToggleAnimated:YES];
        
//        [self.revealViewController performSegueWithIdentifier:@"ExploreVC" sender:nil];
//        [self.revealViewController setFrontViewController:_returnVC];
//        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

- (IBAction)buttonActionSave:(id)sender {
    _bcOptions.searchOptions.searchAreaSpan = _areaSpanValue;
    _bcOptions.searchOptions.enumRecordType = _recordTypeIndex;
    _bcOptions.searchOptions.enumRecordSource = _recordSourceIndex;
    _bcOptions.searchOptions.enumSpeciesFilter = _speciesFilterIndex;
    
    _bcOptions.displayOptions.displayPoints = _displayPoints;
    _bcOptions.displayOptions.fullSpeciesNames = self.switchFullSpeciesNames.on;
    _bcOptions.displayOptions.uniqueSpecies = self.switchUniqueSpecies.on;
    _bcOptions.displayOptions.uniqueLocations = self.switchUniqueLocations.on;
    
    _bcOptions.displayOptions.mapType = self.segControlMapType.selectedSegmentIndex;
    _bcOptions.displayOptions.followUser = self.switchFollowUser.on;
    _bcOptions.displayOptions.trackLocation = self.switchRecordTrack.on;
    _bcOptions.displayOptions.autoSearch = self.switchAutoSearch.on;
    _bcOptions.displayOptions.preCacheImages = self.switchPreCacheImages.on;
    _bcOptions.searchOptions.testGBIFAPI = self.switchGBIFTestAPI.on;
    _bcOptions.searchOptions.testGBIFData = self.switchGBIFTestData.on;
    
    _bcOptions.searchOptions.approxCirclePoints = self.stepperApproxCirclePoints.value;
    
    [self.delegate optionsUpdated:_bcOptions];
    
    if (_bcOptions.displayOptions.trackLocation) {
        
    } else {
        
    }
    [self buttonActionCancel:nil];
}


#pragma mark DropDownViewDelegate
-(void)dropDownCellSelected:(NSInteger)returnIndex{
    if (activeDropDownView == dropDownView1) {
        _recordTypeIndex = (RecordType)returnIndex;
    } else if (activeDropDownView == dropDownView2) {
        _recordSourceIndex = (RecordSource)returnIndex;
    } else if (activeDropDownView == dropDownView3) {
        _speciesFilterIndex = (SpeciesFilter)returnIndex;
    }
    [self updateLabels];
    _viewBackgroundControls.hidden = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)viewBackgroundControlsClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"viewBackgroundControlsClick");
    [activeDropDownView closeAnimation];
    _viewBackgroundControls.hidden = YES;
    self.tableView.scrollEnabled = YES;
}

/*
 -(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
 id hitView = [self.view hitTest:point withEvent:event];
 if (hitView == self) return nil;
 else return hitView;
 }
 */

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self saveTextFieldToTripOptions:textField];
    return NO;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (IBAction)textFieldFromEnd:(id)sender {
    [self textFieldShouldReturn:sender];
}

- (void)saveTextFieldToTripOptions:(UITextField *)textField {
    if (textField == self.textFieldYearFrom) {
        _bcOptions.searchOptions.yearFrom = textField.text;
    } else if (textField == self.textFieldYearTo) {
        _bcOptions.searchOptions.yearTo = textField.text;
    }
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
