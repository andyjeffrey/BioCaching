//
//  INatManager.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INatManagerDelegate.h"

@interface INatManager : NSObject

@property (weak, nonatomic) id<INatManagerDelegate> delegate;

- (void)getTaxonForSpeciesName:(NSString *)speciesName;
- (void)addINatTaxonToGBIFOccurrence:(GBIFOccurrence *)occurrence;

@end
