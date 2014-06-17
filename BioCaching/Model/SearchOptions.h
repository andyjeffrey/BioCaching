//
//  TripOptions.h
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIOption.h"

@interface SearchOptions : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D searchAreaCentre;
@property (nonatomic, assign) NSUInteger searchAreaSpan;
@property (nonatomic, strong) MKPolygon *searchAreaPolygon;

@property (nonatomic, strong) APIOption *recordType;
@property (nonatomic, strong) APIOption *recordSource;
@property (nonatomic, strong) APIOption *speciesFilter;
//@property (nonatomic, assign) RecordType recordType;
//@property (nonatomic, assign) RecordSource recordSource;
//@property (nonatomic, assign) SpeciesFilter speciesFilter;
@property (nonatomic, copy) NSString *collectorName;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *yearFrom;
@property (nonatomic, copy) NSString *yearTo;

@property (nonatomic, assign) BOOL testGBIFAPI;
@property (nonatomic, assign) BOOL testGBIFData;

+ (id)initWithDefaults;

@end
