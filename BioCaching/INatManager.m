//
//  INatManager.m
//  BioCaching
//
//  Created by Andy Jeffrey on 07/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "INatManager.h"
#import "AFNetworking.h"
#import "INatTaxon.h"
#import "GBIFOccurrence.h"

static NSString * const kBaseURLString = @"http://www.inaturalist.org/";
static NSString * const kTaxaSearchQuery = @"taxa/search.json?q=";

@implementation INatManager

- (void)addINatTaxonToGBIFOccurrence:(GBIFOccurrence *)occurrence
{
    NSURLRequest *request = [self buildTaxaSearchRequest:occurrence.speciesBinomial];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        occurrence.iNatTaxon = [self buildINatTaxonFromJSON:responseObject taxonSearchString:occurrence.speciesBinomial];
        [self.delegate iNatTaxonAddedToGBIFOccurrence:occurrence];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"iNat API Error: %@", error);
    }];
    
    NSLog(@"INat API Call Initiated");
    [operation start];
    
}

- (void)getTaxonForSpeciesName:(NSString *)speciesName
{
    NSURLRequest *request = [self buildTaxaSearchRequest:speciesName];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        INatTaxon *iNatTaxon = [self buildINatTaxonFromJSON:responseObject taxonSearchString:speciesName];
        [self.delegate iNatTaxonReceived:iNatTaxon];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"iNat API Error: %@", error);
    }];
    
    NSLog(@"INat API Call Initiated");
    [operation start];
}

- (NSURLRequest *)buildTaxaSearchRequest:(NSString *)speciesName
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",
                           kBaseURLString,
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
        iNatTaxon = [[INatTaxon alloc] initWithDictionary:resultsArray[0] error:&error];
        if (error) {
            NSLog(@"INatManager:buildINatTaxonFromJSON: %@", error.debugDescription);
        } else {
            NSLog(@"INatTaxon Created:%@ - %@",
                  iNatTaxon.name,
                  iNatTaxon.common_name);
        }
    } else {
        NSLog(@"%s No Taxon Results For Species: %@", __PRETTY_FUNCTION__, speciesName);
    }
    
    
    
    return iNatTaxon;
}

@end
