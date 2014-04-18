//
//  TripsViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 19/02/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TripsViewController.h"
#import "INatTrip.h"
#

@interface TripsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableTrips;

@end

@implementation TripsViewController {
    NSMutableArray *_trips;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRestKit];
    [self loadTrips];
}

- (void)configureRestKit
{
//    NSURL *baseURL = [NSURL URLWithString:kINatBaseURL];
    
}

- (void)loadTrips
{
    _trips = [[NSMutableArray alloc] initWithObjects:[[INatTrip alloc] init], nil];
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _trips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell2" forIndexPath:indexPath];
    
    INatTrip *trip = _trips[indexPath.row];
    
    cell.textLabel.text = trip.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", trip.created_at];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    INatTrip *trip = _trips[indexPath.row];
    
    NSLog(@"Row Selected: %lu - %@", indexPath.row, trip.id);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
