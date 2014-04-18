//
//  OptionsRecordType.m
//  BioCaching
//
//  Created by Andy Jeffrey on 20/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsRecordType.h"

@implementation OptionsRecordType

+ (NSArray *)optionsArray
{
    static NSMutableArray *_optionsArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _optionsArray = [[NSMutableArray alloc] initWithCapacity:RecordTypeCount];
        for (int i=0; i < RecordTypeCount; i++) {
            [_optionsArray addObject:@""];
        }
        [_optionsArray replaceObjectAtIndex:RecordType_ALL
                                     withObject:@[@"All", @""]];
        [_optionsArray replaceObjectAtIndex:RecordType_OBSERVATION
                                     withObject:@[@"Observation", @"OBSERVATION"]];
        [_optionsArray replaceObjectAtIndex:RecordType_PRESERVED_SPECIMEN
                                     withObject:@[@"Museum Specimen", @"PRESERVED_SPECIMEN"]];
        [_optionsArray replaceObjectAtIndex:RecordType_FOSSIL_SPECIMEN
                                     withObject:@[@"Fossil Specimen", @"FOSSIL_SPECIMEN"]];
        [_optionsArray replaceObjectAtIndex:RecordType_LIVING_SPECIMEN
                                     withObject:@[@"Living Specimen", @"LIVING_SPECIMEN"]];
        [_optionsArray replaceObjectAtIndex:RecordType_LITERATURE
                                     withObject:@[@"Literature", @"LITERATURE"]];
        [_optionsArray replaceObjectAtIndex:RecordType_UNKNOWN
                                     withObject:@[@"Unknown", @"UNKNOWN"]];
    });
    
    return _optionsArray;
}

+(NSString *)displayString:(RecordType)optionEnum
{
    NSArray *optionValuesArray = [[self class] optionsArray][optionEnum];;
    return optionValuesArray[0];
}

+(NSString *)queryStringValue:(RecordType)optionEnum
{
    NSArray *optionValuesArray = [[self class] optionsArray][optionEnum];;
    return optionValuesArray[1];
}

@end
