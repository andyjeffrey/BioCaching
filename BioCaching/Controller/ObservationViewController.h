//
//  ObservationViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 17/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationController.h"

@interface ObservationViewController : UIViewController<
    LocationControllerDelegate,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate>

@property (nonatomic, strong) OccurrenceRecord *occurrence;
@property (nonatomic, assign) BOOL locked;

@end
