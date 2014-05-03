//
//  ProfileViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 26/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ProfileViewController.h"

#import "SWRevealViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSidebar;

@end

@implementation ProfileViewController

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
    
    [self setupSidebar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSidebar
{
    [self.buttonSidebar setTitle:nil forState:UIControlStateNormal];
    [self.buttonSidebar setBackgroundImage:
     [IonIcons imageWithIcon:icon_navicon iconColor:[UIColor darkGrayColor] iconSize:40.0f imageSize:CGSizeMake(40.0f, 40.0f)] forState:UIControlStateNormal];
    
    // Change button color
    self.buttonSidebar.tintColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
}

- (IBAction)buttonSidebar:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}


@end
