//
//  INatManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "INatManager.h"
//#import "AFNetworking.h"
#import "INatTaxon.h"
#import "GBIFOccurrence.h"

static NSString * const kTaxaSearchQuery = @"taxa/search.json?q=";

@implementation INatManager {
    NSManagedObjectContext *managedObjectContext;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    }
    return self;
}

- (void)getTaxonForSpeciesName:(NSString *)speciesName
{
    
}

- (void)addINatTaxonToGBIFOccurrence:(GBIFOccurrence *)occurrence
{
    INatTaxon *primaryTaxon = [self getTaxonFromLocalStore:occurrence.speciesBinomial];
    
    if (primaryTaxon) {
        [self addTaxonToOccurrenceAndCallDelegate:primaryTaxon occurrence:occurrence];
    } else {
        NSString *taxaSearchPath = [NSString stringWithFormat:@"%@%@",
                                    kTaxaSearchQuery,
                                    [occurrence.speciesBinomial stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [[RKObjectManager sharedManager] getObjectsAtPath:taxaSearchPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSError *error = nil;
            
            RKLogInfo(@"Taxa Search Returned %d results", (int)mappingResult.array.count);
            // INatTaxon MOs automatically created for all search results using RestKit, so remove all but first
            INatTaxon *primaryTaxon = mappingResult.firstObject;
            for (INatTaxon *taxon in mappingResult.array) {
                if (taxon == primaryTaxon) {
                    taxon.searchName = occurrence.speciesBinomial;
                    taxon.localCreatedAt = [NSDate date];
                } else if (taxon) {
                    [managedObjectContext deleteObject:taxon];
                    NSLog(@"Taxon Object Deleted: \n%d-%@", (int)taxon.recordId, taxon.objectID);
                }
            }
            if (![managedObjectContext saveToPersistentStore:&error]) {
                RKLogError(@"Error Saving Changes To Store: %@", error);
            } else {
                if (primaryTaxon) {
                    RKLogInfo(@"INatTaxon Entity Saved To Store: %@-%@", primaryTaxon.recordId, primaryTaxon.name);
                    [BCLoggingHelper recordGoogleEvent:@"INAT" action:[NSString stringWithFormat:@"Taxon Received: %d (%d)", primaryTaxon.recordId.intValue, occurrence.SpeciesKey.intValue] value:[NSNumber numberWithInt:1]];
                } else {
                    [BCLoggingHelper recordGoogleEvent:@"INAT" action:[NSString stringWithFormat:@"Taxon Not Found: (%d)", occurrence.SpeciesKey.intValue] value:[NSNumber numberWithInt:0]];
                    [BCLoggingHelper recordGoogleEvent:@"INAT" action:@"Taxon Not Found" value:occurrence.SpeciesKey];
                }
                [self addTaxonToOccurrenceAndCallDelegate:primaryTaxon occurrence:occurrence];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Error Performing Taxa Search: %@", error);
            [BCLoggingHelper recordGoogleEvent:@"INAT" action:[NSString stringWithFormat:@"Taxon Lookup Error: (%d)", occurrence.SpeciesKey.intValue] value:[NSNumber numberWithInt:0]];
        }];
    }
}

- (void)addTaxonToOccurrenceAndCallDelegate:(INatTaxon *)taxon occurrence:(GBIFOccurrence *)occurrence
{
    occurrence.iNatTaxon = taxon;
    [self.delegate iNatTaxonAddedToGBIFOccurrence:occurrence];
}

- (INatTaxon *)getTaxonFromLocalStore:(NSString *)speciesName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"INatTaxon" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchName = %@", speciesName];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil || fetchedObjects.count == 0) {
        NSLog(@"No INatTaxon Found In Local Store:%@", speciesName);
        return nil;
    } else {
        return fetchedObjects[0];
    }
}


/*
- (void)addINatTaxonToGBIFOccurrence:(GBIFOccurrence *)occurrence
{
    NSURLRequest *request = [self buildTaxaSearchRequest:occurrence.speciesBinomial];

    // AFNetworking 2.0
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        occurrence.iNatTaxon = [self buildINatTaxonFromJSON:responseObject taxonSearchString:occurrence.speciesBinomial];
        [self.delegate iNatTaxonAddedToGBIFOccurrence:occurrence];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"iNat API Error: %@", error);
    }];

    // AFNetworking 1.3 (As used by RestKit)
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        occurrence.iNatTaxon = [self buildINatTaxonFromJSON:JSON taxonSearchString:occurrence.speciesBinomial];
        [self.delegate iNatTaxonAddedToGBIFOccurrence:occurrence];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"iNat API Error: %@", error);
    }];
    
//    NSLog(@"INat API Call Initiated");
    [operation start];
}

- (NSURLRequest *)buildTaxaSearchRequest:(NSString *)speciesName
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",
                           kINatBaseURL,
                           kTaxaSearchQuery,
                           [speciesName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           ];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    return request;
}

- (INatTaxon *)buildINatTaxonFromJSON:(NSData *)responseJSON taxonSearchString:(NSString *)speciesName{
//    NSLog(@"iNat Response Received: %@", responseJSON);

    INatTaxon *iNatTaxon = nil;
    NSError *error = nil;

    NSArray *resultsArray = (NSArray *)responseJSON;
    
    if (resultsArray.count > 0) {
        iNatTaxon = [INatTaxon createFromDictionary:resultsArray[0] error:&error];
        if (error) {
            NSLog(@"INatManager:buildINatTaxonFromJSON: %@", error.debugDescription);
        } else {
//            NSLog(@"INatTaxon Created:%@ - %@", iNatTaxon.name, iNatTaxon.common_name);
        }
    } else {
        NSLog(@"%s No Taxon Results For Species: %@", __PRETTY_FUNCTION__, speciesName);
    }
    
    return iNatTaxon;
}
*/
 
@end
