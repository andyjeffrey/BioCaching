//
//  NSDate+Formatting.h
//  BioCaching
//
//  Created by Andy Jeffrey on 10/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatting)

+ (NSDate *)dateFromISO8601String:(NSString *)dateString;

- (NSString *)iso8601String;
- (NSString *)iso8601INatString;
- (NSString *)localDateTime;
- (NSString *)localDate;
- (NSString *)localTime;

@end
