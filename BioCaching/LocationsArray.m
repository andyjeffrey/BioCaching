//
//  LocationsArray.m
//  BioCaching
//
//  Created by Andy Jeffrey on 23/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "LocationsArray.h"

@implementation LocationsArray

+ (NSArray *)staticArray
{
    static NSMutableArray *_staticArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticArray = [[NSMutableArray alloc] init];
        
        [_staticArray addObject:@[@"GoldenGate Park, CA", @37.769341, @-122.481937]];
        [_staticArray addObject:@[@"Pepperwood Preserve, CA", @38.577085, @-122.700702]];
        [_staticArray addObject:@[@"Lafayette Reservoir, CA", @37.879706, @-122.141128, @1000]];
        [_staticArray addObject:@[@"Yosemite NP, CA", @37.899650, @-119.536363, @2000]];
        [_staticArray addObject:@[@"Yellowstone NP, WY", @44.545806, @-110.284237]];
        [_staticArray addObject:@[@"Great Smoky Mountains NP, TN", @35.619517, @-83.550113]];
        [_staticArray addObject:@[@"Everglades National Park, FL", @25.321258, @-80.894518]];

        [_staticArray addObject:@[@"Tortuga Bay, Santa Cruz, Galapagos", @-0.764173, @-90.340036]];
        [_staticArray addObject:@[@"Seymour Norte, Galapagos", @-0.397408, @-90.288421]];
        [_staticArray addObject:@[@"Genovesa, Galapagos", @0.318447, @-89.949594]];

        [_staticArray addObject:@[@"Alexandra Park, London, UK", @51.5935, @-0.1265]];
        [_staticArray addObject:@[@"Exe Estuary MPA, UK", @50.647222, @-3.442222]];
        
        [_staticArray addObject:@[@"Gunung Mulu NP, Malaysia", @4.015155, @114.815863]];
//        [_staticArray addObject:@[@"Komodo NP, Indonesia", @-8.512431, @119.484972]];
        [_staticArray addObject:@[@"Kakadu NP, Australia", @-13.025143, @132.400693]];
        [_staticArray addObject:@[@"Great Barrier Reef, Australia", @-18.166250, @147.462269]];
//        [_staticArray addObject:@[@"Kruger NP, South Africa", @-23.853615, @31.532104]];
//        [_staticArray addObject:@[@"Virunga NP, DRC", @0.094444, @29.499171]];
        [_staticArray addObject:@[@"Ngorongoro, Tanzania", @-2.983965, @35.339133]];
        
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

+(CLLocationCoordinate2D)locationCoordinate:(NSInteger)arrayIndex
{
    NSArray *objectValuesArray = [[self class] staticArray][arrayIndex];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
    [objectValuesArray[1] doubleValue], [objectValuesArray[2] doubleValue]);
    return coordinate;
}

+(CLLocationCoordinate2D)defaultLocation
{
    return [[self class] locationCoordinate:0];
}







@end
