//
//  GBIFOccurrence.h
//  BioCaching
//
//  Created by Andy Jeffrey on 12/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBIFOccurrence : NSObject

@property(nonatomic,strong) NSNumber * Key;
@property(nonatomic,strong) NSString * Kingdom;
@property(nonatomic,strong) NSString * Phylum;
@property(nonatomic,strong) NSString * Clazz;
@property(nonatomic,strong) NSString * Order;
@property(nonatomic,strong) NSString * Family;
@property(nonatomic,strong) NSString * Genus;
@property(nonatomic,strong) NSString * Species;
@property(nonatomic,strong) NSNumber * KingdomKey;
@property(nonatomic,strong) NSNumber * PhylumKey;
@property(nonatomic,strong) NSNumber * ClassKey;
@property(nonatomic,strong) NSNumber * OrderKey;
@property(nonatomic,strong) NSNumber * FamilyKey;
@property(nonatomic,strong) NSNumber * GenusKey;
@property(nonatomic,strong) NSNumber * SpeciesKey;
@property(nonatomic,strong) NSString * InstitutionCode;
@property(nonatomic,strong) NSString * CollectionCode;
@property(nonatomic,strong) NSString * CatalogNumber;
@property(nonatomic,strong) NSString * DatasetKey;
@property(nonatomic,strong) NSString * OwningOrgKey;
@property(nonatomic,strong) NSString * ScientificName;
@property(nonatomic,strong) NSNumber * NubKey;
@property(nonatomic,strong) NSString * BasisOfRecord;
@property(nonatomic,strong) NSNumber * Longitude;
@property(nonatomic,strong) NSNumber * Latitude;
@property(nonatomic,strong) NSString * Locality;
@property(nonatomic,strong) NSString * StateProvince;
@property(nonatomic,strong) NSString * Country;
@property(nonatomic,strong) NSString * Continent;
@property(nonatomic,strong) NSString * CollectorName;
@property(nonatomic,strong) NSString * IdentifierName;
@property(nonatomic,strong) NSNumber * OccurrenceYear;
@property(nonatomic,strong) NSNumber * OccurrenceMonth;
@property(nonatomic,strong) NSString * OccurrenceDate;
@property(nonatomic,strong) NSNumber * TaxonomicIssue;
@property(nonatomic,strong) NSNumber * GeospatialIssue;
@property(nonatomic,strong) NSNumber * OtherIssue;
@property(nonatomic,strong) NSString * Modified;
@property(nonatomic,strong) NSString * GBIFProtocol;
@property(nonatomic,strong) NSString * HostCountry;
//@property(nonatomic,strong) NSMutableArray * Identifiers;
//@property(nonatomic,strong) NSMutableArray * Images;
//@property(nonatomic,strong) NSMutableArray * TypeDesignations;
@property(nonatomic,strong) NSString * County;
@property(nonatomic,strong) NSNumber * Altitude;
@property(nonatomic,strong) NSNumber * Depth;

@property(nonatomic, strong, readonly) NSString *SpeciesBinomial;
@property(nonatomic, strong, readonly) NSString *MainTitle;
@property(nonatomic, strong, readonly) NSString *SubTitle;

+ (id) objectWithDictionary:(NSDictionary*)dictionary;
- (id) initWithDictionary:(NSDictionary*)dictionary;

@end
