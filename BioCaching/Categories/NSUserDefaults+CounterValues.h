//
//  NSUserDefaults+CounterValues.h
//  BioCaching
//
//  Created by Andy Jeffrey on 02/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (CounterValues)

+ (void)incrementStdDefaultsCounter:(NSString *)settingsKey;

@end
