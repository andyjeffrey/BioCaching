#import "INatTripTaxaAttribute.h"


@interface INatTripTaxaAttribute ()

// Private interface goes here.

@end


@implementation INatTripTaxaAttribute

+ (id)createFromINatTaxon:(INatTaxon *)iNatTaxon
{
    NSManagedObjectContext *managedObjectContext = [[RKObjectManager sharedManager] managedObjectStore].mainQueueManagedObjectContext;
    
    INatTripTaxaAttribute *taxaAttribute = [NSEntityDescription insertNewObjectForEntityForName:@"INatTripTaxaAttribute" inManagedObjectContext:managedObjectContext];
    taxaAttribute.taxonId = [iNatTaxon.recordId copy];
    taxaAttribute.observed = NO;
    return taxaAttribute;
}

@end
