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

static int const defaultEmbeddedView = 0;

@interface ExploreContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewExploreContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControlView;

@property (nonatomic, strong) NSArray *embeddedVCs;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ExploreContainerViewController {
    NSString *_currentEmbeddedSegueId;
}


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self initEmbeddedVCs];
    [self setupSegControl];

    [self performSegueWithIdentifier:_currentEmbeddedSegueId sender:nil];

}

#pragma mark - Init/Setup Methods

- (void)initEmbeddedVCs
{
    NSMutableArray *embeddedVCs = [[NSMutableArray alloc] initWithCapacity:self.segControlView.numberOfSegments];
    [embeddedVCs addObject:[NSMutableArray arrayWithArray:@[@"embedExploreMap", [NSNull null]]]];
    [embeddedVCs addObject:[NSMutableArray arrayWithArray:@[@"embedExploreList", [NSNull null]]]];
    [embeddedVCs addObject:[NSMutableArray arrayWithArray:@[@"embedExploreSummary", [NSNull null]]]];
    self.embeddedVCs = embeddedVCs;
}

- (void)setupSegControl
{
    // Fix for background color of SegmentedControl
    // http://stackoverflow.com/questions/19138252/uisegmentedcontrol-bounds
    CAShapeLayer* mask = [[CAShapeLayer alloc] init];
    mask.frame = CGRectMake(0, 0, self.segControlView.bounds.size.width, self.segControlView.bounds.size.height);
    mask.path = [[UIBezierPath bezierPathWithRoundedRect:mask.frame cornerRadius:5] CGPath];
    self.segControlView.layer.mask = mask;
    self.segControlView.layer.cornerRadius = 5;

    self.segControlView.backgroundColor = [UIColor kColorButtonBackgroundHighlight];
    self.segControlView.selectedSegmentIndex = defaultEmbeddedView;
    _currentEmbeddedSegueId = self.embeddedVCs[self.segControlView.selectedSegmentIndex][0];
    
}


#pragma mark - IBActions

- (IBAction)segControlChanged:(id)sender
{
    _currentEmbeddedSegueId = self.embeddedVCs[self.segControlView.selectedSegmentIndex][0];
    [self performSegueWithIdentifier:_currentEmbeddedSegueId sender:nil];
}


#pragma mark - Embedded Segues/VCs

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    NSLog(@"%@:%@ segue=%@", self.class, NSStringFromSelector(_cmd), segue.identifier);
    NSLog(@"%s segue:%@", __PRETTY_FUNCTION__, segue.identifier);
    
    // Keep track of embedded VC instances to save reloading each time
    NSMutableArray *embeddedVC = self.embeddedVCs[self.segControlView.selectedSegmentIndex];
    UIViewController *destVC = [embeddedVC objectAtIndex:1];
    if ([destVC isEqual:[NSNull null]]) {
        destVC = segue.destinationViewController;
/*
        //Occurrence data (and options) currently managed/updated by MapVC, so need to pass through to child VCs
        //TODO : Move shared data (BCOptions and GBIFOccurrenceResults) to ContainerVC (or NSUserDefaults)
        if ([segue.identifier isEqualToString:@"embedExploreMap"]) {
            ExploreMapViewController *mapVC = (ExploreMapViewController *)destVC;
            mapVC.bcOptions = _bcOptions;
        }
*/
        [embeddedVC replaceObjectAtIndex:1 withObject:destVC];
    }

    // If embedded VC already loaded, swap open, else do initial load and add child VC/subview
    if (self.childViewControllers.count > 0) {
/*
        ExploreMapViewController *mapVC = (ExploreMapViewController *)self.embeddedVCs[defaultEmbeddedView][1];
        if ([segue.identifier isEqualToString:@"embedExploreList"]) {
            ExploreListViewController *listVC = (ExploreListViewController *)destVC;
            listVC.bcOptions = mapVC.bcOptions;
//            listVC.occurrenceResults = mapVC.occurrenceResults;
        } else if ([segue.identifier isEqualToString:@"embedExploreSummary"]) {
            ExploreSummaryViewController *summVC = (ExploreSummaryViewController *)destVC;
            summVC.bcOptions = mapVC.bcOptions;
//            summVC.occurrenceResults = mapVC.occurrenceResults;
        }
*/
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:destVC];
    }
    else {
        [self addChildViewController:segue.destinationViewController];
        UIView* destView = ((UIViewController *)segue.destinationViewController).view;
        destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.viewExploreContainer addSubview:destView];
        [segue.destinationViewController didMoveToParentViewController:self];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
	NSLog(@"ContainerViewController - swapFromViewController\n from:%@\n to:%@", fromViewController, toViewController);
    
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

@end
