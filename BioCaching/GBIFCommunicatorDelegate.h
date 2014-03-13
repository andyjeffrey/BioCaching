//
//  GBIFCommunicatorDelegate.h
//  BioCaching
//
//  Created by Andy Jeffrey on 07/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GBIFCommunicatorDelegate
- (void)receivedResultsJSON:(NSData *)objectNotation;
- (void)fetchingResultsFailedWithError:(NSError *)error;
@end
