//
//  INatTripTaxaAttribute.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BCManagedObject.h"


@interface INatTripTaxaAttribute : BCManagedObject

@property (nonatomic, retain) NSNumber * taxonId;
@property (nonatomic, retain) NSNumber * observed;

@end
