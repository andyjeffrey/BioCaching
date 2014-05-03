//
//  ExploreContainerViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreContainerViewController.h"
#import "ExploreMapViewController.h"
#import "ExploreListViewController.h"
#import "ExploreSummaryViewController.h"

@interface ExploreContainerViewController ()

@end

@implementation ExploreContainerViewController

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
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    NSLog(@"%@:%@ segue=%@", self.class, NSStringFromSelector(_cmd), segue.identifier);
    //    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);
    
    if ([segue.identifier isEqualToString:@"embedExploreMap"]) {
        ExploreMapViewController *exploreMapVC = segue.destinationViewController;
        exploreMapVC.bcOptions = _bcOptions;
    }
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
