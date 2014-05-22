//
//  OptionsRecordSource.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIOption.h"

@interface OptionsRecordSource : NSObject

+ (NSArray *)displayStrings;
+ (APIOption *)defaultOption;

+ (APIOption *)objectAtIndex:(NSUInteger)index;
+ (NSUInteger)count;

@end
