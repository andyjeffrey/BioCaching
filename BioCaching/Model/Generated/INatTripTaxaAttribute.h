//
//  INatTripTaxaAttribute.h
//  BioCaching
//
//  Created by Andy Jeffrey on 27/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

@class INatTrip;

@interface INatTripTaxaAttribute : BCManagedObject

@property (nonatomic, retain) NSNumber * observed;
@property (nonatomic, retain) NSNumber * taxonId;
@property (nonatomic, retain) INatTrip *trip;

@end
