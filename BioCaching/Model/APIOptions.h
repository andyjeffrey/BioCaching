//
//  APIOptions.h
//  BioCaching
//
//  Created by Andy Jeffrey on 17/07/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIOptions <NSObject>

+ (NSArray *)allDisplayStrings;
+ (NSUInteger)count;

+ (NSString *)displayStringForOption:(NSUInteger)index;
+ (NSString *)queryStringGBIFValueForOption:(NSUInteger)index;

@end
