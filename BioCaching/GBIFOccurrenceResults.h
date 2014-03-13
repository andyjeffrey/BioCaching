//
//  GBIFOccurenceResults.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrence.h"

@interface GBIFOccurrenceResults : NSObject

@property(nonatomic,strong) NSNumber * Offset;
@property(nonatomic,strong) NSNumber * Limit;
@property(nonatomic,strong) NSString * EndOfRecords;
@property(nonatomic,strong) NSNumber * Count;
@property(nonatomic,strong) NSMutableArray * Results;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end


