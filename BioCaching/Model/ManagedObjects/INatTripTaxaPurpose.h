#import "_INatTripTaxaPurpose.h"
#import "INatTaxon.h"

@interface INatTripTaxaPurpose : _INatTripTaxaPurpose {}

+ (id)createFromINatTaxon:(INatTaxon *)iNatTaxon;

@end
