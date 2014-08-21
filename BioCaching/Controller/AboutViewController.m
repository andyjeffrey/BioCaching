//
//  AboutViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 02/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UILabel *labelBuild;

@end

@implementation AboutViewController

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
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor kColorHeaderBackground];
    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    [self setupSidebar];
    [self setupButtons];
    [self setupLabels];
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
}

- (void)setupLabels
{
    [self.labelVersion setTextWithDefaults:[NSString stringWithFormat:@"Ver %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [self.labelBuild setTextWithDefaults:[NSString stringWithFormat:@"Build %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
}

#pragma-mark IBActions
- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

@end
