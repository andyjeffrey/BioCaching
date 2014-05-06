//
//  OptionsRecordSource.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsRecordSource.h"

static int const defaultOptionIndex = 0;

/*
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
*/

@implementation OptionsRecordSource

+ (NSArray *)staticArray
{
    static NSMutableArray *_staticArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticArray = [[NSMutableArray alloc] init];
        
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"All" queryStringValueGBIF:@""]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"California Academy of Sciences" queryStringValueGBIF:@"CAS"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"iNaturalist" queryStringValueGBIF:@"iNaturalist"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Cornell/eBird" queryStringValueGBIF:@"CLO"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"NMNH/Smithsonian" queryStringValueGBIF:@"USNM"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"AntWeb (CAS)" queryStringValueGBIF:@"casent"]];    
    });
    
    return _staticArray;
}

+ (NSArray *)displayStrings
{
    NSMutableArray *displayStrings = [[NSMutableArray alloc] init];
    for (APIOption *apiOption in [self staticArray]) {
        [displayStrings addObject:apiOption.displayString];
    }
    return displayStrings;
}

+ (APIOption *)defaultOption
{
    APIOption *apiOption = [[self staticArray] objectAtIndex:defaultOptionIndex];
    return apiOption;
}

+ (APIOption *)objectAtIndex:(NSUInteger)index
{
    return (APIOption *) [self staticArray][index];
}

+ (NSUInteger)count
{
    return [[self staticArray] count];
}

@end
