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
                    @"tutorial_6.png"];
    _pageTitles = @[@"Tutorial Instructions Page 1 Line 1\nTutorial Instructions Page 1 Line 2",
                    @"Tutorial Instructions Page 2 Line 1\nTutorial Instructions Page 2 Line 2",
                    @"Tutorial Instructions Page 3 Line 1\nTutorial Instructions Page 3 Line 2",
                    @"Tutorial Instructions Page 4 Line 1\nTutorial Instructions Page 4 Line 2",
                    @"Tutorial Instructions Page 4 Line 1\nTutorial Instructions Page 5 Line 2",
                    @"Tutorial Instructions Page 5 Line 1\nTutorial Instructions Page 6 Line 2"];

    _pageVCs = [NSMutableArray arrayWithObjects:
                [self viewControllerAtIndex:0],
                [self viewControllerAtIndex:1],
                [self viewControllerAtIndex:2],
                [self viewControllerAtIndex:3],
                [self viewControllerAtIndex:4],
                [self viewControllerAtIndex:5], nil];

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

    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
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
