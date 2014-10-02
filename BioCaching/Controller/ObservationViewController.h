//
//  ObservationViewController.h
//  BioCaching
//
//  Created by Andy Jeffrey on 17/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCLocationManager.h"

@interface ObservationViewController : UIViewController<
    BCLocationManagerDelegate,
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UITextViewDelegate>

@property (nonatomic, strong) OccurrenceRecord *occurrence;
@property (nonatomic, assign) BOOL locked;

@end
