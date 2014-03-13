//
//  GBIFOccurenceResultsBuilder.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBIFOccurrenceResults.h"

@interface GBIFOccurenceResultsBuilder : NSObject

+ (GBIFOccurrenceResults *)occurenceResultsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
