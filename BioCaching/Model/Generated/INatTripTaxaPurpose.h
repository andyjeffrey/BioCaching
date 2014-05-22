//
//  INatTripTaxaPurpose.h
//  BioCaching
//
//  Created by Andy Jeffrey on 21/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BCManagedObject.h"


@interface INatTripTaxaPurpose : BCManagedObject

@property (nonatomic, retain) NSNumber * resourceType;
@property (nonatomic, retain) NSNumber * resourceId;
@property (nonatomic, retain) NSNumber * complete;

@end
