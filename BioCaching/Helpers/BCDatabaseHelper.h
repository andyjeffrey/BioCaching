//
//  BCDatabaseHelper.h
//  BioCaching
//
//  Created by Andy Jeffrey on 13/08/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCDatabaseHelper : NSObject

+ (void)initDataStore:(BOOL)resetDatabase;
+ (void)clearDataStore;

+ (NSUInteger)rowCountForEntity:(NSString *)entityName;

@end
