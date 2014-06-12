//
//  TaxonInfoViewController.m
//  BioCaching
//
//  Created by Andy Jeffrey on 01/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "TaxonInfoViewController.h"
#import "OccurrenceDetailsViewController.h"
#import "ImageCache.h"
#import "ExploreDataManager.h"
#import "TripsDataManager.h"

@interface TaxonInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageMainPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelPhotoCopyright;

@property (weak, nonatomic) IBOutlet UIImageView *imageIconicTaxon;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTaxonSubTitle;

@property (weak, nonatomic) IBOutlet UIView *viewOverlayMask;
@property (weak, nonatomic) IBOutlet UIView *viewRemoveButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageRemoveButton;

@property (weak, nonatomic) IBOutlet UIButton *buttonDetails;
@property (weak, nonatomic) IBOutlet UIButton *buttonRemove;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord;

- (IBAction)viewOccurrenceDetails:(id)sender;
- (IBAction)removeOccurrence:(id)sender;

@end

@implementation TaxonInfoViewController {
    INatTrip *_currentTrip;
}

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
}

- (void)viewWillAppear:(BOOL)animated
{
    _currentTrip = [TripsDataManager sharedInstance].currentTrip;
    [self updateTaxonView];
    [self updateButtons];
}

- (void)updateButtons
{
    if (self.showDetailsButton) {
        self.buttonDetails.hidden = NO;
    }
    
    if ([_currentTrip.status intValue] < TripStatusInProgress) {
        self.buttonRemove.hidden = NO;
        self.buttonRecord.hidden = YES;
    } else {
        self.buttonRemove.hidden = YES;
        self.buttonRecord.hidden = NO;
    }
    
}

- (void)updateTaxonView
{
    INatTaxonPhoto *iNatTaxonPhoto;
    
    if (self.occurrence.iNatTaxon.taxon_photos.count > 0) {
        iNatTaxonPhoto = self.occurrence.iNatTaxon.taxon_photos[0];
        
        CGRect imageFrame = self.imageMainPhoto.frame;
        
        //        [self.imageMainPhoto setImageWithURL:[NSURL URLWithString:iNatTaxonPhoto.medium_url]];
        self.imageMainPhoto.image = [ImageCache getImageForURL:iNatTaxonPhoto.medium_url];
        if (self.imageMainPhoto.image.size.height > imageFrame.size.height) {
            self.imageMainPhoto.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            self.imageMainPhoto.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        self.labelPhotoCopyright.text = iNatTaxonPhoto.attribution;
    } else {
        self.imageMainPhoto.image = nil;
        self.labelPhotoCopyright.text = nil;
    }
    
    self.imageIconicTaxon.image = [UIImage imageNamed:[self.occurrence getINatIconicTaxaMainImageFile]];
    self.labelTaxonTitle.text = self.occurrence.title;
    self.labelTaxonSubTitle.text = self.occurrence.subtitle;
    //    self.labelTaxonFamily.text = [NSString stringWithFormat:@"Class: %@   Family: %@", occurrence.Clazz, occurrence.Family];
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

- (IBAction)viewOccurrenceDetails:(id)sender {
    OccurrenceDetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OccurrenceDetails"];
    detailsVC.occurrence = self.occurrence;
    [self.parentViewController.navigationController pushViewController:detailsVC animated:YES];
}

- (IBAction)removeOccurrence:(id)sender {
    [[ExploreDataManager sharedInstance] removeOccurrence:self.occurrence];
    if (self.navigationController.topViewController == self.parentViewController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
