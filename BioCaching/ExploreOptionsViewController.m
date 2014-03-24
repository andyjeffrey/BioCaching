    //
//  ExploreOptionsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 14/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreOptionsViewController.h"

#define kDefaultDisplayPoints 20
#define kTagLabelRecordType 1
#define kTagLabelRecordSource 2
#define kTagLabelRecord

@interface ExploreOptionsViewController () {
}

@property (weak, nonatomic) IBOutlet UIButton *buttonOK;
@property (weak, nonatomic) IBOutlet UISlider *sliderDisplayPoints;
@property (weak, nonatomic) IBOutlet UILabel *labelPoints;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYearFrom;
@property (weak, nonatomic) IBOutlet UITextField *textFieldYearTo;
@property (weak, nonatomic) IBOutlet UILabel *labelRecordType;
@property (weak, nonatomic) IBOutlet UILabel *labelRecordSource;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeciesFilter;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordType;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordSource;
@property (weak, nonatomic) IBOutlet UIButton *buttonSpeciesFilter;
@property (weak, nonatomic) IBOutlet UISwitch *switchFullSpeciesNames;
@property (weak, nonatomic) IBOutlet UISwitch *switchUniqueSpecies;
@property (weak, nonatomic) IBOutlet UISwitch *switchUniqueLocations;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation ExploreOptionsViewController {
    DropDownView *activeDropDownView;
	DropDownView *dropDownView1;
	DropDownView *dropDownView2;
	DropDownView *dropDownView3;
    NSArray *uiControls;
    UIGestureRecognizer *tapper;
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
    
//    self.pickerView.hidden = TRUE;
    [self initiateSlider];
    [self initiateTextFields];
    [self initiateDropDownLists];
    [self initiateSwitches];
    [self updateLabels];
    
    uiControls = [[NSArray alloc] initWithObjects:
                  self.sliderDisplayPoints,
                  self.textFieldYearFrom,
                  self.textFieldYearTo,
                  self.buttonRecordType,
                  self.buttonRecordSource,
                  self.buttonSpeciesFilter,
                  self.buttonOK,
                  nil];
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
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

- (void)initiateDropDownLists
{
    NSMutableArray *dropDownRecordType = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsRecordType.optionsArray ) {
        [dropDownRecordType addObject:optionArray[0]];
    }
	dropDownView1 = [[DropDownView alloc] initWithArrayData:dropDownRecordType cellHeight:30 heightTableView:200 paddingTop:0 paddingLeft:0 paddingRight:0 refView:self.buttonRecordType animation:GROW openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView1.delegate = self;
	[self.view addSubview:dropDownView1.view];
    
    NSMutableArray *dropDownRecordSource = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsRecordSource.optionsArray ) {
        [dropDownRecordSource addObject:optionArray[0]];
    }
	dropDownView2 = [[DropDownView alloc] initWithArrayData:dropDownRecordSource cellHeight:30 heightTableView:200 paddingTop:0 paddingLeft:0 paddingRight:0 refView:self.buttonRecordSource animation:GROW openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView2.delegate = self;
	[self.view addSubview:dropDownView2.view];
    
    NSMutableArray *dropDownSpeciesFilter = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in OptionsSpeciesFilter.optionsArray ) {
        [dropDownSpeciesFilter addObject:optionArray[0]];
    }
	dropDownView3 = [[DropDownView alloc] initWithArrayData:dropDownSpeciesFilter cellHeight:30 heightTableView:200 paddingTop:0 paddingLeft:0 paddingRight:0 refView:self.buttonRecordSource animation:GROW openAnimationDuration:0.2 closeAnimationDuration:0.2];
    dropDownView3.delegate = self;
	[self.view addSubview:dropDownView3.view];

    activeDropDownView = nil;
}

- (void)updateLabels
{
    self.labelPoints.text = [NSString stringWithFormat:@"%d", (int) self.sliderDisplayPoints.value];
    self.labelRecordType.text = [OptionsRecordType displayString:self.tripOptions.recordType];
    self.labelRecordSource.text = [OptionsRecordSource displayString:self.tripOptions.recordSource];
    self.labelSpeciesFilter.text = [OptionsSpeciesFilter displayString:self.tripOptions.speciesFilter];
}

- (void)activateUIControls:(BOOL)enable
{
    for (UIControl *uiControl in uiControls) {
        uiControl.userInteractionEnabled = enable;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderPoints:(id)sender {
    int output = (int)self.sliderDisplayPoints.value;
    self.sliderDisplayPoints.value = 10 * floor(((output+5)/10)+0.5);
    self.tripOptions.displayPoints = self.sliderDisplayPoints.value;
    [self updateLabels];
}

- (IBAction)buttonOK:(id)sender {
//    [self.delegate saveOptions:self.tripOptions];
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    NSLog(@"buttonOK:\n%@,%@\n%@,%@",
          self.textFieldYearFrom.text, self.tripOptions.yearFrom,
          self.textFieldYearTo.text, self.tripOptions.yearTo);
}

- (IBAction)buttonRecordTypeTouch:(id)sender {
    [self activateUIControls:FALSE];
    activeDropDownView = dropDownView1;
	[dropDownView1 openAnimation];
}
- (IBAction)buttonRecordSourceTouch:(id)sender {
    [self activateUIControls:FALSE];
    activeDropDownView = dropDownView2;
	[dropDownView2 openAnimation];
 }
- (IBAction)buttonSpeciesFilterTouch:(id)sender {
    [self activateUIControls:FALSE];
    activeDropDownView = dropDownView3;
	[dropDownView3 openAnimation];
 }

/*
- (IBAction)recordTypeButton:(id)sender {
    self.buttonOK.hidden = TRUE;
    self.pickerView.hidden = FALSE;
    [self.pickerView selectRow:self.tripOptions.recordType inComponent:0 animated:TRUE];
}
*/

-(void)dropDownCellSelected:(NSInteger)returnIndex{
    if (activeDropDownView == dropDownView1) {
        self.tripOptions.recordType = returnIndex;
    } else if (activeDropDownView == dropDownView2) {
        self.tripOptions.recordSource = returnIndex;
    } else if (activeDropDownView == dropDownView3) {
        self.tripOptions.speciesFilter = returnIndex;
    }
    [self updateLabels];
    [self activateUIControls:TRUE];
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

/*
#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return RecordTypeCount;
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [OptionsRecordType displayString:(RecordType)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.tripOptions.recordType = (RecordType)row;
    self.buttonOK.hidden = FALSE;
    self.pickerView.hidden = TRUE;
    [self updateLabels];
}
*/

@end
