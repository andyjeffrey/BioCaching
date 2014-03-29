//
//  NSCountedSet+Sorting.h
//  BioCaching
//
//  Created by Andy Jeffrey on 27/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCountedSet (Sorting)

- (NSArray *)sortByObjectAscending:(BOOL)sortAscending;
- (NSArray *)sortByCountAscending:(BOOL)sortAscending;

@end
