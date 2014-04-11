//
//  INatManagerDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 08/04/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INatTaxon;
@class GBIFOccurrence;

@protocol INatManagerDelegate <NSObject>

- (void)iNatTaxonReceived:(INatTaxon *)iNatTaxon;
- (void)iNatTaxonAddedToGBIFOccurrence:(GBIFOccurrence *)gbifOccurrence;
//- (void)iNatTaxonSearchFailedWithError:(NSError *)error;

@end
