//
//  TutorialContentViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TutorialContentViewController.h"

@interface TutorialContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelHeading;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;

@end

@implementation TutorialContentViewController {
    
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

    self.labelHeading.text = self.pageTitleText;
    self.imageBackground.image = [UIImage imageNamed:self.pageImageFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
