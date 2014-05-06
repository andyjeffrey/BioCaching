//
//  MainViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "ExploreContainerViewController.h"

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _bcOptions = [[BCOptions alloc] initWithDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TSMessage setDefaultViewController:self];
    
    //Setup Sidebar

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    [_sidebarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    _sidebarButton.target = self.revealViewController;
//    _sidebarButton.action = @selector(revealToggle:);
    
//    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    NSLog(@"%@:%@ segue=%@", self.class, NSStringFromSelector(_cmd), segue.identifier);
    //    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);
    
    if ([segue.identifier isEqualToString:@"embedExplore"]) {
        ExploreContainerViewController *exploreVC = segue.destinationViewController;
        exploreVC.bcOptions = _bcOptions;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
