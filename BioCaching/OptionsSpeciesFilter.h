//
//  OptionsSpeciesFilter.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface OptionsSpeciesFilter : NSObject

+ (NSArray *)optionsArray;
+ (NSString *)displayString:(SpeciesFilter)optionEnum;
+ (NSString *)queryStringValue:(SpeciesFilter)optionEnum;

@end