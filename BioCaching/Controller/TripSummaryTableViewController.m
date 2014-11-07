//
//  TripSummaryTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 12/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripSummaryTableViewController.h"

static NSString *const kTripDescPlaceholderText = @"[Enter Description/Notes for Trip]";

@interface TripSummaryTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldTripTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageTitleEdit;

@property (weak, nonatomic) IBOutlet UITextField *textFieldTimespan;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLocation;

@property (weak, nonatomic) IBOutlet UITextView *textViewTripDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imageDescEdit;

@property (weak, nonatomic) IBOutlet UILabel *labelTripSpeciesTotal;
@property (weak, nonatomic) IBOutlet UILabel *labelTripSpeciesFound;
@property (weak, nonatomic) IBOutlet UILabel *labelTripSpeciesToFind;

@end

@implementation TripSummaryTableViewController {
    BOOL _keyboardShown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    [self setupKeyboardNotifications];
    _keyboardShown = NO;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupLabels];
}
 
- (void)setupKeyboardNotifications
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorBackground];
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
    
    self.textFieldTripTitle.backgroundColor = [UIColor kColorTextViewBackgroundColor];
    self.textFieldTripTitle.textColor = [UIColor kColorHeaderText];
    self.textFieldTripTitle.frame = CGRectMake(self.textFieldTripTitle.frame.origin.x, self.textFieldTripTitle.frame.origin.y, self.textFieldTripTitle.frame.size.width, 24);
    
    self.textFieldTimespan.backgroundColor = [UIColor kColorTextViewBackgroundColor];
    self.textFieldTimespan.textColor = [UIColor kColorHeaderText];
    self.textFieldTimespan.frame = CGRectMake(self.textFieldTimespan.frame.origin.x, self.textFieldTimespan.frame.origin.y, self.textFieldTimespan.frame.size.width, 24);
    
    self.textFieldLocation.backgroundColor = [UIColor kColorTextViewBackgroundColor];
    self.textFieldLocation.textColor = [UIColor kColorHeaderText];
    self.textFieldLocation.frame = CGRectMake(self.textFieldLocation.frame.origin.x, self.textFieldLocation.frame.origin.y, self.textFieldLocation.frame.size.width, 24);

    self.textViewTripDesc.backgroundColor = [UIColor kColorTextViewBackgroundColor];
    self.textViewTripDesc.textColor = [UIColor kColorLabelText];
    self.textViewTripDesc.clipsToBounds = YES;
    self.textViewTripDesc.layer.cornerRadius = 5.0;

    self.imageTitleEdit.image = [IonIcons imageWithIcon:icon_edit iconColor:[UIColor kColorButtonLabel] iconSize:16 imageSize:CGSizeMake(20,20)];
//    self.imageTitleEdit.image = [IonIcons imageWithIcon:icon_edit size:12 color:[UIColor kColorButtonLabel]];
    self.imageTitleEdit.backgroundColor = [UIColor kColorTextViewBackgroundColor];
    self.imageDescEdit.image = [IonIcons imageWithIcon:icon_edit iconColor:[UIColor kColorButtonLabel] iconSize:16 imageSize:CGSizeMake(20,20)];
//    self.imageDescEdit.image = [IonIcons imageWithIcon:icon_edit size:18 color:[UIColor kColorButtonLabel]];
    self.imageDescEdit.backgroundColor = [UIColor kColorTextViewBackgroundColor];
    
    self.textFieldTripTitle.delegate = self;
    self.textViewTripDesc.delegate = self;
}

- (void)setupLabels
{
    self.textFieldTripTitle.text = _currentTrip.title;
    self.textFieldTimespan.text = _currentTrip.timespanText;
    self.textFieldLocation.text = [CLLocation latLongStringFromCoordinate:_currentTrip.locationCoordinate];
    self.labelTripSpeciesTotal.text = [NSString stringWithFormat:@"%d", (int)_currentTrip.tripAttributesTotal];
    self.labelTripSpeciesFound.text = [NSString stringWithFormat:@"%d", (int)_currentTrip.tripAttributesFound];
    self.labelTripSpeciesToFind.text = [NSString stringWithFormat:@"%d", (int)_currentTrip.tripAttributesToFind];
    
    [self updateDescriptionTextView];
    
    if (self.currentTrip.statusValue == TripStatusPublished)
    {
        [self.textFieldTripTitle setEnabled:NO];
        self.imageTitleEdit.hidden = YES;
        [self.textViewTripDesc setEditable:NO];
        self.imageDescEdit.hidden = YES;
        if (!self.currentTrip.body) {
            self.textViewTripDesc.text = @"";
        }
    } else {
        [self.textFieldTripTitle setEnabled:YES];
        self.imageTitleEdit.hidden = NO;
        [self.textViewTripDesc setEditable:YES];
        self.imageDescEdit.hidden = NO;
    }
}

- (void)updateDescriptionTextView
{
    if (!_currentTrip.body) {
        self.textViewTripDesc.text = kTripDescPlaceholderText;
        self.textViewTripDesc.textColor = [UIColor lightTextColor];
        self.textViewTripDesc.font = [UIFont italicSystemFontOfSize:self.textViewTripDesc.font.pointSize];
    } else {
        self.textViewTripDesc.text = _currentTrip.body;
        self.textViewTripDesc.textColor = [UIColor whiteColor];
        self.textViewTripDesc.font = [UIFont systemFontOfSize:self.textViewTripDesc.font.pointSize];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor kColorHeaderText]];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    header.contentView.backgroundColor = [UIColor kColorTableBackgroundColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.imageTitleEdit.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [BCAlerts displayOKAlertWithCallback:@"Trip Title Error!" message:@"Cannot be empty\nPlease enter a trip title" mainButtonTitle:@"OK" okBlock:^{
            [self.textFieldTripTitle becomeFirstResponder];
        }];
    } else {
        _currentTrip.title = textField.text;
    }
    self.imageTitleEdit.hidden = NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.imageDescEdit.hidden = YES;
    if (!_currentTrip.body) {
        _currentTrip.body = @"";
    }
    [self updateDescriptionTextView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.imageDescEdit.hidden = NO;
    if (textView.text.length == 0) {
        _currentTrip.body = nil;
    } else {
        _currentTrip.body = textView.text;
    }
    [self updateDescriptionTextView];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
