//
//  OptionsRecordType.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsRecordType.h"

static int const defaultOptionIndex = 2;

/*
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
*/

@implementation OptionsRecordType

+ (NSArray *)staticArray
{
    static NSMutableArray *_staticArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticArray = [[NSMutableArray alloc] init];
        
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"All" queryStringValueGBIF:@""]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Observation" queryStringValueGBIF:@"OBSERVATION"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Museum Specimen" queryStringValueGBIF:@"PRESERVED_SPECIMEN"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Fossil Specimen" queryStringValueGBIF:@"FOSSIL_SPECIMEN"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Living Specimen" queryStringValueGBIF:@"LIVING_SPECIMEN"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Literature" queryStringValueGBIF:@"LITERATURE"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Unknown" queryStringValueGBIF:@"Unknown"]];
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
