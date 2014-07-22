//
//  OptionsSpeciesFilter.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsSpeciesFilter.h"

@implementation OptionsSpeciesFilter

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OptionsSpeciesFilter classMethod]"
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
        [_staticArray addObject:@[@"Plants", @"6"]];
        [_staticArray addObject:@[@"Animals", @"1"]];
        [_staticArray addObject:@[@"Mammals", @"359"]];
        [_staticArray addObject:@[@"Amphibians", @"131"]];
        [_staticArray addObject:@[@"Birds", @"212"]];
        [_staticArray addObject:@[@"Reptiles", @"358"]];
        [_staticArray addObject:@[@"Ray-finned Fishes", @"204"]];
        [_staticArray addObject:@[@"Insects", @"216"]];
        [_staticArray addObject:@[@"Arachnids", @"367"]];
        [_staticArray addObject:@[@"Mollusks", @"52"]];
        [_staticArray addObject:@[@"Fungi & Lichen", @"5"]];
        [_staticArray addObject:@[@"Kelp, Diatoms & Allies", @"4"]];
        [_staticArray addObject:@[@"Protozoans", @"7"]];    
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
