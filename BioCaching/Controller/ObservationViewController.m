//
//  ObservationViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 17/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ObservationViewController.h"

@interface ObservationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageTaxonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubtitle;

@property (weak, nonatomic) IBOutlet UIButton *buttonDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;


@property (weak, nonatomic) IBOutlet UIImageView *imageObservation;
@property (weak, nonatomic) IBOutlet UIButton *buttonObservation;

@end

@implementation ObservationViewController {
    NSDate *obsDate;
    CLLocation *obsLocation;
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
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationItem.title = @"Record Observation";
    
    self.view.backgroundColor = [UIColor kColorTableBackgroundColor];
    
    [self setupButtons];
    [self setupLabels];
    
    self.imageObservation.backgroundColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupButtons
{
    [self.buttonDate setBackgroundImage:
     [IonIcons imageWithIcon:icon_calendar iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonDate.backgroundColor = [UIColor kColorButtonBackground];
    
    [self.buttonLocation setBackgroundImage:
     [IonIcons imageWithIcon:icon_location iconColor:[UIColor whiteColor] iconSize:30.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    self.buttonLocation.backgroundColor = [UIColor kColorButtonBackground];
}

- (void)setupLabels
{
    self.imageTaxonIcon.image = [UIImage imageNamed:[self.occurrence getINatIconicTaxaMainImageFile]];
    self.labelTaxonTitle.text = self.occurrence.title;
    self.labelTaxonSubtitle.text = self.occurrence.subtitle;
    self.labelDate.text = [[NSDate date] localDateTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
