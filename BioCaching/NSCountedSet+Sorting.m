//
//  NSCountedSet+Sorting.m
//  BioCaching
//
//  Created by Andy Jeffrey on 27/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "NSCountedSet+Sorting.h"

@implementation NSCountedSet (Sorting)

- (NSArray *)sortByObjectAscending:(BOOL)sortAscending
{
    NSMutableArray *dictArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [dictArray addObject:@{@"object": obj,
                               @"count": @([self countForObject:obj])}];
    }];
    
    return [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"object" ascending:sortAscending]]];
}

- (NSArray *)sortByCountAscending:(BOOL)sortAscending
{
    NSMutableArray *dictArray = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [dictArray addObject:@{@"object": obj,
                               @"count": @([self countForObject:obj])}];
    }];
    
    return [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:sortAscending]]];
}


@end
