//
//  OptionsRecordType.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsRecordType.h"

@implementation OptionsRecordType

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OptionsRecordType classMethod]"
                                 userInfo:nil];
    return nil;
}

+ (NSArray *)staticArray
{
    static NSMutableArray *_staticArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticArray = [[NSMutableArray alloc] init];

        [_staticArray addObject:@[@"All", @""]];
        [_staticArray addObject:@[@"Observation", @"OBSERVATION"]];
        [_staticArray addObject:@[@"Museum Specimen", @"PRESERVED_SPECIMEN"]];
        [_staticArray addObject:@[@"Fossil Specimen", @"FOSSIL_SPECIMEN"]];
        [_staticArray addObject:@[@"Living Specimen", @"LIVING_SPECIMEN"]];
        [_staticArray addObject:@[@"Literature", @"LITERATURE"]];
        [_staticArray addObject:@[@"Unknown", @"Unknown"]];
    });
    
    return _staticArray;
}

+ (NSArray *)allDisplayStrings {
    NSMutableArray *displayStrings = [[NSMutableArray alloc] init];
    for (NSArray *option in [self staticArray]) {
        [displayStrings addObject:option[0]];
    }
    return displayStrings;
}

+ (NSUInteger)count {
    return [self staticArray].count;
}

+ (NSString *)displayStringForOption:(NSUInteger)index {
    return [self staticArray][index][0];
}

+ (NSString *)queryStringGBIFValueForOption:(NSUInteger)index {
    return [self staticArray][index][1];
}

@end
