//
//  NSDictionary+Filtering.m
//  BioCaching
//
//  Created by Andy Jeffrey on 01/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "NSDictionary+Filtering.h"

@implementation NSDictionary (Filtering)

- (NSArray *)getUniqueElementsOfValueArrays
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSObject *dictKey in [self allKeys]) {
        NSArray *arrayForKey = [self objectForKey:dictKey];
        [tempArray addObject:arrayForKey[0]];
    }
    return tempArray;
}

@end
