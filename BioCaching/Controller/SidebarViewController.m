    //
//  SidebarViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "ExploreOptionsViewController.h"

@interface SidebarViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageIconExplore;
@property (weak, nonatomic) IBOutlet UIImageView *imageIconTrips;
@property (weak, nonatomic) IBOutlet UIImageView *imageIconProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imageIconAbout;
@property (weak, nonatomic) IBOutlet UIImageView *imageIconSettings;

@end

@implementation SidebarViewController {
    UIViewController *_previousVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.viewControllersCache = [NSMutableDictionary dictionary];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setColors];
    [self setupIcons];

}

- (void)viewDidAppear:(BOOL)animated
{
    // Auto return to previous screen
    if (_previousVC) {
        [self.revealViewController setFrontViewController:_previousVC];
        [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        _previousVC = nil;
    }
}

- (void)setColors
{
    self.tableView.backgroundColor = [UIColor kColorTableBackgroundColor];
    self.tableView.separatorColor = [UIColor kColorTableCellSeparator];
}

- (void)setupIcons
{
    self.imageIconExplore.image = [IonIcons imageWithIcon:icon_search
                                              iconColor:[UIColor kColorLabelText]
                                               iconSize:30.0f
                                              imageSize:CGSizeMake(40.0f, 40.0f)];
    self.imageIconTrips.image = [IonIcons imageWithIcon:icon_clipboard
                                              iconColor:[UIColor kColorLabelText]
                                               iconSize:30.0f
                                              imageSize:CGSizeMake(40.0f, 40.0f)];
    self.imageIconProfile.image = [IonIcons imageWithIcon:icon_person
                                                iconColor:[UIColor kColorLabelText]
                                                 iconSize:30.0f
                                                imageSize:CGSizeMake(40.0f, 40.0f)];
    self.imageIconAbout.image = [IonIcons imageWithIcon:icon_information
                                              iconColor:[UIColor kColorLabelText]
                                               iconSize:30.0f
                                              imageSize:CGSizeMake(40.0f, 40.0f)];
    self.imageIconSettings.image = [IonIcons imageWithIcon:icon_gear_b
                                                 iconColor:[UIColor kColorLabelText]
                                                  iconSize:30.0f
                                                 imageSize:CGSizeMake(40.0f, 40.0f)];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
    [header.textLabel setTextColor:[UIColor kColorLabelText]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);
    
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
        
        //Set PreviousVC To Automatically Return To When Sidebar Next Displayed
        if ([swSegue.identifier isEqualToString:@"OptionsVC"]) {
            _previousVC = self.revealViewController.frontViewController;
        }
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
            if (rvc_segue.identifier) {
                UIViewController *cachedVC = [self.viewControllersCache objectForKey:rvc_segue.identifier];
                if (cachedVC != nil) {
                    dvc = cachedVC;
                } else {
                    [self.viewControllersCache setObject:dvc forKey:rvc_segue.identifier];
                }
            }
            //            UINavigationController *navVC = (UINavigationController *)self.revealViewController.frontViewController;
            //            [navVC setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewController:dvc];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}

//        if ([segue.identifier isEqualToString:@"segueOptions"]) {
//            UINavigationController *navVC = (UINavigationController *)segue.destinationViewController;
//            ExploreOptionsViewController *optionsVC = [navVC viewControllers][0];
//            optionsVC.bcOptions = mainVC.bcOptions;
//            optionsVC.delegate = [mainVC childViewControllers][0];
//            
//            swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
//                [navVC pushViewController:dvc animated:NO];
//                
//                
////                UINavigationController *navVC = (UINavigationController *)self.revealViewController.frontViewController;
////                [navVC setViewControllers:@[dvc] animated:NO];
//                [self.revealViewController setFrontViewController:dvc];
//                [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//            };
//        } else {
//        swSegue.performBlock = ^(SWRevealViewControllerSegue *rvc_segue, UIViewController *svc, UIViewController *dvc) {
//            if (rvc_segue.identifier) {
//                UIViewController *cachedVC = [mainVC.viewControllersCache objectForKey:rvc_segue.identifier];
//                if (cachedVC != nil) {
//                    dvc = cachedVC;
//                }
//            }

/*
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Make sure we are using the SWRevealViewControllerSegue
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            // The name of our view controller we want to navigate to
            NSString *vcName = @"";
            
            // Set the name of the Storyboard ID we want to switch to
            if ([segue.identifier isEqualToString:@"showNavTest"])
            {
                vcName = @"navTest";
            }
            
            else if ([segue.identifier isEqualToString:@"showNavOtherTab"])
            {
                vcName = @"navOtherTab";
            }
            
            // If we selected a menu item
            if (vcName.length > 0)
            {
                // Get the view controller
                UIViewController *vcNew = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:NULL] instantiateViewControllerWithIdentifier:vcName];
                
                // Swap out the Front view controller and display
                [self.revealViewController setFrontViewController:vcNew];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            }
            
            else
            {
                // Could not navigate to view - add logging
            }
        };
    }
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
