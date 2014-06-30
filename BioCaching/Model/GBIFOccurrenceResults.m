//
//  GBIFOccurenceResults.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFOccurrenceResults.h"

@implementation GBIFOccurrenceResults {
    NSMutableArray* _filteredResults;
    NSMutableArray* _tripListResults;
}

@synthesize Offset;
@synthesize Limit;
@synthesize EndOfRecords;
@synthesize Count;
@synthesize Results;

+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[GBIFOccurrenceResults alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        _dictRecordSource = [[NSMutableDictionary alloc] init];
        _dictRecordType = [[NSMutableDictionary alloc] init];
        _dictTaxonSpecies = [[NSMutableDictionary alloc] init];
        _dictTaxonKingdom = [[NSMutableDictionary alloc] init];
        _dictTaxonPhylum = [[NSMutableDictionary alloc] init];
        _dictTaxonClass = [[NSMutableDictionary alloc] init];
        _dictRecordLocation = [[NSMutableDictionary alloc] init];
        _removedResults = [[NSMutableSet alloc] init];
        
        Offset = [dictionary objectForKey:@"offset"];
        Limit = [dictionary objectForKey:@"limit"];
        EndOfRecords = [dictionary objectForKey:@"endOfRecords"];
        Count = [dictionary objectForKey:@"count"];
        
        NSArray *resultsArray =  [dictionary objectForKey:@"results"];
        Results = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in resultsArray) {
            GBIFOccurrence *occurrence = [GBIFOccurrence objectWithDictionary:dict];
            //NSLog(@"Adding Record: %@", d);
            [Results addObject:occurrence];
            
            NSMutableArray *tempArray;
            if (occurrence.BasisOfRecord) {
//                [self.recordTypeCounts addObject:occurrence.BasisOfRecord];
                if (!(tempArray = [_dictRecordType objectForKey:occurrence.BasisOfRecord])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictRecordType setValue:tempArray forKey:occurrence.BasisOfRecord];
                }
                [tempArray addObject:occurrence];
            }
            
            if (occurrence.InstitutionCode) {
//                [self.recordSourceCounts addObject:occurrence.InstitutionCode];
                if (!(tempArray = [_dictRecordSource objectForKey:occurrence.InstitutionCode])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictRecordSource setValue:tempArray forKey:occurrence.InstitutionCode];
                }
                [tempArray addObject:occurrence];
            }
            
            if (occurrence.Kingdom) {
//                [self.taxonKingdomCounts addObject:occurrence.Kingdom];
                if (!(tempArray = [_dictTaxonKingdom objectForKey:occurrence.Kingdom])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictTaxonKingdom setValue:tempArray forKey:occurrence.Kingdom];
                }
                [tempArray addObject:occurrence];
            }
            
            if (occurrence.Phylum) {
//                [self.taxonPhylumCounts addObject:occurrence.Phylum];
                if (!(tempArray = [_dictTaxonPhylum objectForKey:occurrence.Phylum])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictTaxonPhylum setValue:tempArray forKey:occurrence.Phylum];
                }
                [tempArray addObject:occurrence];
            }
            
            if (occurrence.Clazz) {
//                [self.taxonClassCounts addObject:occurrence.Clazz];
                if (!(tempArray = [_dictTaxonClass objectForKey:occurrence.Clazz])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictTaxonClass setValue:tempArray forKey:occurrence.Clazz];
                }
                [tempArray addObject:occurrence];
            }

            if (occurrence.speciesBinomial) {
                if (!(tempArray = [_dictTaxonSpecies objectForKey:occurrence.speciesBinomial])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictTaxonSpecies setValue:tempArray forKey:occurrence.speciesBinomial];
                }
                [tempArray addObject:occurrence];
            }
            
            if (occurrence.locationString) {
                if (!(tempArray = [_dictRecordLocation objectForKey:occurrence.locationString])) {
                    tempArray = [[NSMutableArray alloc] init];
                    [_dictRecordLocation setValue:tempArray forKey:occurrence.locationString];
                }
                [tempArray addObject:occurrence];
            }

        }
/*
        NSLog(@"Record Type Counts: %@", [self.recordTypeCounts sortByCountAscending:NO]);
        NSLog(@"Record Source Counts: %@", [self.recordSourceCounts sortByCountAscending:NO]);
        NSLog(@"Taxon Kingdom Counts: %@", [self.taxonKingdomCounts sortByCountAscending:NO]);
        NSLog(@"Taxon Phylum Counts: %@", [self.taxonPhylumCounts sortByCountAscending:NO]);
        NSLog(@"Taxon Class Counts: %@", [self.taxonClassCounts sortByCountAscending:NO]);
        NSLog(@"Taxon Species Counts: %@", [self.taxonSpeciesCounts sortByCountAscending:NO]);
*/
    }
    
    return self;
}

- (NSArray *)fullSpeciesBinomial
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"speciesBinomial != nil"];
    NSArray *array = [self.Results filteredArrayUsingPredicate:predicate];
    return array;
}

- (NSArray *)uniqueSpecies
{
    return [_dictTaxonSpecies getUniqueElementsOfValueArrays];
}

- (NSArray *)uniqueLocations
{
    return [_dictRecordLocation getUniqueElementsOfValueArrays];
}

- (NSArray *) getFilteredResults:(BOOL)limitToDisplayPoints;
{
    DisplayOptions *displayOptions = [DisplayOptions sharedInstance];
    NSMutableSet *filteredResults = [[NSMutableSet alloc] initWithArray:self.Results];
    
    if (displayOptions.fullSpeciesNames)
    {
        NSSet *tempSet = [[NSSet alloc] initWithArray:self.fullSpeciesBinomial];
        [filteredResults intersectSet:tempSet];
    }
    if (displayOptions.uniqueSpecies)
    {
        NSSet *tempSet = [[NSSet alloc] initWithArray:self.uniqueSpecies];
        [filteredResults intersectSet:tempSet];
    }
    if (displayOptions.uniqueLocations)
    {
        NSSet *tempSet = [[NSSet alloc] initWithArray:self.uniqueLocations];
        [filteredResults intersectSet:tempSet];
    }
    
    [filteredResults minusSet:self.removedResults];
    
    if (limitToDisplayPoints)
    {
        NSArray *filteredArray = [filteredResults allObjects];
        NSUInteger upperRange = MIN(filteredResults.count, displayOptions.displayPoints);
        return [filteredArray subarrayWithRange:NSMakeRange(0, upperRange)];
    }
    else
    {
        return [filteredResults allObjects];
    }
}

- (NSArray *)filteredResults
{
    _filteredResults = [[self getFilteredResults:NO] mutableCopy];
    return _filteredResults;
}

- (NSArray *)tripListResults
{
    _tripListResults = [[self getFilteredResults:YES] mutableCopy];
    return _tripListResults;
}



@end
