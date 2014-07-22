//
//  OptionsRecordSource.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsRecordSource.h"

@implementation OptionsRecordSource

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OptionsRecordSource classMethod]"
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
        [_staticArray addObject:@[@"California Academy of Sciences", @"CAS"]];
        [_staticArray addObject:@[@"iNaturalist", @"iNaturalist"]];
        [_staticArray addObject:@[@"Cornell/eBird", @"CLO"]];
        [_staticArray addObject:@[@"NMNH/Smithsonian", @"USNM"]];
        [_staticArray addObject:@[@"AntWeb (CAS)", @"casent"]];
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
