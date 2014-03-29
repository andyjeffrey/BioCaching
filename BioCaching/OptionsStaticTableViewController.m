//
//  ExploreOptionsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsStaticTableViewController.h"

#define kDefaultDisplayPoints 20
#define kTagLabelRecordType 1
#define kTagLabelRecordSource 2
#define kTagLabelRecord

@interface OptionsStaticTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldYearFrom;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYearTo;
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
    
    [self initiateSlider];
    [self initiateTextFields];
    [self initiateSwitches];
    [self updateLabels];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureDropDownLists];
    [self configureBackgroundControlsView];
}

- (void)initiateSlider
{
    self.sliderDisplayPoints.minimumValue = 1;
    self.sliderDisplayPoints.maximumValue = 300;
    self.sliderDisplayPoints.value = self.tripOptions.displayPoints;
}

- (void)initiateTextFields
{
    if (self.tripOptions.yearFrom.length > 0) {
        self.textFieldYearFrom.text = self.tripOptions.yearFrom;
    }
    
    if (self.tripOptions.yearTo.length > 0) {
        self.textFieldYearTo.text = self.tripOptions.yearTo;
    }
}

- (void)initiateSwitches
{
    self.switchFullSpeciesNames.on = self.tripOptions.fullSpeciesNames;
    self.switchUniqueSpecies.on = self.tripOptions.uniqueSpecies;
    self.switchUniqueLocations.on = self.tripOptions.uniqueLocations;
}

- (void)configureDropDownLists
{
    NSMutableArray *dropDownRecordType = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsRecordType.optionsArray ) {
        [dropDownRecordType addObject:optionArray[0]];
    }
    dropDownView1 = [[DropDownViewController alloc] initWithArrayData:dropDownRecordType refFrame:[self.view convertRect:self.buttonRecordType.frame fromView:self.buttonRecordType.superview] tableViewHeight:180 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:30 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView1.delegate = self;
	[self.view addSubview:dropDownView1.view];
    
    NSMutableArray *dropDownRecordSource = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsRecordSource.optionsArray ) {
        [dropDownRecordSource addObject:optionArray[0]];
    }
    dropDownView2 = [[DropDownViewController alloc] initWithArrayData:dropDownRecordSource refFrame:[self.view convertRect:self.buttonRecordSource.frame fromView:self.buttonRecordSource.superview] tableViewHeight:180 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:30 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView2.delegate = self;
	[self.view addSubview:dropDownView2.view];
    
    NSMutableArray *dropDownSpeciesFilter = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsSpeciesFilter.optionsArray ) {
        [dropDownSpeciesFilter addObject:optionArray[0]];
    }
    dropDownView3 = [[DropDownViewController alloc] initWithArrayData:dropDownSpeciesFilter refFrame:[self.view convertRect:self.buttonSpeciesFilter.frame fromView:self.buttonSpeciesFilter.superview] tableViewHeight:180 paddingTop:0 paddingLeft:0 paddingRight:0 tableCellHeight:30 animationStyle:BCViewAnimationStyleGrow openAnimationDuration:0.2 closeAnimationDuration:0.2];
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
    self.labelPoints.text = [NSString stringWithFormat:@"%d", (int) self.sliderDisplayPoints.value];
    self.labelRecordType.text = [OptionsRecordType displayString:self.tripOptions.recordType];
    self.labelRecordSource.text = [OptionsRecordSource displayString:self.tripOptions.recordSource];
    self.labelSpeciesFilter.text = [OptionsSpeciesFilter displayString:self.tripOptions.speciesFilter];
}

/*
- (void)activateUIControls:(BOOL)enable
{
    for (UIControl *uiControl in uiControls) {
        uiControl.userInteractionEnabled = enable;
    }
}
*/

- (IBAction)sliderPoints:(id)sender {
    int output = (int)self.sliderDisplayPoints.value;
    self.sliderDisplayPoints.value = 10 * floor(((output+5)/10)+0.5);
    self.tripOptions.displayPoints = self.sliderDisplayPoints.value;
    [self updateLabels];
}

- (IBAction)buttonDonePressed:(id)sender {
    [self.delegate saveOptions:self.tripOptions];
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    NSLog(@"buttonOK:\n%@,%@\n%@,%@",
          self.textFieldYearFrom.text, self.tripOptions.yearFrom,
          self.textFieldYearTo.text, self.tripOptions.yearTo);
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

#pragma mark DropDownViewDelegate
-(void)dropDownCellSelected:(NSInteger)returnIndex{
    if (activeDropDownView == dropDownView1) {
        self.tripOptions.recordType = returnIndex;
    } else if (activeDropDownView == dropDownView2) {
        self.tripOptions.recordSource = returnIndex;
    } else if (activeDropDownView == dropDownView3) {
        self.tripOptions.speciesFilter = returnIndex;
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
        self.tripOptions.yearFrom = textField.text;
    } else if (textField == self.textFieldYearTo) {
        self.tripOptions.yearTo = textField.text;
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
