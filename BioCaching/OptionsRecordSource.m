//
//  OptionsRecordSource.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsRecordSource.h"

@implementation OptionsRecordSource

+ (NSArray *)optionsArray
{
    static NSMutableArray *_optionsArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _optionsArray = [[NSMutableArray alloc] initWithCapacity:RecordSourceCount];
        for (int i=0; i < RecordSourceCount; i++) {
            [_optionsArray addObject:@""];
        }
        [_optionsArray replaceObjectAtIndex:RecordSource_ALL
                                 withObject:@[@"All", @""]];
        [_optionsArray replaceObjectAtIndex:RecordSource_CAS
                                 withObject:@[@"California Academy of Sciences", @"CAS"]];
        [_optionsArray replaceObjectAtIndex:RecordSource_INAT
                                 withObject:@[@"iNaturalist", @"iNaturalist"]];
        [_optionsArray replaceObjectAtIndex:RecordSource_EBIRD
                                 withObject:@[@"Cornell/eBird", @"CLO"]];
        [_optionsArray replaceObjectAtIndex:RecordSource_NMNH
                                 withObject:@[@"NMNH/Smithsonian", @"USNM"]];
        [_optionsArray replaceObjectAtIndex:RecordSource_ANTWEB
                                 withObject:@[@"AntWeb (CAS)", @"casent"]];
    });
    
    
    return _optionsArray;
}

+(NSString *)displayString:(RecordSource)optionEnum
{
    NSArray *optionValuesArray = [[self class] optionsArray][optionEnum];;
    return optionValuesArray[0];
}

+(NSString *)queryStringValue:(RecordSource)optionEnum
{
    NSArray *optionValuesArray = [[self class] optionsArray][optionEnum];;
    return optionValuesArray[1];
}

@end
