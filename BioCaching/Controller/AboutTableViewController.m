//
//  AboutTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "AboutTableViewController.h"
#import "TutorialViewController.h"

@interface AboutTableViewController ()

- (IBAction)buttonTutorial:(id)sender;

@end

@implementation AboutTableViewController

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
//    view.tintColor = [UIColor clearColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    header.contentView.backgroundColor = [UIColor kColorTableBackgroundColor];
}

- (IBAction)buttonTutorial:(id)sender
{
    TutorialViewController *tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    
//    [self.navigationController pushViewController:tutorialVC animated:YES];
    [self presentViewController:tutorialVC animated:YES completion:nil];

/*
    UINavigationController *modalNavController = [[UINavigationController alloc]
                                                  initWithRootViewController:vc];
    [self presentViewController:modalNavController animated:YES completion:nil];
*/
}

@end
