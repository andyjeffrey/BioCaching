//
//  OptionsRecordType.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIOptions.h"

#define kDefaultOptionRecordType RecordType_PRESERVED_SPECIMEN
#ifdef DEBUG
#define kDefaultOptionRecordType RecordType_ALL
#endif

typedef enum {
    RecordType_ALL, // 439101885
    RecordType_OBSERVATION, // 309166576
    RecordType_PRESERVED_SPECIMEN, // 94612722
    RecordType_FOSSIL_SPECIMEN, // 2727243
    RecordType_LIVING_SPECIMEN, // 766357
    RecordType_LITERATURE, // 402974
    RecordType_UNKNOWN, // 31426013
    //    RecordType_HUMAN_OBSERVATION, // 0
    //    RecordType_MACHINE_OBSERVATION, // 0
    RecordTypeCount
} RecordType;

@interface OptionsRecordType : NSObject<APIOptions>

@end
