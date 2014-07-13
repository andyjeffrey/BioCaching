#import "OccurrenceRecord.h"

@implementation OccurrenceRecord

@synthesize coordinate, title, subtitle, locationString;
@synthesize observation;

+ (id)createFromGBIFOccurrence:(GBIFOccurrence *)gbifOccurrence
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    OccurrenceRecord *occurrenceRecord = [NSEntityDescription insertNewObjectForEntityForName:@"OccurrenceRecord" inManagedObjectContext:managedObjectContext];
    
    occurrenceRecord.dateRecorded = [[NSDate dateFromISO8601String:gbifOccurrence.OccurrenceDate] copy];
    occurrenceRecord.gbifId = [gbifOccurrence.Key copy];
    occurrenceRecord.institutionCode = [gbifOccurrence.InstitutionCode copy];
    occurrenceRecord.latitude = [gbifOccurrence.Latitude copy];
    occurrenceRecord.longitude = [gbifOccurrence.Longitude copy];
    occurrenceRecord.recordSource = @"GBIF";
    occurrenceRecord.recordType = [gbifOccurrence.BasisOfRecord copy];
    occurrenceRecord.recordedBy = [gbifOccurrence.CollectorName copy];
    occurrenceRecord.taxonClass = [gbifOccurrence.Clazz copy];
    occurrenceRecord.taxonFamily = [gbifOccurrence.Family copy];
    occurrenceRecord.taxonGenus = [gbifOccurrence.Genus copy];
    occurrenceRecord.taxonKingdom = [gbifOccurrence.Kingdom copy];
    occurrenceRecord.taxonOrder = [gbifOccurrence.Order copy];
    occurrenceRecord.taxonPhylum = [gbifOccurrence.Phylum copy];
    occurrenceRecord.taxonSpecies = [gbifOccurrence.speciesBinomial copy];
    
    occurrenceRecord.iNatTaxon = gbifOccurrence.iNatTaxon;
    
    return occurrenceRecord;
}

#pragma mark - MKAnnotation Properties
- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
}
- (NSString *)title {
    return [self.iNatTaxon.commonName capitalizedString];
}
- (NSString *)subtitle {
    return [NSString stringWithFormat:@"%@ - %@",
                self.taxonClass, self.taxonSpecies];
}
- (NSString *)locationString {
    return [NSString stringWithFormat:@"%.6f %.6f", self.latitude.doubleValue, self.longitude.doubleValue];
}

- (INatObservation *)observation {
    return self.taxaAttribute.observation;
}


#pragma mark - Additional/Convenience Methods
- (NSString *)getINatIconicTaxaMainImageFile
{
    NSString *iNatIconicTaxaImageFile;
    
    if ([self.taxonKingdom isEqualToString:@"Fungi"]) {
        iNatIconicTaxaImageFile = @"iconic_taxon_fungi";
    } else if ([self.taxonKingdom isEqualToString:@"Plantae"]) {
        iNatIconicTaxaImageFile = @"iconic_taxon_plantae";
    } else if ([self.taxonKingdom isEqualToString:@"Animalia"]) {
        if ([self.taxonPhylum isEqualToString:@"Mollusca"]) {
            iNatIconicTaxaImageFile = @"iconic_taxon_mollusca";
        } else if ([self.taxonPhylum isEqualToString:@"Arthropoda"]) {
            if ([self.taxonClass isEqualToString:@"Insecta"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_insecta";
            } else if ([self.taxonClass isEqualToString:@"Arachnida"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_arachnida";
            }
        } else if ([self.taxonPhylum isEqualToString:@"Chordata"]) {
            if ([self.taxonClass isEqualToString:@"Mammalia"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_mammalia";
            } else if ([self.taxonClass isEqualToString:@"Amphibia"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_amphibia";
            } else if ([self.taxonClass isEqualToString:@"Aves"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_aves";
            } else if ([self.taxonClass isEqualToString:@"Reptilia"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_reptilia";
            } else if ([self.taxonClass isEqualToString:@"Actinopterygii"]) {
                iNatIconicTaxaImageFile = @"iconic_taxon_actinopterygii";
            }
        } else {
            iNatIconicTaxaImageFile = @"iconic_taxon_animalia";
        }
    } else {
        iNatIconicTaxaImageFile = @"iconic_taxon_unknown";
    }
    
    return iNatIconicTaxaImageFile;
}

- (NSString *)getINatIconicTaxaMapMarkerImageFile:(BOOL)highlighted
{
    NSString *mapMarkerImageFile;
    
    if ([self.taxonKingdom isEqualToString:@"Fungi"]) {
        mapMarkerImageFile = @"mapannotation_fungi_black";
    } else if ([self.taxonKingdom isEqualToString:@"Plantae"]) {
        mapMarkerImageFile = @"mapannotation_plantae_black";
    } else if ([self.taxonKingdom isEqualToString:@"Animalia"]) {
        if ([self.taxonPhylum isEqualToString:@"Mollusca"]) {
            mapMarkerImageFile = @"mapannotation_mollusca_black";
        } else if ([self.taxonPhylum isEqualToString:@"Arthropoda"]) {
            if ([self.taxonClass isEqualToString:@"Insecta"]) {
                mapMarkerImageFile = @"mapannotation_insecta_black";
            } else if ([self.taxonClass isEqualToString:@"Arachnida"]) {
                mapMarkerImageFile = @"mapannotation_arachnida_black";
            }
        } else if ([self.taxonPhylum isEqualToString:@"Chordata"]) {
            if ([self.taxonClass isEqualToString:@"Mammalia"]) {
                mapMarkerImageFile = @"mapannotation_mammalia_black";
            } else if ([self.taxonClass isEqualToString:@"Amphibia"]) {
                mapMarkerImageFile = @"mapannotation_amphibia_black";
            } else if ([self.taxonClass isEqualToString:@"Aves"]) {
                mapMarkerImageFile = @"mapannotation_aves_black";
            } else if ([self.taxonClass isEqualToString:@"Reptilia"]) {
                mapMarkerImageFile = @"mapannotation_reptilia_black";
            } else if ([self.taxonClass isEqualToString:@"Actinopterygii"]) {
                mapMarkerImageFile = @"mapannotation_actinopterygii_black";
            }
        } else {
            mapMarkerImageFile = @"mapannotation_animalia_black";
        }
    } else {
        mapMarkerImageFile = @"mapannotation_unknown_black";
    }
    
    if (highlighted) {
        mapMarkerImageFile = [mapMarkerImageFile stringByReplacingOccurrencesOfString:@"black" withString:@"white"];
    }
    
    return mapMarkerImageFile;
}


@end
