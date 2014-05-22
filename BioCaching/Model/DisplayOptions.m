//
//  DisplayOptions.m
//  BioCaching
//
//  Created by Andy Jeffrey on 23/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "DisplayOptions.h"

@implementation DisplayOptions

+(id)initWithDefaults
{
    DisplayOptions *displayOptions = [[DisplayOptions alloc] init];
    
    displayOptions.displayPoints = kOptionsDefaultDisplayPoints;
    displayOptions.uniqueSpecies = kOptionsDefaultUniqueSpecies;
    displayOptions.uniqueLocations = kOptionsDefaultUniqueLocations;
    displayOptions.fullSpeciesNames = kOptionsDefaultFullSpeciesNames;

    displayOptions.mapType = kOptionsDefaultMapType;
    
    return displayOptions;
}

@end
