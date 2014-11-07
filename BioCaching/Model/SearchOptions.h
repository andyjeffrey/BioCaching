//
//  TripOptions.h
//  BioCaching
//
//  Created by Andy Jeffrey on 17/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OptionsRecordType.h"
#import "OptionsRecordSource.h"
#import "OptionsSpeciesFilter.h"

@interface SearchOptions : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D searchAreaCentre;
@property (nonatomic, assign) NSUInteger searchAreaSpan;
@property (nonatomic, strong) MKPolygon *searchAreaPolygon;
@property (nonatomic, copy) NSString *searchLocationName;

@property (nonatomic, assign) RecordType enumRecordType;
@property (nonatomic, assign) RecordSource enumRecordSource;
@property (nonatomic, assign) SpeciesFilter enumSpeciesFilter;

@property (nonatomic, copy) NSString *collectorName;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *yearFrom;
@property (nonatomic, copy) NSString *yearTo;

@property (nonatomic, assign) BOOL testGBIFAPI;
@property (nonatomic, assign) BOOL testGBIFData;
@property (nonatomic, assign) NSUInteger approxCirclePoints;

+ (instancetype)sharedInstance;
+ (id)initWithDefaults;

@end
