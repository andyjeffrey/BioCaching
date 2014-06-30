#import "_INatTripTaxaAttribute.h"
#import "INatTaxon.h"

@interface INatTripTaxaAttribute : _INatTripTaxaAttribute {}

+ (id)createFromINatTaxon:(INatTaxon *)iNatTaxon;

@end
