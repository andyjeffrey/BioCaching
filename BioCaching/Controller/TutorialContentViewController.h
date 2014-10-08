//
//  TutorialContentViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/10/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController

@property (assign, nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSString *pageTitleText;
@property (strong, nonatomic) NSString *pageImageFile;

@end
