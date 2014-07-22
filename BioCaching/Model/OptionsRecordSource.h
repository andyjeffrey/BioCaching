//
//  OptionsRecordSource.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIOptions.h"

#define kDefaultOptionRecordSource RecordSource_ALL

typedef enum {
    RecordSource_ALL, // 382373384
    RecordSource_CAS, // CAS 1568966
    RecordSource_INAT, // iNaturalist 226862
    RecordSource_EBIRD, // CLO 108630077
    RecordSource_NMNH, // USNM 1505321
    RecordSource_ANTWEB, // casent 331162
    //    RecordSource_KEW, // K 181026
    //    RecordSource_FISHBASE, // FishBase 805691
    //    RecordSource_DIVEBOARD, // Diveboard 18178
    //    RecordSource_MBA, // Marine%20Biological%20Association 213188
    //    RecordSource_MCS, // Marine%20Conservation%20Society 403772
    RecordSourceCount
} RecordSource;

@interface OptionsRecordSource : NSObject<APIOptions>

@end
