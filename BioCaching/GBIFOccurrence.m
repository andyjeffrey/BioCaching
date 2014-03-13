//
//  GBIFOccurrence.m
//  BioCaching
//
//  Created by Andy Jeffrey on 12/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "GBIFOccurrence.h"

@implementation GBIFOccurrence

@synthesize Key;
@synthesize Kingdom;
@synthesize Phylum;
@synthesize Clazz;
@synthesize Order;
@synthesize Family;
@synthesize Genus;
@synthesize Species;
@synthesize KingdomKey;
@synthesize PhylumKey;
@synthesize ClassKey;
@synthesize OrderKey;
@synthesize FamilyKey;
@synthesize GenusKey;
@synthesize SpeciesKey;
@synthesize InstitutionCode;
@synthesize CollectionCode;
@synthesize CatalogNumber;
@synthesize DatasetKey;
@synthesize OwningOrgKey;
@synthesize ScientificName;
@synthesize NubKey;
@synthesize BasisOfRecord;
@synthesize Longitude;
@synthesize Latitude;
@synthesize Locality;
@synthesize StateProvince;
@synthesize Country;
@synthesize Continent;
@synthesize CollectorName;
@synthesize IdentifierName;
@synthesize OccurrenceYear;
@synthesize OccurrenceMonth;
@synthesize OccurrenceDate;
@synthesize TaxonomicIssue;
@synthesize GeospatialIssue;
@synthesize OtherIssue;
@synthesize Modified;
@synthesize GBIFProtocol;
@synthesize HostCountry;
//@synthesize Identifiers;
//@synthesize Images;
//@synthesize TypeDesignations;
@synthesize County;
@synthesize Altitude;
@synthesize Depth;

+ (id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[GBIFOccurrence alloc] initWithDictionary:dictionary];
    return obj;
}

- (id) initWithDictionary:(NSDictionary*)dictionary
{
    self=[super init];
    if(self)
    {
        Key = [dictionary objectForKey:@"key"];
        Kingdom = [dictionary objectForKey:@"kingdom"];
        Phylum = [dictionary objectForKey:@"phylum"];
        Clazz = [dictionary objectForKey:@"clazz"];
        Order = [dictionary objectForKey:@"order"];
        Family = [dictionary objectForKey:@"family"];
        Genus = [dictionary objectForKey:@"genus"];
        Species = [dictionary objectForKey:@"species"];
        KingdomKey = [dictionary objectForKey:@"kingdomKey"];
        PhylumKey = [dictionary objectForKey:@"phylumKey"];
        ClassKey = [dictionary objectForKey:@"classKey"];
        OrderKey = [dictionary objectForKey:@"orderKey"];
        FamilyKey = [dictionary objectForKey:@"familyKey"];
        GenusKey = [dictionary objectForKey:@"genusKey"];
        SpeciesKey = [dictionary objectForKey:@"speciesKey"];
        InstitutionCode = [dictionary objectForKey:@"institutionCode"];
        CollectionCode = [dictionary objectForKey:@"collectionCode"];
        CatalogNumber = [dictionary objectForKey:@"catalogNumber"];
        DatasetKey = [dictionary objectForKey:@"datasetKey"];
        OwningOrgKey = [dictionary objectForKey:@"owningOrgKey"];
        ScientificName = [dictionary objectForKey:@"scientificName"];
        NubKey = [dictionary objectForKey:@"nubKey"];
        BasisOfRecord = [dictionary objectForKey:@"basisOfRecord"];
        Longitude = [dictionary objectForKey:@"longitude"];
        Latitude = [dictionary objectForKey:@"latitude"];
        Locality = [dictionary objectForKey:@"locality"];
        StateProvince = [dictionary objectForKey:@"stateProvince"];
        Country = [dictionary objectForKey:@"country"];
        Continent = [dictionary objectForKey:@"continent"];
        CollectorName = [dictionary objectForKey:@"collectorName"];
        IdentifierName = [dictionary objectForKey:@"identifierName"];
        OccurrenceYear = [dictionary objectForKey:@"occurrenceYear"];
        OccurrenceMonth = [dictionary objectForKey:@"occurrenceMonth"];
        OccurrenceDate = [dictionary objectForKey:@"occurrenceDate"];
        TaxonomicIssue = [dictionary objectForKey:@"taxonomicIssue"];
        GeospatialIssue = [dictionary objectForKey:@"geospatialIssue"];
        OtherIssue = [dictionary objectForKey:@"otherIssue"];
        Modified = [dictionary objectForKey:@"modified"];
        GBIFProtocol = [dictionary objectForKey:@"protocol"];
        HostCountry = [dictionary objectForKey:@"hostCountry"];
        /*
         NSArray* temp =  [dictionary objectForKey:@"Identifiers"];
         Identifiers =  [[NSMutableArray alloc] init];
         for (NSDictionary *d in temp) {
         [Identifiers addObject:d];
         }
         
         temp =  [dictionary objectForKey:@"Images"];
         Images =  [[NSMutableArray alloc] init];
         for (NSDictionary *d in temp) {
         [Images addObject:d];
         }
         
         temp =  [dictionary objectForKey:@"TypeDesignations"];
         TypeDesignations =  [[NSMutableArray alloc] init];
         for (NSDictionary *d in temp) {
         [TypeDesignations addObject:d];
         }
         */
        County = [dictionary objectForKey:@"county"];
        Altitude = [dictionary objectForKey:@"altitude"];
        Depth = [dictionary objectForKey:@"depth"];
    }
    return self;
}

- (NSString *)SpeciesBinomial
{
    long secondIndex = [self.Species secondIndexOf:@" "];
    if (secondIndex < self.Species.length) {
        return [self.Species substringToIndex:secondIndex];
    }
    return self.Species;
}


@end

