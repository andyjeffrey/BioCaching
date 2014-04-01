//
//  OptionsSpeciesFilter.m
//  BioCaching
//
//  Created by Andy Jeffrey on 21/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "OptionsSpeciesFilter.h"

@implementation OptionsSpeciesFilter

+ (NSArray *)optionsArray
{
    static NSMutableArray *_optionsArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _optionsArray = [[NSMutableArray alloc] initWithCapacity:SpeciesFilterCount];
        for (int i=0; i < SpeciesFilterCount; i++) {
            [_optionsArray addObject:@""];
        }
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_ALL
                                 withObject:@[@"All", @""]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_PLANTS
                                 withObject:@[@"Plants", @"6"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_FUNGI
                                 withObject:@[@"Fungi & Lichen", @"5"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_CHROMISTA
                                 withObject:@[@"Kelp, Diatoms & Allies", @"4"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_PROTOZOA
                                 withObject:@[@"Protozoans", @"7"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_ANIMALS
                                 withObject:@[@"Animals", @"1"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_MOLLUSKS
                                 withObject:@[@"Mollusks", @"52"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_MAMMALS
                                 withObject:@[@"Mammals", @"359"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_AMPHIBIANS
                                 withObject:@[@"Amphibians", @"131"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_BIRDS
                                 withObject:@[@"Birds", @"212"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_REPTILES
                                 withObject:@[@"Reptiles", @"358"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_FISHES
                                 withObject:@[@"Ray-finned Fishes", @"204"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_INSECTS
                                 withObject:@[@"Insects", @"216"]];
        [_optionsArray replaceObjectAtIndex:SpeciesFilter_ARACHNIDS
                                 withObject:@[@"Arachnids", @"367"]];
    });
    
    
    return _optionsArray;
}

+(NSString *)displayString:(SpeciesFilter)optionEnum
{
    NSArray *optionValuesArray = [[self class] optionsArray][optionEnum];;
    return optionValuesArray[0];
}

+(NSString *)queryStringValue:(SpeciesFilter)optionEnum
{
    NSArray *optionValuesArray = [[self class] optionsArray][optionEnum];;
    return optionValuesArray[1];
}
@end
