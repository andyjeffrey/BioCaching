//
//  ExplorerListViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 05/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreListViewController.h"

@interface ExploreListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelAreaSpan;
@property (weak, nonatomic) IBOutlet UILabel *labelOccurrenceCount;

@end

@implementation ExploreListViewController

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
    
    self.labelLocation.text = [NSString stringWithFormat:@"Location: %f,%f",
                               self.searchAreaCenter.latitude, self.searchAreaCenter.longitude];
    self.labelAreaSpan.text = [NSString stringWithFormat:@"Area Span: %dm",
                               self.searchAreaSpan];
    self.labelOccurrenceCount.text = [NSString stringWithFormat:@"Total Record Count: %d",
                                      self.occurenceResults.Count.intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)returnToMap:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _occurenceResults.Results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    GBIFOccurrence *occurrence = self.occurenceResults.Results[indexPath.row];

    cell.textLabel.text = occurrence.MainTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%03lu  %@", (long)indexPath.row, occurrence.SubTitle];
    
    return cell;
}

@end
