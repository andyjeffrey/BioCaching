//
//  GBIFOccurenceResults.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFOccurrenceResults.h"

@implementation GBIFOccurrenceResults

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
        _recordTypeCounts = [[NSCountedSet alloc] init];
        _recordSourceCounts = [[NSCountedSet alloc] init];
//        _fullSpeciesBinomial = [[NSMutableSet alloc] init];
        _taxonKingdomCounts = [[NSCountedSet alloc] init];
        _taxonClassCounts = [[NSCountedSet alloc] init];
        _taxonSpeciesCounts = [[NSCountedSet alloc] init];
        
        Offset = [dictionary objectForKey:@"offset"];
        Limit = [dictionary objectForKey:@"limit"];
        EndOfRecords = [dictionary objectForKey:@"endOfRecords"];
        Count = [dictionary objectForKey:@"count"];
        
        NSArray* temp =  [dictionary objectForKey:@"results"];
        Results = [[NSMutableArray alloc] init];
        for (NSDictionary *d in temp) {
            GBIFOccurrence *occurrence = [GBIFOccurrence objectWithDictionary:d];
            //NSLog(@"Adding Record: %@", d);
            [Results addObject:occurrence];
            
            if (occurrence.BasisOfRecord) {
                [self.recordTypeCounts addObject:occurrence.BasisOfRecord];
            }
            
            if (occurrence.InstitutionCode) {
                [self.recordSourceCounts addObject:occurrence.InstitutionCode];
            }
            
            if (occurrence.Kingdom) {
                [self.taxonKingdomCounts addObject:occurrence.Kingdom];
            }
            
            if (occurrence.Clazz) {
                [self.taxonClassCounts addObject:occurrence.Clazz];
            }
            
            if (occurrence.speciesBinomial) {
                [self.taxonSpeciesCounts addObject:occurrence.speciesBinomial];
//                [self.fullSpeciesBinomial addObject:occurrence];
            }
        }
/*
        NSLog(@"Record Type Counts: %@", [self.recordTypeCounts sortByCountAscending:NO]);
        NSLog(@"Record Source Counts: %@", [self.recordSourceCounts sortByCountAscending:NO]);
        NSLog(@"Full Species Binomial: %d", self.fullSpeciesBinomial.count);
        NSLog(@"Unique Species: %d", self.taxonSpeciesCounts.count);
        NSLog(@"Taxon Kingdom Counts: %@", [self.taxonKingdomCounts sortByCountAscending:NO]);
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


@end
