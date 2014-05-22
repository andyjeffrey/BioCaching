//
//  MainViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 29/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCOptions.h"

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (nonatomic, strong) BCOptions *bcOptions;

@end
