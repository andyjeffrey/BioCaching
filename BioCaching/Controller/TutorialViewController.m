//
//  TutorialViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialContentViewController.h"

@interface TutorialViewController ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (weak, nonatomic) IBOutlet UILabel *labelBack;
@property (weak, nonatomic) IBOutlet UILabel *labelForward;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
@property (weak, nonatomic) IBOutlet UIImageView *imageForward;

@property (weak, nonatomic) IBOutlet UINavigationBar *viewTopBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *labelTopBar;

@property (weak, nonatomic) IBOutlet UIView *viewPageView;

- (IBAction)buttonDone:(id)sender;

@end


@implementation TutorialViewController {
    NSMutableArray *_pageVCs;
    int _newViewIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    _pageImages = @[@"tutorial_1.png",
                    @"tutorial_2.png",
                    @"tutorial_3.png",
                    @"tutorial_4.png",
                    @"tutorial_5.png",
                    @"tutorial_6.png",
                    @"tutorial_7.png",
                    @"tutorial_8.png"];
    _pageTitles = @[@"Choose location to search by moving the map or selecting from the dropdown list",
                    @"Click search button to perform a search, sightings results displayed on the map",
                    @"View sighting details by selecting marker on map, click info for more details",
                    @"Switch between map, list and summary views. Click save/start when ready",
                    @"Record observations of species you find, adding photo evidence wherever possible",
                    @"View summary details of trip, add/amend trip title and description before ",
                    @"Use the Trips screen to access all trips and publish to iNat when completed",
                    @"Amend search parameters (and other app options) through the Settings screen"];

    _pageVCs = [NSMutableArray arrayWithObjects:
                [self viewControllerAtIndex:0],
                [self viewControllerAtIndex:1],
                [self viewControllerAtIndex:2],
                [self viewControllerAtIndex:3],
                [self viewControllerAtIndex:4],
                [self viewControllerAtIndex:5],
                [self viewControllerAtIndex:6],
                [self viewControllerAtIndex:7], nil];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
//    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
//    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:@[_pageVCs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updatePageNumberTitle];
    
//    // Change the size of page view controller
//    self.pageViewController.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 74);
    self.pageViewController.view.frame = self.viewPageView.frame;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)setupUI
{
    self.viewTopBar.backgroundColor = [UIColor kColorHeaderBackground];
    self.viewPageView.backgroundColor = [UIColor kColorTableBackgroundColor];
    
    self.labelBack.hidden = YES;
//    [self.imageBack setImage:[IonIcons imageWithIcon:icon_arrow_left_c iconColor:[UIColor kColorButtonLabel] iconSize:24 imageSize:CGSizeMake(50, 24)]];
    [self.imageBack setImage:[IonIcons imageWithIcon:icon_arrow_left_c size:30 color:[UIColor kColorLabelText]]];
    
    self.labelForward.hidden = YES;
//    [self.imageForward setImage:[IonIcons imageWithIcon:icon_arrow_right_c iconColor:[UIColor kColorButtonLabel] iconSize:50 imageSize:CGSizeMake(50, 24)]];
    [self.imageForward setImage:[IonIcons imageWithIcon:icon_arrow_right_c size:30 color:[UIColor kColorLabelText]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)startWalkthrough:(id)sender {
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}
*/

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    TutorialContentViewController *tutorialContentVC = _pageVCs[index];
    
    if (!tutorialContentVC) {
        tutorialContentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentVC"];
        tutorialContentVC.pageIndex = index;
        tutorialContentVC.pageTitleText = self.pageTitles[index];
        tutorialContentVC.pageImageFile = self.pageImages[index];
    }
    
    return tutorialContentVC;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
//    [self updatePageNumberTitle];
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController *) viewController).pageIndex;
    
    if (((index+1) >= _pageVCs.count) || (index == NSNotFound)) {
        return nil;
    }
    
    index++;
//    [self updatePageNumberTitle];

    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)updatePageNumberTitle {
    TutorialContentViewController *currentVC = self.pageViewController.viewControllers[0];
    self.labelTopBar.title = [NSString stringWithFormat:@"Tutorial Page %d/%d",
                              (int)currentVC.pageIndex+1, (int)_pageVCs.count];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self updatePageNumberTitle];
    }
}

- (IBAction)buttonDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
