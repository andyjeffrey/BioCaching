//
//  ExploreDataManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 03/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "ExploreDataManager.h"
#import "GBIFManager.h"
#import "INatManager.h"
#import "ImageCache.h"

@implementation ExploreDataManager {
    GBIFManager *_gbifManager;
    INatManager *_iNatManager;
    BCOptions *_bcOptions;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static ExploreDataManager *instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] initPrivate];
    });
    return instance;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ExploreDataManager sharedInstance]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _gbifManager = [[GBIFManager alloc] init];
        _gbifManager.delegate = self;

        _iNatManager = [[INatManager alloc] init];
        _iNatManager.delegate = self;
    }
    return self;
}


#pragma mark - ExploreDataManager Protocol Methods

- (void)fetchOccurrencesWithOptions:(BCOptions *)bcOptions
{
    _bcOptions = bcOptions;
    [_gbifManager fetchOccurrencesWithOptions:bcOptions.searchOptions];
}

- (void)removeOccurrence:(GBIFOccurrence *)occurrence
{
    [_occurrenceResults.Results removeObject:occurrence];
    [self.delegate occurrenceRemoved:occurrence];
}


#pragma mark - GBIFManagerDelegate Methods

- (void)didReceiveOccurences:(GBIFOccurrenceResults *)occurrenceResults
{
    NSLog(@"ExploreMapViewController didReceiveOccurences: %lu", (unsigned long)occurrenceResults.Results.count);
    _occurrenceResults = occurrenceResults;
    
    [self.delegate occurrenceResultsReceived:_occurrenceResults];
    
    for (GBIFOccurrence *occurrence in [_occurrenceResults getFilteredResults:_bcOptions.displayOptions limitToMapPoints:YES]) {
        [_iNatManager addINatTaxonToGBIFOccurrence:occurrence];
    }
}

- (void)fetchingResultsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - INatManagerDelegate Methods

- (void)iNatTaxonAddedToGBIFOccurrence:(GBIFOccurrence *)occurrence
{
    //    NSLog(@"%s iNatTaxon: %@ - %@", __PRETTY_FUNCTION__, occurrence.speciesBinomial, occurrence.iNatTaxon.common_name);
    
    if (occurrence.iNatTaxon)
    {
        if (occurrence.iNatTaxon.taxon_photos.count > 0)
        {
            INatTaxonPhoto *mainPhoto = occurrence.iNatTaxon.taxon_photos[0];
            [ImageCache saveImageForURL:mainPhoto.medium_url];
        }
    }
    
    [self.delegate taxonAddedToOccurrence:occurrence];
}


@end
