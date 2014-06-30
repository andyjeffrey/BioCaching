#import "OccurrenceRecord.h"


@interface OccurrenceRecord ()

// Private interface goes here.

@end

@implementation OccurrenceRecord

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

@end
