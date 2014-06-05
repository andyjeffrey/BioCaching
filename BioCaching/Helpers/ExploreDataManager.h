//
//  ExploreDataManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 03/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExploreDataManagerDelegate.h"
#import "GBIFManagerDelegate.h"
#import "INatManagerDelegate.h"
#import "BCOptions.h"
#import "GBIFOccurrenceResults.h"
#import "GBIFOccurrence.h"

@interface ExploreDataManager : NSObject <GBIFManagerDelegate, INatManagerDelegate>

@property (weak, nonatomic) id<ExploreDataManagerDelegate> delegate;

@property (nonatomic, strong) GBIFOccurrenceResults *occurrenceResults;

+ (instancetype)sharedInstance;

- (void)fetchOccurrencesWithOptions:(BCOptions *)options;
- (void)removeOccurrence:(GBIFOccurrence *)occurrence;

@end
