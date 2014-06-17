//
//  BCAlerts.m
//  BioCaching
//
//  Created by Andy Jeffrey on 16/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "BCAlerts.h"

@implementation BCAlerts

+ (void)displayDefaultInfoAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(title, nil)
                                                 message:NSLocalizedString(message, nil)
                                                delegate:nil
                                       cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                       otherButtonTitles:nil];
    [av show];
}

@end
