//
//  OptionsSpeciesFilter.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsSpeciesFilter.h"

static int const defaultOptionIndex = 0;

/*
 typedef enum {
 SpeciesFilter_ALL, // 439214255
 SpeciesFilter_PLANTS, // 122616649
 SpeciesFilter_ANIMALS, // 294766533
 SpeciesFilter_MAMMALS, // 15842
 SpeciesFilter_AMPHIBIANS, // 3479295
 SpeciesFilter_BIRDS, // 210129123
 SpeciesFilter_REPTILES, // 3795142
 SpeciesFilter_FISHES, // 12904442
 SpeciesFilter_INSECTS, // 35857680
 SpeciesFilter_ARACHNIDS, // 1422714
 SpeciesFilter_MOLLUSKS, // 7048984
 SpeciesFilter_FUNGI, // 8211158
 SpeciesFilter_CHROMISTA, // 2145559
 SpeciesFilter_PROTOZOA, // 4639275
 SpeciesFilterCount
 } SpeciesFilter;
*/

@implementation OptionsSpeciesFilter

+ (NSArray *)staticArray
{
    static NSMutableArray *_staticArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticArray = [[NSMutableArray alloc] init];
        
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"All" queryStringValueGBIF:@""]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Plants" queryStringValueGBIF:@"6"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Animals" queryStringValueGBIF:@"1"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Mammals" queryStringValueGBIF:@"359"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Amphibians" queryStringValueGBIF:@"131"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Birds" queryStringValueGBIF:@"212"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Reptiles" queryStringValueGBIF:@"358"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Ray-finned Fishes" queryStringValueGBIF:@"204"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Insects" queryStringValueGBIF:@"216"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Arachnids" queryStringValueGBIF:@"367"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Mollusks" queryStringValueGBIF:@"52"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Fungi & Lichen" queryStringValueGBIF:@"5"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Kelp, Diatoms & Allies" queryStringValueGBIF:@"4"]];
        [_staticArray addObject:[[APIOption alloc] initWithValues:@"Protozoans" queryStringValueGBIF:@"7"]];

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

