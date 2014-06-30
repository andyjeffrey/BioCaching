//
//  NSDate+Formatting.m
//  BioCaching
//
//  Created by Andy Jeffrey on 10/06/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "NSDate+Formatting.h"

#define formatDateTime @"MMM dd, yyyy HH:mm"
#define formatTime @"HH:mm"
#define formatISO8601 @"yyyy-MM-dd'T'HH:mm:ss.sZZZZZ"

@implementation NSDate (Formatting)

+ (NSDate *)dateFromISO8601String:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatISO8601;
    return [formatter dateFromString:dateString];
}

- (NSString *)localDateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatDateTime;
    return [formatter stringFromDate:self];
}

- (NSString *)localTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatTime;
    return [formatter stringFromDate:self];
}

@end
