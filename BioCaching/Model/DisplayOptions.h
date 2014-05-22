//
//  DisplayOptions.h
//  BioCaching
//
//  Created by Andy Jeffrey on 23/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayOptions : NSObject

@property (nonatomic, assign) NSUInteger displayPoints;
@property (nonatomic, assign) BOOL uniqueSpecies;
@property (nonatomic, assign) BOOL uniqueLocations;
@property (nonatomic, assign) BOOL fullSpeciesNames;

@property (nonatomic, assign) MKMapType mapType;

+ (id)initWithDefaults;

@end
