//
//  NSString+_UtilityMethods.m
//  BioCaching
//
//  Created by Andy Jeffrey on 10/03/2014.
//  Copyright (c) 2014 MPApps.net. All rights reserved.
//

#import "NSString+UtilityMethods.h"

@implementation NSString (UtilityMethods)

- (long)indexOf:(NSString *)subString
{
    NSRange firstInstance = [self rangeOfString:subString];
    return firstInstance.location;
}

- (long)secondIndexOf:(NSString *)subString
{
    NSRange secondInstance = [[self substringFromIndex:[self indexOf:subString] + subString.length] rangeOfString:subString];
    return secondInstance.location;
}

- (NSString *)getSubstringBetweenString:(NSString *)separator
{
    NSRange firstInstance = [self rangeOfString:separator];
    NSRange secondInstance = [[self substringFromIndex:firstInstance.location + firstInstance.length] rangeOfString:separator];
    NSRange finalRange = NSMakeRange(firstInstance.location + separator.length, secondInstance.location);
    
    return [self substringWithRange:finalRange];
}

@end
