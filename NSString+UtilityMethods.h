//
//  NSString+_UtilityMethods.h
//  BioCaching
//
//  Created by Andy Jeffrey on 10/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UtilityMethods)

- (long)indexOf:(NSString *)subString;
- (long)secondIndexOf:(NSString *)subString;
- (NSString *)getSubstringBetweenString:(NSString *)separator;

@end
