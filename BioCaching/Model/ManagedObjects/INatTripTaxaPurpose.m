#import "INatTripTaxaPurpose.h"


@interface INatTripTaxaPurpose ()

// Private interface goes here.

@end


@implementation INatTripTaxaPurpose

+ (id)createFromINatTaxon:(INatTaxon *)iNatTaxon
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    INatTripTaxaPurpose *taxaPurpose = [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxaPurpose" inManagedObjectContext:managedObjectContext];
    taxaPurpose.resourceType = @"Taxon";
    taxaPurpose.resourceId = iNatTaxon.recordId;
    taxaPurpose.complete = NO;
    
    return taxaPurpose;
}


@end
