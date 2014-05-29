//
//  INatTripTaxaPurpose.h
//  BioCaching
//
//  Created by Andy Jeffrey on 27/05/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BCManagedObject.h"

@class INatTrip;

@interface INatTripTaxaPurpose : BCManagedObject

@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) NSNumber * resourceId;
@property (nonatomic, retain) NSString * resourceType;
@property (nonatomic, retain) INatTrip *trip;

@end
