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
        
        _coordinate = CLLocationCoordinate2DMake(self.Latitude.doubleValue, self.Longitude.doubleValue);

    }
    return self;
}


- (NSString *)speciesBinomial
{
    return [self speciesBinomialSp];
}

- (NSString *)speciesBinomialSp
{
//    NSLog(@"<%@>", self.Species);

    long secondIndexSp = [self.Species secondIndexOf:@" "];
    
    if (secondIndexSp != NSNotFound) {
        return [self.Species substringToIndex:secondIndexSp];
    }
    
    return self.Species;
}

- (NSString *)speciesBinomialSn
{
//    NSLog(@"<%@>", self.ScientificName);
    
    long secondIndexSn = [self.ScientificName secondIndexOf:@" "];
    
    if (secondIndexSn != NSNotFound) {
//        NSLog(@"<%@>%ld", [self.ScientificName substringToIndex:secondIndexSn], secondIndexSn);
        return [self.ScientificName substringToIndex:secondIndexSn];
    } else {
//        NSLog(@"<%@>%ld", self.ScientificName, secondIndexSn);
    }
    
    return self.ScientificName;
}

- (NSString *)detailsMainTitle
{
    NSString *mainTitle = [NSString stringWithFormat:@"%@ - %@",
            self.Clazz, self.speciesBinomial];
    
    return mainTitle;
}

- (NSString *)detailsSubTitle
{
//    NSString *subTitle = [NSString stringWithFormat:@"%@ %@", self.Species, self.ScientificName];

    NSString *subTitle = [NSString stringWithFormat:@"%@  %@ %@  %@",
                          [self.OccurrenceDate substringToIndex:10],
                          self.Latitude,
                          self.Longitude,
//                          self.CatalogNumber,
                          self.InstitutionCode];

    return subTitle;
}

- (NSString *)locationString
{
    NSString *locationString = [NSString stringWithFormat:@"%f %f", self.coordinate.latitude, self.coordinate.longitude];
    return locationString;
}

- (NSString *)mapMarkerImageFile
{
    NSString *mapMarkerImageFile;
    
    if ([self.Kingdom isEqualToString:@"Plantae"]) {
        mapMarkerImageFile = @"mapannotation_green_black_solid_plants";
    } else if ([self.Kingdom isEqualToString:@"Animalia"]) {
        if ([self.Phylum isEqualToString:@"Mollusca"]) {
            mapMarkerImageFile = @"mapannotation_grey_black_solid";
        } else if ([self.Phylum isEqualToString:@"Arthropoda"]) {
            mapMarkerImageFile = @"mapannotation_red_black_solid";
        } else if ([self.Phylum isEqualToString:@"Chordata"]) {
            if ([self.Clazz isEqualToString:@"Mammalia"]) {
                mapMarkerImageFile = @"mapannotation_grey_black_solid";
            } else if ([self.Clazz isEqualToString:@"Amphibia"]) {
                mapMarkerImageFile = @"mapannotation_grey_black_solid";
            } else if ([self.Clazz isEqualToString:@"Aves"]) {
                mapMarkerImageFile = @"mapannotation_blue_black_solid_birds";
            } else if ([self.Clazz isEqualToString:@"Reptilia"]) {
                mapMarkerImageFile = @"mapannotation_grey_black_solid";
            } else if ([self.Clazz isEqualToString:@"Actinopterygii"]) {
                mapMarkerImageFile = @"mapannotation_blue_black_solid_fish";
            }
        } else {
                mapMarkerImageFile = @"mapannotation_blue_black_solid_unknown";        }
    }
    
//    mapMarkerImageFile = [mapMarkerImageFile stringByReplacingOccurrencesOfString:@"black" withString:@"white"];
    
    return mapMarkerImageFile;
}

- (NSString *)title {
    return self.detailsMainTitle;
}

- (NSString *)subtitle {
    return self.detailsSubTitle;
}

@end

