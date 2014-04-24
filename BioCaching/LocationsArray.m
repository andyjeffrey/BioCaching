//
//  LocationsArray.m
//  BioCaching
//
//  Created by Andy Jeffrey on 23/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "LocationsArray.h"

#define kDefaultLocationIndex 1

@implementation LocationsArray

+ (NSArray *)staticArray
{
    static NSMutableArray *_staticArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticArray = [[NSMutableArray alloc] init];
        
        [_staticArray addObject:@[@"Current Location", @0, @0, @kDefaultSearchAreaSpan, @kDefaultViewSpan]];
        
        [_staticArray addObject:@[@"GoldenGate Park, CA", @37.769341, @-122.481937, @1000, @5000]];
        [_staticArray addObject:@[@"Pillar Point Harbor", @37.499484, @-122.488098, @1000, @2500]];
        [_staticArray addObject:@[@"Pepperwood Preserve, CA", @38.577085, @-122.700702, @2000, @8000]];
        [_staticArray addObject:@[@"Lafayette Reservoir, CA", @37.881188, @-122.145867, @1000, @4000]];
        [_staticArray addObject:@[@"Yosemite NP, CA", @37.899650, @-119.536363, @2000]];
        [_staticArray addObject:@[@"Yellowstone NP, WY", @44.447702, @-110.590353, @8000, @16000]];
        [_staticArray addObject:@[@"Great Smoky Mountains NP, TN", @35.661489, @-83.559093, @8000, @20000]];
        [_staticArray addObject:@[@"Everglades National Park, FL", @25.167975, @-80.884781, @8000, @20000]];

        [_staticArray addObject:@[@"Tortuga Bay, Santa Cruz, Galapagos", @-0.764173, @-90.340036]];
        [_staticArray addObject:@[@"Seymour Norte, Galapagos", @-0.397408, @-90.288421]];
        [_staticArray addObject:@[@"Genovesa, Galapagos", @0.337141, @-89.961934, @2000, @8000]];

        [_staticArray addObject:@[@"Alexandra Park, London, UK", @51.588563, @-0.125871, @1000, @2500]];
        [_staticArray addObject:@[@"Exe Estuary MPA, UK", @50.647222, @-3.442222, @2000, @5000]];
        
        [_staticArray addObject:@[@"Gunung Mulu NP, Malaysia", @4.144579, @114.930725, @8000, @30000]];
//        [_staticArray addObject:@[@"Komodo NP, Indonesia", @-8.512431, @119.484972]];
        [_staticArray addObject:@[@"Kakadu NP, Australia", @-12.708650, @132.751885, @8000, @25000]];
        [_staticArray addObject:@[@"Great Barrier Reef, Australia", @-14.684754, @145.451969, @4000, @8000]];
//        [_staticArray addObject:@[@"Kruger NP, South Africa", @-23.853615, @31.532104]];
//        [_staticArray addObject:@[@"Virunga NP, DRC", @0.094444, @29.499171]];
        [_staticArray addObject:@[@"Ngorongoro, Tanzania", @-2.983820, @35.388311, @8000, @25000]];
        
//        [_optionsArray addObject:@[@"NAME", @LAT, @LONG]];
    });
    
    
    return _staticArray;
}

+(NSUInteger)count
{
    return [[[self class] staticArray] count];
}

+(NSArray *)displayStringsArray
{
    NSMutableArray *displayStrings = [[NSMutableArray alloc] init];
    for (NSArray *optionArray in [[self class] staticArray]) {
        [displayStrings addObject:optionArray[0]];
    }
    return displayStrings;
}

+(NSString *)displayString:(NSInteger)arrayIndex
{
    NSArray *objectValuesArray = [[self class] staticArray][arrayIndex];
    return objectValuesArray[0];
}

+(NSString *)locationString:(NSInteger)arrayIndex
{
    NSArray *objectValuesArray = [[self class] staticArray][arrayIndex];
    return [NSString stringWithFormat:@"Lat: %f , Long: %f ",
            [objectValuesArray[1] doubleValue],
            [objectValuesArray[2] doubleValue]];
}

+(int)locationSearchAreaSpan:(NSInteger)arrayIndex
{
    NSArray *objectValuesArray = [[self class] staticArray][arrayIndex];
    if (objectValuesArray.count > 3) {
        return [objectValuesArray[3] intValue];
    } else {
        return kDefaultSearchAreaSpan;
    }
}

+(int)locationViewSpan:(NSInteger)arrayIndex
{
    NSArray *objectValuesArray = [[self class] staticArray][arrayIndex];
    if (objectValuesArray.count > 4) {
        return [objectValuesArray[4] intValue];
    } else {
        return kDefaultViewSpan;
    }
}

+(NSUInteger)defaultLocationIndex
{
    return kDefaultLocationIndex;
}

+(CLLocationCoordinate2D)defaultLocation
{
    return [[self class] locationCoordinate:kDefaultLocationIndex];
}

+(CLLocationCoordinate2D)locationCoordinate:(NSInteger)arrayIndex
{
    NSArray *objectValuesArray = [[self class] staticArray][arrayIndex];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
    [objectValuesArray[1] doubleValue], [objectValuesArray[2] doubleValue]);
    return coordinate;
}








@end
