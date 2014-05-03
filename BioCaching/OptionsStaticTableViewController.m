//
//  ExploreOptionsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsStaticTableViewController.h"

@interface OptionsStaticTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldYearFrom;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYearTo;

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

@property (weak, nonatomic) IBOutlet UISwitch *switchGBIFTestData;


@property (weak, nonatomic) IBOutlet UILabel *labelMemCacheCap;
@property (weak, nonatomic) IBOutlet UILabel *labelMemCacheCurr;
@property (weak, nonatomic) IBOutlet UILabel *labelDiskCacheCap;
@property (weak, nonatomic) IBOutlet UILabel *labelDiskCacheCurr;


@end

@implementation OptionsStaticTableViewController
{
    DropDownViewController *activeDropDownView;
	DropDownViewController *dropDownView1;
	DropDownViewController *dropDownView2;
	DropDownViewController *dropDownView3;
    UIView *_viewBackgroundControls;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initiateAreaSpan];
    [self initiateDisplayPoints];
    [self initiateTextFields];
    [self initiateSwitches];
    [self updateLabels];
    [self updateCacheLabels];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureDropDownLists];
    [self configureBackgroundControlsView];
}

- (void)initiateDisplayPoints
{
    self.sliderDisplayPoints.minimumValue = 1;
    self.sliderDisplayPoints.maximumValue = 300;
    self.sliderDisplayPoints.value = self.bcOptions.displayOptions.displayPoints;
}

- (void) initiateAreaSpan
{
    self.sliderAreaSpan.minimumValue = -5;
    self.sliderAreaSpan.maximumValue = 5;
    self.sliderAreaSpan.value = (int)log2((double)self.bcOptions.searchOptions.searchAreaSpan/kDefaultSearchAreaSpan);
}

- (void)initiateTextFields
{
    if (self.bcOptions.searchOptions.yearFrom.length > 0) {
        self.textFieldYearFrom.text = self.bcOptions.searchOptions.yearFrom;
    }
    
    if (self.bcOptions.searchOptions.yearTo.length > 0) {
        self.textFieldYearTo.text = self.bcOptions.searchOptions.yearTo;
    }
}

- (void)initiateSwitches
{
    self.switchFullSpeciesNames.on = self.bcOptions.displayOptions.fullSpeciesNames;
    self.switchUniqueSpecies.on = self.bcOptions.displayOptions.uniqueSpecies;
    self.switchUniqueLocations.on = self.bcOptions.displayOptions.uniqueLocations;
    
    self.segControlMapType.selectedSegmentIndex = self.bcOptions.displayOptions.mapType;
    
    self.switchGBIFTestData.on = self.bcOptions.searchOptions.testGBIFData;
}

- (void)configureDropDownLists
{
    NSMutableArray *dropDownRecordType = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsRecordType.optionsArray ) {
        [dropDownRecordType addObject:optionArray[0]];
    }
    dropDownView1 = [[DropDownViewController alloc] initWithArrayData:dropDownRecordType refFrame:[self.view convertRect:self.buttonRecordType.frame fromView:self.buttonRecordType.superview] tableViewHeight:220 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView1.delegate = self;
	[self.view addSubview:dropDownView1.view];
    
    NSMutableArray *dropDownRecordSource = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsRecordSource.optionsArray ) {
        [dropDownRecordSource addObject:optionArray[0]];
    }
    dropDownView2 = [[DropDownViewController alloc] initWithArrayData:dropDownRecordSource refFrame:[self.view convertRect:self.buttonRecordSource.frame fromView:self.buttonRecordSource.superview] tableViewHeight:220 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView2.delegate = self;
	[self.view addSubview:dropDownView2.view];
    
    NSMutableArray *dropDownSpeciesFilter = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsSpeciesFilter.optionsArray ) {
        [dropDownSpeciesFilter addObject:optionArray[0]];
    }
    dropDownView3 = [[DropDownViewController alloc] initWithArrayData:dropDownSpeciesFilter refFrame:[self.view convertRect:self.buttonSpeciesFilter.frame fromView:self.buttonSpeciesFilter.superview] tableViewHeight:220 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:40 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
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

    self.labelRecordType.text = [OptionsRecordType displayString:self.bcOptions.searchOptions.recordType];
    self.labelRecordSource.text = [OptionsRecordSource displayString:self.bcOptions.searchOptions.recordSource];
    self.labelSpeciesFilter.text = [OptionsSpeciesFilter displayString:self.bcOptions.searchOptions.speciesFilter];

    self.labelPoints.text = [NSString stringWithFormat:@"%d", (int) self.sliderDisplayPoints.value];
}

- (void)updateLabelAreaSpan
{
    if (self.bcOptions.searchOptions.searchAreaSpan < kDefaultSearchAreaSpan) {
        self.labelAreaSpan.text = [NSString stringWithFormat:@"%d m", (int) self.bcOptions.searchOptions.searchAreaSpan];
    } else {
        self.labelAreaSpan.text = [NSString stringWithFormat:@"%d km", (int) self.bcOptions.searchOptions.searchAreaSpan / 1000];
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


/*
- (void)updateSearchAreaStepper:(int)searchAreaSpan
{
    self.stepperSearchArea.value = log2(searchAreaSpan/kDefaultSearchAreaStepperValue);
    [self updateSearchAreaLabel:self.stepperSearchArea.value];
}

*/

#pragma mark IBActions

- (IBAction)sliderAreaSpan:(id)sender {
    int sliderIntValue = (int)self.sliderAreaSpan.value;
    self.sliderAreaSpan.value = sliderIntValue;
    self.bcOptions.searchOptions.searchAreaSpan = kDefaultSearchAreaSpan * pow(2, sliderIntValue);
    [self updateLabelAreaSpan];
}

- (IBAction)sliderPoints:(id)sender {
    int output = (int)self.sliderDisplayPoints.value;
    self.sliderDisplayPoints.value = 10 * floor(((output+5)/10)+0.5);
    self.bcOptions.displayOptions.displayPoints = self.sliderDisplayPoints.value;
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
    activeDropDownView = dropDownView;
	[dropDownView openAnimation];
    [dropDownView.uiTableView flashScrollIndicators];
}

- (IBAction)buttonClearCaches:(id)sender {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self updateCacheLabels];
}

- (IBAction)buttonDonePressed:(id)sender {
    self.bcOptions.displayOptions.fullSpeciesNames = self.switchFullSpeciesNames.on;
    self.bcOptions.displayOptions.uniqueSpecies = self.switchUniqueSpecies.on;
    self.bcOptions.displayOptions.uniqueLocations = self.switchUniqueLocations.on;
    
    self.bcOptions.displayOptions.mapType = self.segControlMapType.selectedSegmentIndex;
    
    self.bcOptions.searchOptions.testGBIFData = self.switchGBIFTestData.on;
    
    [self.delegate optionsUpdated:self.bcOptions];
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    //    NSLog(@"buttonOK:\n%@,%@\n%@,%@", self.textFieldYearFrom.text, self.tripOptions.yearFrom, self.textFieldYearTo.text, self.tripOptions.yearTo);
}


#pragma mark DropDownViewDelegate
-(void)dropDownCellSelected:(NSInteger)returnIndex{
    if (activeDropDownView == dropDownView1) {
        self.bcOptions.searchOptions.recordType = returnIndex;
    } else if (activeDropDownView == dropDownView2) {
        self.bcOptions.searchOptions.recordSource = returnIndex;
    } else if (activeDropDownView == dropDownView3) {
        self.bcOptions.searchOptions.speciesFilter = returnIndex;
    }
    [self updateLabels];
    _viewBackgroundControls.hidden = YES;
}

- (void)viewBackgroundControlsClick:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"viewBackgroundControlsClick");
    [activeDropDownView closeAnimation];
    _viewBackgroundControls.hidden = YES;
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
        self.bcOptions.searchOptions.yearFrom = textField.text;
    } else if (textField == self.textFieldYearTo) {
        self.bcOptions.searchOptions.yearTo = textField.text;
    }
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
