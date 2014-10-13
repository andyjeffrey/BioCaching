//
//  AboutTableViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "AboutTableViewController.h"
#import "TutorialViewController.h"

static NSString *const kSupportEmailBody = @"\n\n\n----\nPlease enter message in space above leaving device information below to help support \nApp Version: v%@ Build %@\nDevice: %@\niOS Version: %@\niNat User Id: %@\n";

@interface AboutTableViewController ()

- (IBAction)buttonTutorial:(id)sender;
- (IBAction)buttonContactSupport:(id)sender;

@end

@implementation AboutTableViewController

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
    
    [self presentViewController:tutorialVC animated:YES completion:nil];
}

- (IBAction)buttonContactSupport:(id)sender
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    [mailController setToRecipients:@[kSupportEmailAddress]];
    [mailController setSubject:kSupportEmailSubject];
    NSString *emailBody = [NSString stringWithFormat:kSupportEmailBody,
                           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                           [BCLoggingHelper machineName],
//                           [UIDevice currentDevice].systemName,
                           [UIDevice currentDevice].systemVersion,
                           [LoginManager sharedInstance].currentUserID];
    [mailController setMessageBody:emailBody isHTML:NO];
    
    mailController.mailComposeDelegate = self;
    
    if ( mailController != nil ) {
        if ([MFMailComposeViewController canSendMail]){
            [self presentViewController:mailController animated:YES completion:nil];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
